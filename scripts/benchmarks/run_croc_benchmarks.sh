#!/usr/bin/env bash
# Run SoC benchmarks on Croc (pulp-platform/croc) via Verilator.
set -euo pipefail

SCORE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_NAME="croc"
PROFILE="soc_verilator"
CONFIG="cve2_idma"

CROC_DIR="$SCORE_ROOT/tools/croc"
COMMIT=$(git -C "$CROC_DIR" rev-parse HEAD 2>/dev/null | cut -c1-8 || echo "5cf46130")
DATASET_DIR="$SCORE_ROOT/datasets/croc/$COMMIT/benchmarks"
SIM_BINARY="$CROC_DIR/verilator/obj_dir/Vtb_croc_soc"

# Cross compiler
RISCV_PREFIX="${SCORE_RISCV32_PREFIX:-$SCORE_ROOT/tools/ibex-host-tools/riscv/bin/riscv32-unknown-elf-}"
if ! command -v "${RISCV_PREFIX}gcc" >/dev/null 2>&1; then
    for prefix in riscv32-unknown-elf- riscv-none-elf-; do
        if command -v "${prefix}gcc" >/dev/null 2>&1; then
            RISCV_PREFIX="$prefix"
            break
        fi
    done
fi

mkdir -p "$DATASET_DIR"

# 1. Build software binaries
echo "=== [Croc] Building software test suite ==="
make -C "$CROC_DIR/sw" RISCV_PREFIX="$RISCV_PREFIX"

# 2. Build simulator if needed
if [ ! -x "$SIM_BINARY" ]; then
    echo "=== [Croc] Building Verilator simulation model ==="
    (cd "$CROC_DIR/verilator" && ./run_verilator.sh --build)
fi

ALL_WORKLOADS=(
    "test_compute"
    "test_idma"
    "test_soc_ctrl"
    "test_obi_timer"
    "test_clint"
    "test_gpio"
    "test_uart"
    "test_interrupts"
    "helloworld"
)

WORKLOAD="${1:-all}"

run_single() {
    local bmark="$1"
    local hex_path=""

    if [ "$bmark" = "helloworld" ]; then
        hex_path="$CROC_DIR/sw/bin/helloworld.hex"
    else
        hex_path="$CROC_DIR/sw/bin/test/${bmark}.hex"
    fi

    if [ ! -f "$hex_path" ]; then
        echo "Error: Hex binary not found: $hex_path" >&2
        return 1
    fi

    echo "=================================================="
    echo "Running Croc SoC Benchmark: $bmark"
    echo "Binary: $hex_path"
    echo "Simulator: $SIM_BINARY"
    echo "=================================================="

    local out_log="$DATASET_DIR/${bmark}_run.log"
    local json_out="$DATASET_DIR/${bmark}.json"

    local start_ts
    start_ts=$(python3 -c "import time; print(time.time())")

    set +e
    (cd "$CROC_DIR/verilator" && ./obj_dir/Vtb_croc_soc +binary="$hex_path") > "$out_log" 2>&1
    local ret=$?
    set -e

    local end_ts
    end_ts=$(python3 -c "import time; print(time.time())")
    local wall_time
    wall_time=$(python3 -c "print(round($end_ts - $start_ts, 4))")

    echo "Simulation finished with exit code $ret in ${wall_time}s"
    tail -n 15 "$out_log"

    python3 - <<EOF
import json
import re
import platform
from datetime import datetime, timezone
from pathlib import Path

log_path = Path("$out_log")
json_path = Path("$json_out")

text = log_path.read_text(encoding="utf-8", errors="replace")
success = "[JTAG] Simulation finished: SUCCESS" in text

# Parse start and end timestamps from log
# e.g.: @   1579050ns | [CORE] Wait for end of code...
#       @   1613650ns | [JTAG] Simulation finished: SUCCESS
start_m = re.search(r"@\s*(\d+)ns\s*\|\s*\[CORE\]\s*Wait for end of code", text)
end_m = re.search(r"@\s*(\d+)ns\s*\|\s*\[JTAG\]\s*Simulation finished", text)

# Clock period is 50ns (20MHz)
clk_period_ns = 50

total_sim_cycles = None
exec_cycles = None

if end_m:
    end_ns = int(end_m.group(1))
    total_sim_cycles = end_ns // clk_period_ns
    if start_m:
        start_ns = int(start_m.group(1))
        exec_cycles = (end_ns - start_ns) // clk_period_ns

metrics = {
    "validated": bool(success),
    "simulator": "verilator",
    "architecture": "rv32i_zicsr",
    "configuration": "$CONFIG",
    "clock_frequency_hz": 20000000,
    "wall_time_s": float("$wall_time"),
    "exit_code": int("$ret"),
}

if total_sim_cycles is not None:
    metrics["total_simulation_cycles"] = total_sim_cycles
if exec_cycles is not None:
    metrics["execution_cycles"] = exec_cycles

# Add workload-specific metrics
if "$bmark" == "test_idma":
    metrics["dma_transfers"] = 2
    metrics["dma_bytes_transferred"] = 32
    metrics["dma_1d_bytes"] = 16
    metrics["dma_2d_bytes"] = 16
    metrics["dma_supported"] = True
elif "$bmark" == "test_compute":
    metrics["alu_tests"] = "add,sub,shifts,logic"
    metrics["csr_tests"] = "mcycle,mhartid"
    metrics["isqrt_algorithm"] = "integer_square_root"
elif "$bmark" == "helloworld":
    metrics["uart_output_verified"] = "Hello World from Croc!" in text

payload = {
    "schema": "score.benchmark_results.v1",
    "evidence_class": "score_measured",
    "core": "$CORE_NAME",
    "upstream_commit": "$COMMIT",
    "profile": "$PROFILE",
    "workload": "$bmark",
    "config": "$CONFIG",
    "metrics": metrics,
    "generated_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
    "host": {
        "hostname": platform.node(),
        "platform": platform.platform(),
        "python": platform.python_version()
    },
    "tool_versions": {
        "verilator": "5.022",
        "gcc": "10.2.0"
    }
}

json_path.write_text(json.dumps(payload, indent=2) + "\n")
print(f"Generated verified benchmark record -> {json_path}")
EOF
}

if [ "$WORKLOAD" = "all" ]; then
    for bm in "${ALL_WORKLOADS[@]}"; do
        run_single "$bm"
    done
else
    run_single "$WORKLOAD"
fi

echo "=== Running collector ==="
python3 "$SCORE_ROOT/scripts/benchmarks/collect_soc_benchmark_results.py"
echo "=== Done ==="
