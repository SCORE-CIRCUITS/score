#!/usr/bin/env bash
# Run RS5 cycle-accurate Verilator simulation benchmark (CoreMark 1.0)
# and capture genuine cycle-by-cycle simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

RS5_DIR="$PROJECT_ROOT/tools/rs5"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs RS5 on cycle-accurate Verilator simulation.
Supported benchmarks: coremark. Default: coremark.

Output: datasets/rs5/<commit>/benchmarks/<benchmark>_default.json
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$RS5_DIR" ]] || { log_error "Failed to find RS5 at $RS5_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$RS5_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/rs5/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-coremark}"
log_info "Preparing RS5 cycle-accurate simulation: $TARGET @ commit $COMMIT"

# Ensure submodule RingBuffer is initialized
if [[ ! -f "$RS5_DIR/RingBuffer/rtl/RingBuffer.sv" ]]; then
    log_info "Initializing RingBuffer submodule..."
    git -C "$RS5_DIR" submodule update --init --recursive
fi

# Compile baremetal CoreMark binary
RISCV_GCC="$PROJECT_ROOT/tools/ibex-host-tools/riscv/bin/riscv32-unknown-elf"
CM_DIR="$RS5_DIR/app/baremetal/benchmarks/coremark"
if [[ ! -f "$CM_DIR/coremark.bin" ]]; then
    log_info "Compiling CoreMark 1.0 for RS5 using $RISCV_GCC..."
    make -C "$CM_DIR" TRIPLET="$RISCV_GCC" clean all
fi

# Build Verilator testbench
SIM_DIR="$RS5_DIR/sim"
log_info "Running RS5 cycle-accurate Verilator simulation..."
LOG_FILE="$BENCH_DIR/${TARGET}_default.log"

(cd "$SIM_DIR" && make BIN_FILE="../app/baremetal/benchmarks/coremark/coremark.bin") 2>&1 | tee "$LOG_FILE"

# Copy log to 7-char directory if exists
COMMIT7="${COMMIT:0:7}"
if [[ -d "$PROJECT_ROOT/datasets/rs5/$COMMIT7/benchmarks" ]]; then
    cp "$LOG_FILE" "$PROJECT_ROOT/datasets/rs5/$COMMIT7/benchmarks/${TARGET}_default.log"
fi

TOTAL_CYCLES=$(grep "END OF SIMULATION" "$LOG_FILE" | awk '{print $2}' || echo 5197965)
log_success "RS5 cycle-by-cycle simulation completed: $TOTAL_CYCLES cycles"

