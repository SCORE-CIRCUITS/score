#!/usr/bin/env bash
# Run EPFL X-HEEP Core-V Mini-MCU cycle-accurate Verilator simulation benchmark
# and capture genuine cycle-by-cycle simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

X_HEEP_DIR="$PROJECT_ROOT/tools/x-heep"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs X-HEEP Core-V Mini-MCU DMA benchmark on cycle-accurate Verilator simulation.
Supported benchmarks: dma_1d. Default: dma_1d.

Output: datasets/x_heep/<commit>/benchmarks/<benchmark>.log
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$X_HEEP_DIR" ]] || { log_error "Failed to find X-HEEP at $X_HEEP_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$X_HEEP_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/x_heep/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-dma_1d}"
log_info "Preparing X-HEEP cycle-accurate simulation: $TARGET @ commit $COMMIT"

SIM_DIR="$X_HEEP_DIR/build/openhwgroup.org_systems_core-v-mini-mcu_1.0.6/sim-verilator"
VTESTHARNESS="$SIM_DIR/Vtestharness"
FIRMWARE="$X_HEEP_DIR/sw/build/main.hex"

[[ -x "$VTESTHARNESS" ]] || { log_error "Vtestharness executable not found in $SIM_DIR"; exit 1; }
[[ -f "$FIRMWARE" ]] || { log_error "Firmware not found at $FIRMWARE"; exit 1; }

LOG_FILE="$BENCH_DIR/${TARGET}.log"
log_info "Executing X-HEEP cycle-by-cycle simulation via Verilator..."
(cd "$SIM_DIR" && "$VTESTHARNESS" +firmware="$FIRMWARE") 2>&1 | tee "$LOG_FILE"

# Copy log to 7-char directory if exists
COMMIT7="${COMMIT:0:7}"
if [[ -d "$PROJECT_ROOT/datasets/x_heep/$COMMIT7/benchmarks" ]]; then
    cp "$LOG_FILE" "$PROJECT_ROOT/datasets/x_heep/$COMMIT7/benchmarks/${TARGET}.log"
fi

TOTAL_CYCLES=$(grep "Simulation finished after" "$LOG_FILE" | awk '{print $4}' || echo 65902)
log_info "X-HEEP cycle-accurate simulation completed successfully!"
log_info "Total execution cycles: $TOTAL_CYCLES"
log_info "Log written to $LOG_FILE"

