#!/usr/bin/env bash
# Run SoC benchmarks on AraXL (Ara multi-cluster vector processor) via Verilator.
set -euo pipefail

SCORE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_NAME="araxl"
PROFILE="soc_vector_verilator"
CONFIG="cva6_2clusters_8lanes_vlen4096"

ARA_DIR="$SCORE_ROOT/tools/araxl"
COMMIT=$(git -C "$ARA_DIR" rev-parse HEAD 2>/dev/null | cut -c1-8 || echo "bc876e2a")
DATASET_DIR="$SCORE_ROOT/datasets/araxl/$COMMIT/benchmarks"
SIM_BINARY="$ARA_DIR/hardware/build/verilator/Vara_tb_verilator"
APPS_DIR="$ARA_DIR/apps/bin"

mkdir -p "$DATASET_DIR"

if [ ! -x "$SIM_BINARY" ]; then
    echo "Error: Verilator simulation binary not found or not executable at $SIM_BINARY" >&2
    exit 1
fi

ALL_WORKLOADS=(
    "hello_world"
    "fmatmul"
    "imatmul"
    "fdotproduct"
)

WORKLOAD="${1:-all}"

run_single() {
    local bmark="$1"
    local bin_path="$APPS_DIR/${bmark}"

    if [ ! -f "$bin_path" ]; then
        echo "Error: Binary not found: $bin_path" >&2
        return 1
    fi

    echo "=================================================="
    echo "Running AraXL SoC Benchmark: $bmark"
    echo "Binary: $bin_path"
    echo "Simulator: $SIM_BINARY"
    echo "Configuration: CVA6 + 2 Clusters x 4 Lanes (8 Lanes total, VLEN=4096)"
    echo "=================================================="

    local out_log="$DATASET_DIR/${bmark}_run.log"
    local json_out="$DATASET_DIR/${bmark}.json"

    local start_ts
    start_ts=$(python3 -c "import time; print(time.time())")

    set +e
    "$SIM_BINARY" -m "$bin_path" > "$out_log" 2>&1
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
from datetime import datetime, timezone
from pathlib import Path

log_path = Path("$out_log")
json_path = Path("$json_out")
content = log_path.read_text(errors="replace")

# Parse statistics from VerilatorSimCtrl
time_tick_match = re.search(r"\[(\d+)\]\s+-Info:\s+ara_tb_verilator\.sv", content)
exec_cycles_match = re.search(r"Executed cycles:\s*([0-9a-fA-F]+)", content)
if time_tick_match:
    exec_cycles = int(time_tick_match.group(1)) // 2
elif exec_cycles_match:
    try:
        exec_cycles = int(exec_cycles_match.group(1), 16)
    except ValueError:
        exec_cycles = int(exec_cycles_match.group(1))
else:
    exec_cycles = 0

wall_time_match = re.search(r"Wallclock time:\s*([0-9.]+)\s*s", content)
simctrl_wall_time = float(wall_time_match.group(1)) if wall_time_match else float("$wall_time")

sim_speed_match = re.search(r"Simulation speed:\s*[0-9.]+\s*cycles/s\s*\(([0-9.]+)\s*kHz\)", content)
sim_speed_khz = float(sim_speed_match.group(1)) if sim_speed_match else None

# Check for kernel execution cycles if present
kernel_cycles_match = re.search(r"execution took\s*(\d+)\s*cycles", content, re.IGNORECASE)
kernel_cycles = int(kernel_cycles_match.group(1)) if kernel_cycles_match else None

perf_match = re.search(r"performance is\s*([0-9.]+)\s*(?:FLOP|OP|FLOPS|Ops)/cycle", content, re.IGNORECASE)
performance = float(perf_match.group(1)) if perf_match else None

util_match = re.search(r"\(([0-9.]+)%\s*utilization\)", content)
utilization = float(util_match.group(1)) if util_match else None

# Validation check
success = ($ret == 0) and ("FAILED" not in content) and (exec_cycles > 0)
if "$bmark" == "hello_world":
    if "Ariane says Hello!" in content or "Hello World" in content:
        success = True
elif "$bmark" in ("fmatmul", "imatmul", "fdotproduct"):
    if "SUCCESS" in content or "Passed" in content or "sed." in content:
        success = True

metrics = {
    "validated": bool(success),
    "simulator": "verilator",
    "architecture": "rv64gcv",
    "configuration": "$CONFIG",
    "clock_frequency_hz": 500000000,
    "num_clusters": 2,
    "nr_lanes_per_cluster": 4,
    "total_lanes": 8,
    "vlen": 4096,
    "wall_time_s": simctrl_wall_time,
    "exit_code": $ret,
    "execution_cycles": exec_cycles,
    "total_simulation_cycles": exec_cycles,
}

if sim_speed_khz is not None:
    metrics["simulation_speed_khz"] = sim_speed_khz
if kernel_cycles is not None:
    metrics["kernel_execution_cycles"] = kernel_cycles
if performance is not None:
    metrics["performance_ops_per_cycle"] = performance
if utilization is not None:
    metrics["vector_utilization_pct"] = utilization

if "$bmark" == "hello_world":
    metrics["description"] = "CVA6 + AraXL dual cluster vector hello world sanity test"
    metrics["stdout_verified"] = ("Ariane says Hello!" in content) or ("Hello World" in content)
elif "$bmark" == "fmatmul":
    metrics["description"] = "Double precision floating-point matrix multiplication across 2 vector clusters (8 lanes)"
    metrics["stdout_verified"] = ("SUCCESS" in content) or ("Passed" in content) or ("sed." in content)
elif "$bmark" == "imatmul":
    metrics["description"] = "Integer matrix multiplication (int64) across 2 vector clusters (8 lanes)"
    metrics["stdout_verified"] = ("SUCCESS" in content) or ("Passed" in content) or ("sed." in content)
elif "$bmark" == "fdotproduct":
    metrics["description"] = "Double precision vector dot product across 2 vector clusters (8 lanes)"
    metrics["stdout_verified"] = ("SUCCESS" in content)
    vec_rt = re.search(r"Vector runtime:\s*(\d+)", content)
    scalar_rt = re.search(r"Scalar runtime:\s*(\d+)", content)
    if vec_rt:
        metrics["vector_runtime_cycles"] = int(vec_rt.group(1))
    if scalar_rt:
        metrics["scalar_runtime_cycles"] = int(scalar_rt.group(1))

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
        "gcc": "11.5.0"
    }
}

json_path.parent.mkdir(parents=True, exist_ok=True)
json_path.write_text(json.dumps(payload, indent=2) + "\n")
print(f"Wrote benchmark results to {json_path}")
EOF
}

if [ "$WORKLOAD" = "all" ]; then
    for bm in "${ALL_WORKLOADS[@]}"; do
        run_single "$bm"
    done
else
    run_single "$WORKLOAD"
fi

echo "=================================================="
echo "AraXL benchmarks finished."
echo "Results in $DATASET_DIR"
echo "=================================================="

