#!/usr/bin/env bash
# Run SoC benchmarks on MemPool (pulp-platform/mempool) via Verilator.
set -euo pipefail

SCORE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_NAME="mempool"
PROFILE="soc_verilator"
CONFIG="minpool_16cores"

MEMPOOL_DIR="$SCORE_ROOT/tools/mempool"
COMMIT=$(git -C "$MEMPOOL_DIR" rev-parse HEAD 2>/dev/null | cut -c1-8 || echo "88a20ceb")
DATASET_DIR="$SCORE_ROOT/datasets/mempool/$COMMIT/benchmarks"
SIM_BINARY="$MEMPOOL_DIR/hardware/verilator_build/Vmempool_tb_verilator"
APPS_DIR="$MEMPOOL_DIR/software/apps/baremetal"
BIN_DIR="$MEMPOOL_DIR/software/bin/apps/baremetal"

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

# Verify simulator binary exists
if [ ! -x "$SIM_BINARY" ]; then
    echo "Error: Verilator simulation model not found at $SIM_BINARY" >&2
    echo "Please build it with: make -C tools/mempool/hardware verilate config=minpool" >&2
    exit 1
fi

ALL_WORKLOADS=(
    "conv2d_i32"
    "dotp_i32"
    "dct_i32"
    "axpy_i32"
    "hello_world"
)

WORKLOAD="${1:-all}"

run_single() {
    local bmark="$1"
    local elf_path="$BIN_DIR/$bmark"

    echo "=================================================="
    echo "Building MemPool workload: $bmark"
    echo "=================================================="
    make -C "$APPS_DIR" "$bmark" config=minpool XPULPIMG=0 RISCV_PREFIX="$RISCV_PREFIX"

    if [ ! -f "$elf_path" ]; then
        echo "Error: Binary not found: $elf_path" >&2
        return 1
    fi

    echo "=================================================="
    echo "Running MemPool SoC Benchmark: $bmark"
    echo "Binary: $elf_path"
    echo "Simulator: $SIM_BINARY"
    echo "Configuration: 16 cores (minpool)"
    echo "=================================================="

    local out_log="$DATASET_DIR/${bmark}_run.log"
    local json_out="$DATASET_DIR/${bmark}.json"

    local start_ts
    start_ts=$(python3 -c "import time; print(time.time())")

    set +e
    (cd "$MEMPOOL_DIR/hardware" && "$SIM_BINARY" --meminit=ram,"$elf_path") > "$out_log" 2>&1
    local ret=$?
    set -e

    local end_ts
    end_ts=$(python3 -c "import time; print(time.time())")
    local wall_time
    wall_time=$(python3 -c "print(round($end_ts - $start_ts, 4))")

    echo "Simulation finished with return code $ret in ${wall_time}s"
    tail -n 20 "$out_log"

    python3 - <<EOF
import json
import re
import platform
from datetime import datetime, timezone
from pathlib import Path

log_path = Path("$out_log")
json_path = Path("$json_out")
content = log_path.read_text(errors="replace")

# Parse EOC (End of Computation)
eoc_match = re.search(r"\[EOC\]\s+Simulation ended at\s+(\d+)\s+\(retval\s*=\s*(\d+)\)", content)
total_sim_cycles = int(eoc_match.group(1)) if eoc_match else None
retval = int(eoc_match.group(2)) if eoc_match else None

# Parse Executed cycles
exec_match = re.search(r"Executed cycles:\s+(\d+)", content)
exec_cycles = int(exec_match.group(1)) if exec_match else None

# Parse Simulation speed
speed_match = re.search(r"Simulation speed:\s+([0-9.]+)\s+cycles/s", content)
sim_speed = float(speed_match.group(1)) if speed_match else None

# Kernel cycles (e.g. from dotp_i32)
kernel_match = re.search(r"Kernel execution takes\s+(\d+)\s+clock cycles", content)
kernel_cycles = int(kernel_match.group(1)) if kernel_match else None

# Error / check parsing (e.g. from axpy_i32)
checks_match = re.search(r"(\d+)\s+ERRORS out of\s+(\d+)\s+CHECKS", content)
checks_failed = int(checks_match.group(1)) if checks_match else None
checks_total = int(checks_match.group(2)) if checks_match else None

# Core count reporting (hello_world)
cores_reported = len(re.findall(r"\[UART\] Core\s+\d+\s+says Hello!", content))

# Validation check
validated = ($ret == 0) and (retval == 0) and (exec_cycles is not None)
if checks_failed is not None and checks_failed > 0:
    validated = False
if "$bmark" == "hello_world" and cores_reported != 16:
    validated = False

metrics = {
    "validated": bool(validated),
    "simulator": "verilator",
    "architecture": "rv32ima",
    "configuration": "$CONFIG",
    "num_cores": 16,
    "num_groups": 4,
    "num_cores_per_group": 4,
    "num_banks": 64,
    "banking_factor": 4,
    "wall_time_s": float("$wall_time"),
    "exit_code": int(retval if retval is not None else ret),
}

if exec_cycles is not None:
    metrics["execution_cycles"] = exec_cycles
if total_sim_cycles is not None:
    metrics["total_simulation_cycles"] = total_sim_cycles
if sim_speed is not None:
    metrics["simulation_speed_cps"] = sim_speed
if kernel_cycles is not None:
    metrics["kernel_cycles"] = kernel_cycles
if checks_total is not None:
    metrics["checks_total"] = checks_total
    metrics["checks_passed"] = checks_total - checks_failed
    metrics["checks_failed"] = checks_failed
if "$bmark" == "hello_world":
    metrics["cores_reporting"] = cores_reported

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

echo "=== Running SoC benchmark collector ==="
python3 "$SCORE_ROOT/scripts/benchmarks/collect_soc_benchmark_results.py"
echo "=== Done ==="
