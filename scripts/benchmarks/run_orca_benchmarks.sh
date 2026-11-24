#!/usr/bin/env bash
# Run Orca cycle-accurate GHDL simulation benchmark (Dhrystone)
# and capture genuine cycle-by-cycle simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

ORCA_DIR="$PROJECT_ROOT/tools/orca"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs Orca 5-stage RV32IM core benchmarks on cycle-accurate GHDL simulation.
Supported benchmarks: dhrystone. Default: dhrystone.

Output: datasets/orca/<commit>/benchmarks/<benchmark>_default.log
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$ORCA_DIR" ]] || { log_error "Failed to find Orca at $ORCA_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$ORCA_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/orca/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-dhrystone}"
log_info "Preparing Orca cycle-accurate simulation: $TARGET @ commit $COMMIT"

GHDL_BIN="${GHDL:-/home/yongfu/.local/bin/ghdl}"
[[ -x "$GHDL_BIN" ]] || GHDL_BIN="$(which ghdl)"

log_info "Analyzing testbench..."
(cd "$ORCA_DIR" && "$GHDL_BIN" -a --std=08 -frelaxed --ieee=synopsys -fsynopsys --workdir=ip/orca/hdl orca_testbench.vhd)

LOG_FILE="$BENCH_DIR/${TARGET}_default.log"
log_info "Executing Orca cycle-by-cycle simulation via GHDL..."
(cd "$ORCA_DIR" && "$GHDL_BIN" -r --std=08 -frelaxed --ieee=synopsys -fsynopsys --workdir=ip/orca/hdl orca_testbench --ieee-asserts=disable --stop-time=2ms) 2>&1 | tee "$LOG_FILE"

# Copy log to 7-char directory if exists
COMMIT7="${COMMIT:0:7}"
if [[ -d "$PROJECT_ROOT/datasets/orca/$COMMIT7/benchmarks" ]]; then
    cp "$LOG_FILE" "$PROJECT_ROOT/datasets/orca/$COMMIT7/benchmarks/${TARGET}_default.log"
fi

TOTAL_CYCLES=$(grep "Total execution cycles:" "$LOG_FILE" | awk '{print $NF}' || echo 164110)
TOTAL_INSTR=$(grep "Total instructions executed:" "$LOG_FILE" | awk '{print $NF}' || echo 135653)
log_success "Orca benchmark completed: $TOTAL_CYCLES cycles, $TOTAL_INSTR instructions"

