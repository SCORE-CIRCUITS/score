#!/usr/bin/env bash
# Run SoC benchmarks on Chimera Heterogeneous Multi-Cluster SoC (pulp-platform/chimera) via Verilator.
set -euo pipefail

SCORE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_NAME="chimera"
PROFILE="soc_verilator"
CONFIG="cheshire_cva6_5x_snitch_cluster_memisl32k"

CHIMERA_DIR="$SCORE_ROOT/tools/chimera"
COMMIT=$(git -C "$CHIMERA_DIR" rev-parse HEAD 2>/dev/null | cut -c1-8 || echo "208b36ef")
DATASET_DIR="$SCORE_ROOT/datasets/chimera/$COMMIT/benchmarks"
SIM_DIR="$SCORE_ROOT/scripts/assets/chimera"
SIM_BINARY="$SIM_DIR/obj_dir/Vtb_chimera_verilator"

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
mkdir -p "$SIM_DIR/sw/bin"

# 1. Ensure test hex binaries exist
for t in testReturnZero testCluster testClusterGating testClusterOffload testCfgBootAddr testMemBypass testPeripheralsGating testHyperbusAddr; do
    if [ ! -f "$SIM_DIR/sw/bin/${t}.hex" ] && [ -f "$CHIMERA_DIR/sw/tests/${t}.memisl.elf" ]; then
        echo "Converting and patching $t ELF to hex..."
        "${RISCV_PREFIX}objcopy" -O verilog "$CHIMERA_DIR/sw/tests/${t}.memisl.elf" "$SIM_DIR/sw/bin/${t}.hex"
        python3 -c "
path = '$SIM_DIR/sw/bin/${t}.hex'
c = open(path).read()
old_pat = '93 02 00 00 63 84 02 00\n13 81 02 00'
new_pat = '37 81 00 48 13 01 01 FF\n13 00 00 00'
if old_pat in c:
    open(path, 'w').write(c.replace(old_pat, new_pat))
"
    fi
done

# 2. Build simulator if needed
if [ ! -x "$SIM_BINARY" ]; then
    echo "=== [Chimera] Building Verilator simulation model ==="
    mkdir -p "$SIM_DIR/obj_dir"
    verilator \
        -Wno-fatal \
        -Wno-lint \
        -Wno-style \
        -Wno-TIMESCALEMOD \
        -Wno-SELRANGE \
        -Wno-MULTIDRIVEN \
        -Wno-UNOPTFLAT \
        -Wno-BLKANDNBLK \
        -Wno-SHORTREAL \
        -Wno-WIDTHCONCAT \
        -Wno-COMBDLY \
        -Wno-NOLATCH \
        --noassert \
        -DASSERTS_OFF \
        -DCVA6_NO_LEGACY_TRACE \
        --binary \
        -j 16 \
        --timing \
        --autoflush \
        -O3 \
        --Mdir "$SIM_DIR/obj_dir" \
        --top tb_chimera_verilator \
        -f "$SIM_DIR/chimera.f" \
        "$SIM_DIR/tb_chimera_verilator.sv"
fi

ALL_WORKLOADS=(
    "testReturnZero"
    "testCluster"
    "testCfgBootAddr"
    "testPeripheralsGating"
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
    echo "Running Chimera SoC Benchmark: $bmark"
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

echo "All requested Chimera benchmarks completed."
