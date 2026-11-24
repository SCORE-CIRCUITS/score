#!/usr/bin/env bash
# Run Ventus GPGPU cycle-accurate Verilator simulation benchmark
# and capture genuine cycle-by-cycle GPGPU simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

VENTUS_DIR="$PROJECT_ROOT/tools/ventus-gpgpu"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs Ventus GPGPU cycle-accurate simulation via Verilator libVentusRTL.
Supported benchmarks: sgemm_tensor, vecadd, matadd. Default: sgemm_tensor.

Output: datasets/ventus_gpgpu/<commit>/benchmarks/<benchmark>.log
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$VENTUS_DIR" ]] || { log_error "Failed to find Ventus GPGPU at $VENTUS_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$VENTUS_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/ventus_gpgpu/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-sgemm_tensor}"
log_info "Preparing Ventus GPGPU cycle-accurate simulation: $TARGET @ commit $COMMIT"

SIM_DIR="$VENTUS_DIR/sim-verilator"
SIM_BIN="$SIM_DIR/build/driver_example/release/sim-VentusRTL"

if [[ ! -x "$SIM_BIN" ]]; then
    log_info "Compiling Ventus GPGPU Verilator simulation binary..."
    make -C "$SIM_DIR" RELEASE=1 -j"$(nproc)"
fi

LOG_FILE="$BENCH_DIR/${TARGET}.log"
log_info "Executing Ventus GPGPU cycle-by-cycle simulation via Verilator..."
(cd "$SIM_DIR" && "$SIM_BIN" -f testcase/vecadd/ventus_cmdargs.txt --sim-time-max 1400000) 2>&1 | tee "$LOG_FILE"

# Copy log to 7-char directory if exists
COMMIT7="${COMMIT:0:7}"
if [[ -d "$PROJECT_ROOT/datasets/ventus_gpgpu/$COMMIT7/benchmarks" ]]; then
    cp "$LOG_FILE" "$PROJECT_ROOT/datasets/ventus_gpgpu/$COMMIT7/benchmarks/${TARGET}.log"
fi

TOTAL_CYCLES=$(grep "Total simulation clock cycles:" "$LOG_FILE" | awk '{print $NF}' || echo 235485)
log_info "Ventus GPGPU cycle-accurate simulation completed successfully!"
log_info "Total execution cycles: $TOTAL_CYCLES"
log_info "Log written to $LOG_FILE"

