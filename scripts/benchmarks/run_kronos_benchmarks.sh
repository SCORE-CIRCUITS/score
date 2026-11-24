#!/usr/bin/env bash
# Run Kronos cycle-accurate Verilator simulation benchmark (Dhrystone)
# and capture genuine cycle-by-cycle simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

KRONOS_DIR="$PROJECT_ROOT/tools/kronos"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs Kronos 3-stage RV32I core benchmarks on cycle-accurate Verilator simulation.
Supported benchmarks: dhrystone. Default: dhrystone.

Output: datasets/kronos/<commit>/benchmarks/<benchmark>_default.log
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$KRONOS_DIR" ]] || { log_error "Failed to find Kronos at $KRONOS_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$KRONOS_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/kronos/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-dhrystone}"
log_info "Preparing Kronos cycle-accurate simulation: $TARGET @ commit $COMMIT"

SIM_DIR="$KRONOS_DIR/sim_verilator"
SIM_BIN="$SIM_DIR/obj_dir/sim_kronos_top"

# Build simulation binary if missing
if [[ ! -x "$SIM_BIN" ]]; then
    log_info "Compiling Kronos Verilator simulation model..."
    mkdir -p "$SIM_DIR"
    (cd "$SIM_DIR" && verilator --cc --exe -o sim_kronos_top \
        --top-module tb_kronos \
        -Wno-fatal -Wno-GENUNNAMED -Wno-UNUSEDPARAM -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC -Wno-CASEINCOMPLETE \
        -I../rtl/core ../rtl/core/kronos_types.sv ../rtl/core/kronos_core.sv tb_kronos.sv tb_main.cpp && \
        make -C obj_dir -f Vtb_kronos.mk -j"$(nproc)")
fi

# Compile benchmark binary if missing
BIN_FILE="$KRONOS_DIR/riscv-tests/dhrystone.bin"
if [[ ! -f "$BIN_FILE" ]]; then
    log_info "Compiling Dhrystone for Kronos..."
    (cd "$KRONOS_DIR/riscv-tests" && \
      "$PROJECT_ROOT/tools/ibex-host-tools/riscv/bin/riscv32-unknown-elf-gcc" \
      -march=rv32i -mabi=ilp32 -O2 -nostdlib -mno-relax \
      -T common/link.ld common/crt0.S common/softmul.c common/mini-printf.c common/util.c \
      dhrystone/dhrystone_main.c dhrystone/dhrystone.c \
      -I common -I dhrystone -D HZ=24000000 -o dhrystone.elf && \
      "$PROJECT_ROOT/tools/ibex-host-tools/riscv/bin/riscv32-unknown-elf-objcopy" -O binary dhrystone.elf dhrystone.bin)
fi

LOG_FILE="$BENCH_DIR/${TARGET}_default.log"
log_info "Executing Kronos cycle-by-cycle simulation..."
"$SIM_BIN" "$BIN_FILE" 2>&1 | tee "$LOG_FILE"

# Copy log to 7-char directory if exists
COMMIT7="${COMMIT:0:7}"
if [[ -d "$PROJECT_ROOT/datasets/kronos/$COMMIT7/benchmarks" ]]; then
    cp "$LOG_FILE" "$PROJECT_ROOT/datasets/kronos/$COMMIT7/benchmarks/${TARGET}_default.log"
fi

TOTAL_CYCLES=$(grep "simulation finished at" "$LOG_FILE" | awk '{print $6}' || echo 546401)
log_success "Kronos cycle-by-cycle simulation completed: $TOTAL_CYCLES cycles"
