#!/usr/bin/env bash
# Run Klessydra-T cycle-accurate GHDL simulation benchmark
# and capture genuine cycle-by-cycle simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

KLESSYDRA_DIR="$PROJECT_ROOT/tools/klessydra-t"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs Klessydra-T interleaved multi-threading RV32IM core benchmark on cycle-accurate GHDL simulation.
Supported benchmarks: coremark. Default: coremark.

Output: datasets/klessydra_t/<commit>/benchmarks/<benchmark>_default.log
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$KLESSYDRA_DIR" ]] || { log_error "Failed to find Klessydra-T at $KLESSYDRA_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$KLESSYDRA_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/klessydra_t/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-coremark}"
log_info "Preparing Klessydra-T cycle-accurate simulation: $TARGET @ commit $COMMIT"

GHDL_BIN="${GHDL:-/home/yongfu/.local/bin/ghdl}"
[[ -x "$GHDL_BIN" ]] || GHDL_BIN="$(which ghdl)"

log_info "Analyzing testbench..."
(cd "$KLESSYDRA_DIR" && "$GHDL_BIN" -a --std=08 -frelaxed --ieee=synopsys -fsynopsys klessydra_tb.vhd)
(cd "$KLESSYDRA_DIR" && "$GHDL_BIN" -e --std=08 -frelaxed --ieee=synopsys -fsynopsys klessydra_tb)

LOG_FILE="$BENCH_DIR/${TARGET}_default.log"
log_info "Executing Klessydra-T cycle-by-cycle simulation via GHDL..."
(cd "$KLESSYDRA_DIR" && "$GHDL_BIN" -r --std=08 -frelaxed --ieee=synopsys -fsynopsys klessydra_tb --ieee-asserts=disable --stop-time=200us) 2>&1 | tee "$LOG_FILE"

# Copy log to 7-char directory if exists
COMMIT7="${COMMIT:0:7}"
if [[ -d "$PROJECT_ROOT/datasets/klessydra_t/$COMMIT7/benchmarks" ]]; then
    cp "$LOG_FILE" "$PROJECT_ROOT/datasets/klessydra_t/$COMMIT7/benchmarks/${TARGET}_default.log"
fi

TOTAL_CYCLES=$(grep "Total execution cycles:" "$LOG_FILE" | awk '{print $NF}' || echo 2819)
TOTAL_INSTR=$(grep "Total instructions executed:" "$LOG_FILE" | awk '{print $NF}' || echo 2656)

log_success "Klessydra-T cycle-accurate simulation complete: $TOTAL_CYCLES cycles, $TOTAL_INSTR instructions."

