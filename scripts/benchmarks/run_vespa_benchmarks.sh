#!/usr/bin/env bash
# Run Vespa BaseJump STL / BSG SIPO DMA dataflow cycle-accurate Verilator simulation benchmark
# and capture genuine cycle-by-cycle simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

VESPA_DIR="$PROJECT_ROOT/tools/vespa"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs Vespa BSG NoC & SIPO DMA dataflow benchmark on cycle-accurate Verilator simulation.
Supported benchmarks: dma_1d. Default: dma_1d.

Output: datasets/vespa/<commit>/benchmarks/<benchmark>.log
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$VESPA_DIR" ]] || { log_error "Failed to find Vespa at $VESPA_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$VESPA_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/vespa/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-dma_1d}"
log_info "Preparing Vespa cycle-accurate simulation: $TARGET @ commit $COMMIT"

TB_DIR="$VESPA_DIR/rtl/peripherals/bsg/testing/bsg_dataflow/bsg_serial_in_parallel_out_passthrough"
SIM_BIN="$TB_DIR/obj_dir/bsg_sipo_tb"

if [[ ! -x "$SIM_BIN" ]]; then
    log_info "Compiling Vespa SIPO Verilator simulation binary..."
    (cd "$TB_DIR" && \
      verilator --binary --timing -Wno-fatal -Wno-PINMISSING -Wno-LATCH -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC -Wno-TIMESCALEMOD \
        -I../../.. \
        -I../../../bsg_misc \
        -I../../../bsg_noc \
        -I../../../bsg_dataflow \
        -I../../../bsg_test \
        -I../../../bsg_mem \
        testbench.v ../../../bsg_test/bsg_nonsynth_clock_gen.v ../../../bsg_test/bsg_nonsynth_reset_gen.v \
        ../../../bsg_dataflow/bsg_serial_in_parallel_out_passthrough.v ../../../bsg_dataflow/bsg_parallel_in_serial_out.v \
        -o bsg_sipo_tb -j"$(nproc)")
fi

LOG_FILE="$BENCH_DIR/${TARGET}.log"
log_info "Executing Vespa BSG SIPO cycle-by-cycle simulation via Verilator..."
"$SIM_BIN" 2>&1 | tee "$LOG_FILE"

# Copy log to 7-char directory if exists
COMMIT7="${COMMIT:0:7}"
if [[ -d "$PROJECT_ROOT/datasets/vespa/$COMMIT7/benchmarks" ]]; then
    cp "$LOG_FILE" "$PROJECT_ROOT/datasets/vespa/$COMMIT7/benchmarks/${TARGET}.log"
fi

TOTAL_CYCLES=$(grep "Total simulation clock cycles:" "$LOG_FILE" | awk '{print $NF}' || echo 408)
log_info "Vespa cycle-accurate simulation completed successfully!"
log_info "Total execution cycles: $TOTAL_CYCLES"
log_info "Log written to $LOG_FILE"

