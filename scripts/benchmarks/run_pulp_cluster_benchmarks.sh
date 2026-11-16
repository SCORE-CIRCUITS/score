#!/usr/bin/env bash
# Run SoC benchmarks on 8-core PULP Cluster (pulp-platform/pulp_cluster) via Verilator.
set -euo pipefail

SCORE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_NAME="pulp_cluster"
PROFILE="soc_verilator"
CONFIG="8core_cv32e40p_tcdm128k"

CLUSTER_DIR="$SCORE_ROOT/tools/pulp-cluster"
COMMIT=$(git -C "$CLUSTER_DIR" rev-parse HEAD 2>/dev/null | cut -c1-8 || echo "caaa9735")
DATASET_DIR="$SCORE_ROOT/datasets/pulp_cluster/$COMMIT/benchmarks"
SIM_DIR="$SCORE_ROOT/scripts/assets/pulp_cluster"
SIM_BINARY="$SIM_DIR/obj_dir/Vtb_pulp_cluster_verilator"

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

# 1. Build software workloads
echo "=== [PULP Cluster] Building software test suite ==="
make -C "$SIM_DIR/sw" RISCV_PREFIX="$RISCV_PREFIX"

# 2. Build simulator if needed
if [ ! -x "$SIM_BINARY" ]; then
    echo "=== [PULP Cluster] Building Verilator simulation model ==="
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
        -Wno-TIMESCALEMOD \
        -Wno-SYMRSVDWORD \
        -Wno-REDEFMACRO \
        -Wno-MODDUP \
        -Wno-ALWCOMBORDER \
        -Wno-CASEOVERLAP \
        -Wno-CASEX \
        -DSYNTHESIS=1 \
        -DPRIM_ASSERT_SV=1 \
        --binary \
        -j 8 \
        --timing \
        --autoflush \
        -O3 \
        --Mdir "$SIM_DIR/obj_dir" \
        --top tb_pulp_cluster_verilator \
        -f "$SIM_DIR/pulp_cluster.f" \
        "$SIM_DIR/tb_pulp_cluster_verilator.sv"
fi

ALL_WORKLOADS=(
    "hello"
    "parallel_matmul"
    "parallel_fir"
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
    echo "Running PULP Cluster SoC Benchmark: $bmark"
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
total_cycles_m = re.search(r"Total cycles:\s*(\d+)", text)
total_cycles = int(total_cycles_m.group(1)) if total_cycles_m else None

instr_m = re.search(r"Instructions ret:\s*(\d+)", text)
retired_inst = int(instr_m.group(1)) if instr_m else None

cpi = None
if total_cycles is not None and retired_inst is not None and retired_inst > 0:
    cpi = round(total_cycles / retired_inst, 2)

metrics = {
    "execution_cycles": total_cycles,
    "total_simulation_cycles": total_cycles,
    "wall_time_sec": $wall_time,
}

if retired_inst is not None:
    metrics["retired_instructions"] = retired_inst
if cpi is not None:
    metrics["cpi"] = cpi

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

echo "All requested PULP Cluster benchmarks completed."
