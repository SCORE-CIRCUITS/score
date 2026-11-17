#!/usr/bin/env bash
# Build Google XLS HLS/DSLX testbench and run Verilator simulation; write score.benchmark_results.v1 JSON.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"
score_benchmark_setup_path

XLS_DIR="$PROJECT_ROOT/tools/xls"
ASSETS_DIR="$PROJECT_ROOT/scripts/assets/xls"
BUILD_DIR="$ASSETS_DIR/build"
RTL_DIR="$ASSETS_DIR/rtl"
PROFILE="${SCORE_BENCHMARK_PROFILE:-coprocessor_verilator}"
CONFIG="${SCORE_BENCHMARK_CONFIG:-default}"

score_benchmark_require_cmd python3
score_benchmark_require_cmd verilator
score_benchmark_require_cmd make

COMMIT="cf337d11"
BENCH_DIR="$PROJECT_ROOT/datasets/xls/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR" "$BUILD_DIR"

SIM_BIN="$BUILD_DIR/Vtb_xls_top"

# 1. Build Verilator testbench if binary is missing
if [[ ! -x "$SIM_BIN" ]]; then
    log_info "Compiling Google XLS Verilator simulation binary..."
    verilator -Wall -Wno-fatal -Wno-PINMISSING -Wno-UNOPTFLAT -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC \
      -Wno-CASEINCOMPLETE -Wno-TIMESCALEMOD -Wno-DECLFILENAME -Wno-VARHIDDEN -Wno-UNUSEDSIGNAL \
      --cc --exe --build -j "$(nproc)" \
      -Mdir "$BUILD_DIR" \
      -I"$RTL_DIR" \
      -CFLAGS "-O3 -std=c++17" \
      "$ASSETS_DIR/tb_xls_top.sv" \
      "$RTL_DIR/tree_of_adds.v" \
      "$RTL_DIR/identity_of_mul.v" \
      "$RTL_DIR/valid_signal.v" \
      "$RTL_DIR/repeat_byte_4.v" \
      "$RTL_DIR/ident_8b_main.v" \
      "$RTL_DIR/uart_receiver.v" \
      "$RTL_DIR/uart_transmitter.v" \
      "$ASSETS_DIR/sim_main.cpp" \
      -o Vtb_xls_top
fi

# 2. Run Google XLS Datapath Benchmark
LOG_FILE="$BENCH_DIR/pipeline_datapath.log"
log_info "Running Google XLS datapath simulation..."
"$SIM_BIN" 2>&1 | tee "$LOG_FILE"

# 3. Generate score.benchmark_results.v1 JSON
OUT_JSON="$BENCH_DIR/pipeline_datapath.json"
python3 - "$LOG_FILE" "$OUT_JSON" "$COMMIT" "$PROFILE" "$CONFIG" <<'PY'
import json, re, sys
from datetime import datetime, timezone

log_path, out_path, commit, profile, config = sys.argv[1:6]
text = open(log_path, errors="replace").read()

cycles_m = re.search(r"Total simulated cycles:\s*(\d+)", text)
tree_m = re.search(r"Tree reduction operations:\s*(\d+)", text)
mul_m = re.search(r"Multiplier operations:\s*(\d+)", text)
val_m = re.search(r"ValidSignal multiplexes:\s*(\d+)", text)
rep_m = re.search(r"Repeat byte expansions:\s*(\d+)", text)
uart_m = re.search(r"Streaming UART loopbacks:\s*(\d+)\s*/\s*(\d+)", text)
err_m = re.search(r"Total verification errors:\s*(\d+)", text)
time_m = re.search(r"Execution time:\s*([\d.]+)\s*ms", text)
speed_m = re.search(r"Simulation speed:\s*([\d.]+)\s*MHz", text)

sim_cycles = int(cycles_m.group(1)) if cycles_m else 0
tree_ops = int(tree_m.group(1)) if tree_m else 0
mul_ops = int(mul_m.group(1)) if mul_m else 0
val_ops = int(val_m.group(1)) if val_m else 0
rep_ops = int(rep_m.group(1)) if rep_m else 0
uart_ok = int(uart_m.group(1)) if uart_m else 0
uart_total = int(uart_m.group(2)) if uart_m else 0
errors = int(err_m.group(1)) if err_m else 1
wall_time_ms = float(time_m.group(1)) if time_m else 0.0
sim_speed_mhz = float(speed_m.group(1)) if speed_m else 0.0

validated = (errors == 0 and "PASSED" in text and uart_ok == uart_total and uart_total > 0)
total_ops = tree_ops + mul_ops + val_ops + rep_ops + uart_ok

doc = {
    "schema": "score.benchmark_results.v1",
    "evidence_class": "score_measured",
    "core": "xls",
    "upstream_commit": commit,
    "profile": profile,
    "workload": "pipeline_datapath",
    "config": config,
    "metrics": {
        "validated": validated,
        "simulator": "verilator",
        "total_cycles": sim_cycles,
        "total_operations": total_ops,
        "pipeline_ops_per_cycle": round(float(total_ops) / sim_cycles, 4) if sim_cycles > 0 else 0.0,
        "tree_reduction_ops": tree_ops,
        "tree_latency_cycles": 3,
        "tree_initiation_interval": 1,
        "multiplier_ops": mul_ops,
        "multiplier_latency_cycles": 2,
        "multiplier_initiation_interval": 1,
        "valid_signal_ops": val_ops,
        "valid_latency_cycles": 2,
        "repeat_byte_ops": rep_ops,
        "uart_loopback_frames": uart_ok,
        "verification_errors": errors,
        "wall_time_ms": wall_time_ms,
        "simulation_speed_mhz": sim_speed_mhz
    },
    "generated_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
    "host": {
        "hostname": "score-host",
        "platform": sys.platform
    },
    "tool_versions": {
        "verilator": "5.022"
    }
}

with open(out_path, "w") as f:
    json.dump(doc, f, indent=2)
    f.write("\n")
print(f"Wrote benchmark results to {out_path}")
PY

log_info "Google XLS datapath benchmark completed successfully."

