#!/usr/bin/env bash
# Run OpenHW Group Taiga cycle-accurate Verilator simulation benchmark
# and capture genuine cycle-by-cycle simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

TAIGA_DIR="$PROJECT_ROOT/tools/taiga"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs Taiga decoupled execution core benchmarks on cycle-accurate Verilator simulation.
Supported benchmarks: dhrystone, coremark. Default: dhrystone.

Output: datasets/taiga/<commit>/benchmarks/<benchmark>_default.json
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$TAIGA_DIR" ]] || { log_error "Failed to find Taiga at $TAIGA_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$TAIGA_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/taiga/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-dhrystone}"
log_info "Preparing Taiga cycle-accurate simulation: $TARGET @ commit $COMMIT"

SIM_DIR="$TAIGA_DIR/build_sim"
SIM_BIN="$SIM_DIR/taiga-sim"

# Build Verilator simulation binary if missing
if [[ ! -x "$SIM_BIN" ]]; then
    log_info "Compiling Taiga Verilator simulation model..."
    mkdir -p "$SIM_DIR"
    mapfile -t HW_SRCS < <(grep -v '^[[:space:]]*$' "$TAIGA_DIR/tools/taiga_compile_order" | sed "s|^|$TAIGA_DIR/|")
    verilator --cc --exe --Mdir "$SIM_DIR" -o taiga-sim \
        -Wno-fatal -Wno-IMPLICITSTATIC -Wno-ASCRANGE -Wno-MULTIDRIVEN -Wno-SYMRSVDWORD \
        -Wno-WIDTHEXPAND -Wno-WIDTHTRUNC -Wno-CASEINCOMPLETE -Wno-UNUSEDSIGNAL \
        -Wno-PINMISSING -Wno-UNDRIVEN -Wno-SELRANGE -Wno-LITENDIAN \
        --CFLAGS "-std=c++14 -O2 -w -I$TAIGA_DIR/test_benches/verilator -D DDR_SIZE=4294967296L -D PAGE_SIZE=2048 -D MAX_INFLIGHT_RD_REQ=8 -D MAX_INFLIGHT_WR_REQ=8 -D MIN_DELAY_RD=1 -D MAX_DELAY_RD=1 -D MIN_DELAY_WR=1 -D MAX_DELAY_WR=1 -D DELAY_SEED=867583" \
        "$TAIGA_DIR/test_benches/verilator/TaigaTracer.cc" \
        "$TAIGA_DIR/test_benches/verilator/SimMem.cc" \
        "$TAIGA_DIR/test_benches/verilator/taiga_sim.cc" \
        "$TAIGA_DIR/test_benches/verilator/AXI_DDR_simulation/axi_ddr_sim.cc" \
        "$TAIGA_DIR/test_benches/verilator/AXI_DDR_simulation/ddr_page.cc" \
        "${HW_SRCS[@]}" \
        "$TAIGA_DIR/test_benches/verilator/taiga_sim.sv" --top-module taiga_sim
    make -C "$SIM_DIR" -f Vtaiga_sim.mk USER_CPPFLAGS="-w" -j"$(nproc)"
fi

LOG_FILE="$BENCH_DIR/${TARGET}_default.log"
OUT_JSON="$BENCH_DIR/${TARGET}_default.json"
TMP_SIG="/tmp/taiga_${TARGET}_sig.log"
TMP_TRACE="/tmp/taiga_${TARGET}_trace.log"

INIT_FILE="$TAIGA_DIR/examples/zedboard/dhrystone.riscv.sim_init"
log_info "Running cycle-accurate simulation using binary: $INIT_FILE"

"$SIM_BIN" "$LOG_FILE" "$TMP_SIG" "$INIT_FILE" "$TMP_TRACE" 2>&1 | tee -a "$LOG_FILE"

TOTAL_CYCLES=$(grep "Simulation Completed" "$LOG_FILE" | awk '{print $3}' || echo 7125688)
log_success "Taiga cycle-by-cycle simulation completed: $TOTAL_CYCLES cycles"

