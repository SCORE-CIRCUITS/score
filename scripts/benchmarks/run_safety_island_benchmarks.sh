#!/usr/bin/env bash
# Run SoC benchmarks on Safety Island (pulp-platform/safety-island) via Verilator.
set -euo pipefail

SCORE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_NAME="safety_island"
PROFILE="soc_verilator"
CONFIG="cv32e40p_tcls"

SI_DIR="$SCORE_ROOT/tools/safety-island"
COMMIT=$(git -C "$SI_DIR" rev-parse HEAD 2>/dev/null | cut -c1-8 || echo "584eb697")
DATASET_DIR="$SCORE_ROOT/datasets/safety_island/$COMMIT/benchmarks"
SIM_DIR="$SCORE_ROOT/scripts/assets/safety_island"
SIM_BINARY="$SIM_DIR/obj_dir/Vtb_safety_island_verilator"

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
echo "=== [Safety Island] Building software test suite ==="
make -C "$SIM_DIR/sw" RISCV_PREFIX="$RISCV_PREFIX"

# 2. Build simulator if needed
if [ ! -x "$SIM_BINARY" ]; then
    echo "=== [Safety Island] Building Verilator simulation model ==="
    mkdir -p "$SIM_DIR/obj_dir"
    verilator \
        -Wno-fatal \
        -Wno-style \
        -Wno-BLKANDNBLK \
        -Wno-WIDTHEXPAND \
        -Wno-WIDTHTRUNC \
        -Wno-WIDTHCONCAT \
        -Wno-ASCRANGE \
        -Wno-CASEINCOMPLETE \
        -Wno-DECLFILENAME \
        -Wno-PINCONNECTEMPTY \
        -Wno-PINMISSING \
        -Wno-IMPLICIT \
        -Wno-UNDRIVEN \
        -Wno-UNUSEDSIGNAL \
        -Wno-UNUSEDPARAM \
        -Wno-SYNCASYNCNET \
        -Wno-UNOPTFLAT \
        -Wno-COMBDLY \
        -Wno-SELRANGE \
        -Wno-CMPCONST \
        -Wno-UNSIGNED \
        --binary \
        -j 8 \
        --timing \
        --autoflush \
        -O3 \
        --Mdir "$SIM_DIR/obj_dir" \
        --top tb_safety_island_verilator \
        -f "$SIM_DIR/safety_island.f"
fi

ALL_WORKLOADS=(
    "hello"
    "coremark"
)

WORKLOAD="${1:-all}"

run_single() {
    local bmark="$1"
    local hex_path="$SIM_DIR/sw/bin/${bmark}.hex"

    if [ ! -f "$hex_path" ]; then
        echo "Error: Hex binary not found: $hex_path" >&2
        return 1
    fi

    echo "=================================================="
    echo "Running Safety Island SoC Benchmark: $bmark"
    echo "Binary: $hex_path"
    echo "Simulator: $SIM_BINARY"
    echo "=================================================="

    local out_log="$DATASET_DIR/${bmark}_run.log"
    local json_out="$DATASET_DIR/${bmark}.json"

    local start_ts
    start_ts=$(python3 -c "import time; print(time.time())")

    set +e
    "$SIM_BINARY" +hex="$hex_path" > "$out_log" 2>&1
    local ret=$?
    set -e

    local end_ts
    end_ts=$(python3 -c "import time; print(time.time())")
    local wall_time
    wall_time=$(python3 -c "print(round($end_ts - $start_ts, 4))")

    echo "Simulation finished with exit code $ret in ${wall_time}s"
    tail -n 25 "$out_log"

    python3 - <<EOF
import json
import re
import platform
from datetime import datetime, timezone
from pathlib import Path

log_path = Path("$out_log")
json_path = Path("$json_out")
text = log_path.read_text(errors="ignore") if log_path.exists() else ""

status = "passed" if ($ret == 0 and "SUCCESS: Test completed with code 0" in text) else "failed"

# Extract cycles and instructions
total_cycles_m = re.search(r"Total execution cycles:\s*(\d+)", text)
exec_cycles = int(total_cycles_m.group(1)) if total_cycles_m else None

sim_cycles_m = re.search(r"Total cycles:\s*(\d+)", text)
total_sim_cycles = int(sim_cycles_m.group(1)) if sim_cycles_m else None

instr_m = re.search(r"Total retired instructions:\s*(\d+)", text)
retired_inst = int(instr_m.group(1)) if instr_m else None

cpi_m = re.search(r"CPI:\s*([\d\.]+)", text)
cpi = float(cpi_m.group(1)) if cpi_m else None

# If not in metrics block, use total sim cycles
if exec_cycles is None and total_sim_cycles is not None:
    exec_cycles = total_sim_cycles

metrics = {
    "execution_cycles": exec_cycles,
    "total_simulation_cycles": total_sim_cycles,
    "wall_time_sec": $wall_time,
}

if retired_inst is not None:
    metrics["retired_instructions"] = retired_inst
if cpi is not None:
    metrics["cpi"] = cpi

# Extract CoreMark Iterations/Sec if present
cm_score_m = re.search(r"Iterations/Sec\s*:\s*([\d\.]+)", text)
if cm_score_m:
    metrics["iterations_per_sec"] = float(cm_score_m.group(1))

payload = {
    "schema": "score.benchmark_results.v1",
    "core": "$CORE_NAME",
    "architecture": "rv32imc",
    "profile": "$PROFILE",
    "benchmark": "$bmark",
    "configuration": "$CONFIG",
    "environment": {
        "hostname": platform.node(),
        "os": platform.platform(),
        "simulator": "verilator-5.022",
        "toolchain": "$RISCV_PREFIX"
    },
    "metrics": metrics,
    "status": status,
    "run_at_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat()
}

json_path.write_text(json.dumps(payload, indent=2) + "\n")
print(f"Generated schema-compliant benchmark report: {json_path}")
EOF
}

if [ "$WORKLOAD" = "all" ]; then
    for w in "${ALL_WORKLOADS[@]}"; do
        run_single "$w"
    done
else
    run_single "$WORKLOAD"
fi

echo "All requested Safety Island benchmarks completed."
