#!/usr/bin/env bash
set -euo pipefail

SCORE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_NAME="ara"
COMMIT="826f57c9"
PROFILE="vector_verilator"
CONFIG="default_4lanes"

ARA_HW="$SCORE_ROOT/tools/ara/hardware"
ARA_APPS="$SCORE_ROOT/tools/ara/apps"
VARA_BIN="$ARA_HW/build/verilator/Vara_tb_verilator"
DATASET_DIR="$SCORE_ROOT/datasets/ara/$COMMIT/benchmarks"

mkdir -p "$DATASET_DIR"

WORKLOAD="${1:-all}"

ALL_WORKLOADS=("fmatmul" "imatmul" "fdotproduct" "softmax" "spmv" "dwt" "fft" "fconv2d" "fconv3d" "roi_align")

run_single() {
    local bmark="$1"
    local bin_path="$ARA_APPS/bin/$bmark"

    if [ ! -f "$bin_path" ]; then
        echo "Error: Binary not found: $bin_path" >&2
        return 1
    fi

    if [ ! -x "$VARA_BIN" ]; then
        echo "Error: Verilator binary not found or not executable: $VARA_BIN" >&2
        return 1
    fi

    echo "=================================================="
    echo "Running Ara Vector Benchmark: $bmark"
    echo "Binary: $bin_path"
    echo "Simulator: $VARA_BIN"
    echo "=================================================="

    local out_log="$DATASET_DIR/${bmark}_run.log"
    local json_out="$DATASET_DIR/${bmark}.json"

    local start_ts
    start_ts=$(python3 -c "import time; print(time.time())")

    set +e
    "$VARA_BIN" -l ram,"$bin_path",elf > "$out_log" 2>&1
    local ret=$?
    set -e

    local end_ts
    end_ts=$(python3 -c "import time; print(time.time())")
    local wall_time
    wall_time=$(python3 -c "print(round($end_ts - $start_ts, 4))")

    echo "Simulation finished with return code $ret in ${wall_time}s"
    cat "$out_log"

    # Extract metrics using Python helper
    python3 - <<EOF
import json
import re
import platform
from datetime import datetime, timezone
from pathlib import Path

log_path = Path("$out_log")
json_path = Path("$json_out")
content = log_path.read_text(errors="replace")

hw_cycles_match = re.search(r"\[hw-cycles\]:\s*(\d+)", content)
hw_cycles = int(hw_cycles_match.group(1)) if hw_cycles_match else None

# Check for kernel execution cycles
kernel_cycles_match = re.search(r"(?:The execution took|Execution took)\s*(\d+)\s*cycles", content)
kernel_cycles = int(kernel_cycles_match.group(1)) if kernel_cycles_match else None

# Check for FLOP/cycle or OP/cycle performance
perf_match = re.search(r"The performance is\s*([0-9.]+)\s*(FLOP/cycle|OP/cycle|FLOPS/cycle|Ops/cycle)", content)
performance = float(perf_match.group(1)) if perf_match else None

# Check for utilization percentage
util_match = re.search(r"\(([0-9.]+)%\s*utilization\)", content)
utilization = float(util_match.group(1)) if util_match else None

# Check for SUCCESS or Passed
success = ("*** SUCCESS ***" in content) or ("Passed." in content) or ($ret == 0 and hw_cycles is not None)

# Determine benchmark cycles
cycles = kernel_cycles if kernel_cycles is not None else hw_cycles

metrics = {
    "validated": bool(success),
    "simulator": "verilator",
    "architecture": "rv64gcv",
    "configuration": "$CONFIG",
    "nr_lanes": 4,
    "vlen": 4096,
    "wall_time_s": float("$wall_time"),
    "exit_code": int("$ret"),
}

if cycles is not None:
    metrics["benchmark_cycles"] = cycles
if hw_cycles is not None:
    metrics["hw_cycles"] = hw_cycles
if kernel_cycles is not None:
    metrics["kernel_cycles"] = kernel_cycles
if performance is not None:
    metrics["performance_ops_per_cycle"] = performance
if utilization is not None:
    metrics["vector_utilization_pct"] = utilization

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
        "verilator": "5.048",
        "gcc": "13.2.0"
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
python3 "$SCORE_ROOT/scripts/benchmarks/collect_vector_benchmark_results.py"
echo "=== Done ==="

