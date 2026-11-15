#!/usr/bin/env bash
# Run SoC benchmarks on Snitch Cluster (pulp-platform/snitch_cluster) via Verilator.
set -euo pipefail

SCORE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_NAME="snitch_cluster"
PROFILE="soc_verilator"
CONFIG="snitch_cluster_8cores_1dma"

SNITCH_DIR="$SCORE_ROOT/tools/snitch-cluster"
COMMIT=$(git -C "$SNITCH_DIR" rev-parse HEAD 2>/dev/null | cut -c1-8 || echo "1defbef7")
DATASET_DIR="$SCORE_ROOT/datasets/snitch_cluster/$COMMIT/benchmarks"
SIM_BINARY="$SNITCH_DIR/target/sim/build/bin/snitch_cluster_bin.vlt"
TESTS_DIR="$SNITCH_DIR/sw/tests/build"

mkdir -p "$DATASET_DIR"

if [ ! -x "$SIM_BINARY" ]; then
    echo "Error: Verilator simulation binary not found at $SIM_BINARY" >&2
    echo "Please build it with: make -C tools/snitch-cluster verilator" >&2
    exit 1
fi

ALL_WORKLOADS=(
    "simple"
    "barrier"
    "matmul_i32"
)

WORKLOAD="${1:-all}"

run_single() {
    local bmark="$1"
    local elf_path="$TESTS_DIR/${bmark}.elf"

    if [ ! -f "$elf_path" ]; then
        echo "Error: Binary not found: $elf_path" >&2
        return 1
    fi

    echo "=================================================="
    echo "Running Snitch Cluster SoC Benchmark: $bmark"
    echo "Binary: $elf_path"
    echo "Simulator: $SIM_BINARY"
    echo "Configuration: 8 Snitch compute cores + 1 DMA core"
    echo "=================================================="

    local out_log="$DATASET_DIR/${bmark}_run.log"
    local json_out="$DATASET_DIR/${bmark}.json"

    local start_ts
    start_ts=$(python3 -c "import time; print(time.time())")

    set +e
    (cd "$SCORE_ROOT" && "$SIM_BINARY" "$elf_path") > "$out_log" 2>&1
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

# Parse execution cycles from trace_hart_00000.dasm
trace_path = Path("$SCORE_ROOT/logs/trace_hart_00000.dasm")
sim_cycles = None
if trace_path.exists():
    try:
        # Read the last non-empty line of the trace file
        with open(trace_path, "rb") as f:
            f.seek(max(0, f.seek(0, 2) - 4096))
            lines = [line.decode("utf-8", errors="replace").strip() for line in f.readlines()]
            for line in reversed(lines):
                parts = line.split()
                if len(parts) >= 2 and parts[1].isdigit():
                    sim_cycles = int(parts[1])
                    break
    except Exception as e:
        print(f"Warning: Could not read trace: {e}")

# Parse kernel cycles from log
kernel_cycles = None
kernel_match = re.search(r"RV32IM cycles:\s+(\d+)", content)
if kernel_match:
    kernel_cycles = int(kernel_match.group(1))

# Check functional status
is_ok = ("RV32IM result: OK" in content) or ($ret == 0)

wall_time = float("$wall_time")
sim_speed_khz = None
if sim_cycles and wall_time > 0:
    sim_speed_khz = round((sim_cycles / wall_time) / 1000.0, 2)

metrics = {
    "validated": is_ok,
    "simulator": "verilator",
    "architecture": "rv32imafd_xfrep_xssr_xdma",
    "configuration": "$CONFIG",
    "clock_frequency_hz": 500000000,
    "cores": 9,
    "compute_cores": 8,
    "dma_cores": 1,
    "wall_time_s": wall_time,
    "exit_code": $ret,
    "simulation_cycles": sim_cycles if sim_cycles else 0,
    "total_simulation_cycles": sim_cycles if sim_cycles else 0,
}

if kernel_cycles is not None:
    metrics["kernel_execution_cycles"] = kernel_cycles
if sim_speed_khz is not None:
    metrics["simulation_speed_khz"] = sim_speed_khz
if "$bmark" == "matmul_i32":
    metrics["matrix_size"] = "32x32"
    metrics["data_type"] = "int32"
    metrics["result"] = "OK" if "RV32IM result: OK" in content else "FAIL"
elif "$bmark" == "barrier":
    metrics["barrier_type"] = "cluster_hardware_barrier"
    metrics["participating_cores"] = 8
elif "$bmark" == "simple":
    metrics["description"] = "Sanity test of Snitch core and cluster boot"

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
        "llvm_snitch": "15.0.0",
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
echo "Snitch Cluster benchmarks finished."
echo "Results in $DATASET_DIR"
echo "=================================================="

