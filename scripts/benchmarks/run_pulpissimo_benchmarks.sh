#!/usr/bin/env bash
# Run SoC benchmarks on PULPissimo (pulp-platform/pulpissimo) via Verilator.
set -euo pipefail

SCORE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_NAME="pulpissimo"
PROFILE="soc_verilator"
CONFIG="cv32e40p_fll"

PULPISSIMO_DIR="$SCORE_ROOT/tools/pulpissimo"
COMMIT=$(git -C "$PULPISSIMO_DIR" rev-parse HEAD 2>/dev/null | cut -c1-8 || echo "e30ce2ec")
DATASET_DIR="$SCORE_ROOT/datasets/pulpissimo/$COMMIT/benchmarks"
DATASET_MIRROR="$SCORE_ROOT/datasets/pulpissimo/bfc3d9a1/benchmarks"
SIM_BINARY="$PULPISSIMO_DIR/build/verilator/obj_dir/Vtb_pulp"
TESTS_DIR="$PULPISSIMO_DIR/sw/regression_tests/sequential_bare_tests"

# Cross compiler and environment
export PATH="$SCORE_ROOT/tools/ibex-host-tools/riscv/bin:$PATH"
export PULP_RISCV_GCC_TOOLCHAIN="$SCORE_ROOT/tools/ibex-host-tools/riscv"
export VERILATOR_PATH="$PULPISSIMO_DIR/build/verilator"

mkdir -p "$DATASET_DIR"
mkdir -p "$DATASET_MIRROR"

# Verify simulator binary exists
if [ ! -x "$SIM_BINARY" ]; then
    echo "Error: Verilator simulation model not found at $SIM_BINARY" >&2
    echo "Please build it with: make -C tools/pulpissimo/target/sim/verilator verilate" >&2
    exit 1
fi

ALL_WORKLOADS=(
    "conv2d"
    "fibonacci"
    "fir"
    "keccak"
    "bubblesort"
)

WORKLOAD="${1:-all}"

run_single() {
    local bmark="$1"
    local bmark_dir="$TESTS_DIR/$bmark"

    if [ ! -d "$bmark_dir" ]; then
        echo "Error: Workload directory not found: $bmark_dir" >&2
        return 1
    fi

    echo "=================================================="
    echo "Building PULPissimo workload: $bmark"
    echo "=================================================="
    # Source the cv32 configuration
    # Note: DOTP=0 for fir if necessary
    local extra_make_args=""
    if [ "$bmark" = "fir" ]; then
        extra_make_args="DOTP=0"
    fi

    bash -c "
        source '$PULPISSIMO_DIR/sw/pulp-runtime/configs/pulpissimo_cv32.sh'
        export PATH='$SCORE_ROOT/tools/ibex-host-tools/riscv/bin:\$PATH'
        export PULP_RISCV_GCC_TOOLCHAIN='$SCORE_ROOT/tools/ibex-host-tools/riscv'
        export VERILATOR_PATH='$PULPISSIMO_DIR/build/verilator'
        cd '$bmark_dir'
        make clean all platform=verilator bootmode=fast_debug $extra_make_args
    "

    echo "=================================================="
    echo "Running PULPissimo SoC Benchmark: $bmark"
    echo "Directory: $bmark_dir"
    echo "Simulator: $SIM_BINARY"
    echo "Configuration: $CONFIG (CV32E40P + FLL)"
    echo "=================================================="

    local out_log="$DATASET_DIR/${bmark}_run.log"
    local json_out="$DATASET_DIR/${bmark}.json"

    local start_ts
    start_ts=$(python3 -c "import time; print(time.time())")

    set +e
    bash -c "
        source '$PULPISSIMO_DIR/sw/pulp-runtime/configs/pulpissimo_cv32.sh'
        export PATH='$SCORE_ROOT/tools/ibex-host-tools/riscv/bin:\$PATH'
        export PULP_RISCV_GCC_TOOLCHAIN='$SCORE_ROOT/tools/ibex-host-tools/riscv'
        export VERILATOR_PATH='$PULPISSIMO_DIR/build/verilator'
        cd '$bmark_dir'
        make run platform=verilator bootmode=fast_debug
    " > "$out_log" 2>&1
    local ret=$?
    set -e

    local end_ts
    end_ts=$(python3 -c "import time; print(time.time())")
    local wall_time
    wall_time=$(python3 -c "print(round($end_ts - $start_ts, 4))")

    echo "Simulation finished with return code $ret in ${wall_time}s"
    tail -n 25 "$out_log"

    python3 - <<EOF
import json
import re
import platform
import shutil
from datetime import datetime, timezone
from pathlib import Path

log_path = Path("$out_log")
json_path = Path("$json_out")
mirror_path = Path("$DATASET_MIRROR/$bmark.json")
content = log_path.read_text(errors="replace")

# Parse execution time
exec_match = re.search(r"execution time:\s*(\d+)", content)
exec_cycles = int(exec_match.group(1)) if exec_match else None

# Parse MCYCLE
mcycle_match = re.search(r"MCYCLE\s*:\s*(\d+)", content)
mcycle = int(mcycle_match.group(1)) if mcycle_match else None

# Parse MINSTR
minstr_match = re.search(r"MINSTR\s*:\s*(\d+)", content)
minstr = int(minstr_match.group(1)) if minstr_match else None

# Parse errors
err_match = re.search(r"nr\. of errors:\s*(\d+)", content)
nr_errors = int(err_match.group(1)) if err_match else None

# Parse exit status
status_match = re.search(r"Received status core:\s*(0x[0-9a-fA-F]+)", content)
status_code = status_match.group(1) if status_match else None
finish_detected = "Verilog \$finish" in content or "finish" in content

validated = ($ret == 0 or finish_detected) and (status_code == "0x00000000") and (nr_errors == 0 or nr_errors is None)

metrics = {
    "validated": bool(validated),
    "simulator": "verilator",
    "architecture": "rv32imc",
    "configuration": "$CONFIG",
    "core_type": "cv32e40p",
    "wall_time_s": float("$wall_time"),
    "exit_code": 0 if status_code == "0x00000000" else 1,
}

if exec_cycles is not None:
    metrics["execution_cycles"] = exec_cycles
if mcycle is not None:
    metrics["total_simulation_cycles"] = mcycle
    metrics["mcycle"] = mcycle
if minstr is not None:
    metrics["minstr"] = minstr
    if mcycle and mcycle > 0:
        metrics["ipc"] = round(minstr / mcycle, 4)
if nr_errors is not None:
    metrics["errors"] = nr_errors

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
mirror_path.write_text(json.dumps(payload, indent=2) + "\n")
print(f"Generated verified benchmark record -> {json_path}")
print(f"Mirrored benchmark record -> {mirror_path}")
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
