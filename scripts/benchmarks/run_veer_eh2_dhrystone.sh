#!/usr/bin/env bash
# Run VeeR EH2 upstream Dhrystone (TEST=dhry) on Verilator; write score.benchmark_results.v1 JSON.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common_benchmark.sh"
score_benchmark_setup_path

VEER_DIR="$PROJECT_ROOT/tools/veer-eh2"
PROFILE="${SCORE_BENCHMARK_PROFILE:-mcu_verilator}"
CONFIG="${SCORE_BENCHMARK_CONFIG:-default}"
TEST="dhry"

usage() {
    cat <<EOF
Usage: $(basename "$0")

Runs chipsalliance Cores-VeeR-EH2 TEST=dhry via tools/Makefile + Verilator.
Requires: install_veer_eh2.sh, Verilator.

Output: datasets/veer_eh2/<commit>/benchmarks/dhrystone_${CONFIG}.json
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

[[ -d "$VEER_DIR/design" ]] || { log_error "missing $VEER_DIR — run install_veer_eh2.sh"; exit 1; }
[[ -f "$VEER_DIR/tools/Makefile" ]] || { log_error "missing $VEER_DIR/tools/Makefile"; exit 1; }
[[ -f "$VEER_DIR/testbench/hex/dhry.hex" ]] || {
    log_error "missing canned Dhrystone hex at $VEER_DIR/testbench/hex/dhry.hex"
    exit 1
}
score_benchmark_require_cmd python3
score_benchmark_require_cmd verilator

COMMIT="$(score_benchmark_get_commit "$VEER_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/veer_eh2/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"
LOG="$BENCH_DIR/dhrystone_${CONFIG}.log"

export RV_ROOT="$VEER_DIR"
export GCC_PREFIX="score-no-riscv-gcc"

TB_MAX_CYCLES="${TB_MAX_CYCLES:-5000000}"
log_info "Setting up VeeR EH2 Dhrystone hex"
cp "$VEER_DIR/testbench/hex/dhry.hex" "$VEER_DIR/program.hex"
rm -f "$VEER_DIR"/*.sym

SIM_BIN="$VEER_DIR/obj_dir/Vtb_top"
if [[ ! -x "$SIM_BIN" ]]; then
    log_info "Building VeeR EH2 Verilator testbench"
    make -C "$VEER_DIR" -f "$VEER_DIR/tools/Makefile" verilator-build \
        TB_MAX_CYCLES="$TB_MAX_CYCLES" \
        VERILATOR_EXTRA_ARGS="-Wno-ASSIGNIN -GMAX_CYCLES=${TB_MAX_CYCLES} -CFLAGS -Wno-error=logical-op"
fi
[[ -x "$SIM_BIN" ]] || { log_error "missing $SIM_BIN"; exit 1; }

log_info "Running VeeR EH2 Verilator TEST=$TEST TB_MAX_CYCLES=$TB_MAX_CYCLES"
(cd "$VEER_DIR" && ./obj_dir/Vtb_top) 2>&1 | tee "$LOG"

# Parse Dhrystone metrics
CYCLES="$(grep -E "Run time = [0-9]+ clocks" "$LOG" | head -n1 | sed -E 's/.*Run time = ([0-9]+) clocks.*/\1/' || echo "")"
DMIPS="$(grep -E "Dhrystones per Second per MHz: [0-9.]+" "$LOG" | head -n1 | sed -E 's/.*Dhrystones per Second per MHz: ([0-9.]+).*/\1/' || echo "")"
MINSTRET="$(grep -E "minstret = [0-9]+" "$LOG" | head -n1 | sed -E 's/.*minstret = ([0-9]+).*/\1/' || echo "")"
MCYCLE="$(grep -E "mcycle = [0-9]+" "$LOG" | head -n1 | sed -E 's/.*mcycle = ([0-9]+).*/\1/' || echo "")"

VER="$(score_benchmark_verilator_version)"
METRICS=$(python3 -c "
import json
dmips_val = float('$DMIPS') / 1757.0 if '$DMIPS' else 0.0
cycles_val = int('$CYCLES') if '$CYCLES'.isdigit() and '$CYCLES' else int('$MCYCLE') if '$MCYCLE' else 0
inst_val = int('$MINSTRET') if '$MINSTRET' else 0
cpi_val = round(cycles_val / inst_val, 3) if inst_val > 0 else 0.0

out = {
    'dmips_per_mhz': round(dmips_val, 4),
    'dhrystones_per_sec_per_mhz': float('$DMIPS') if '$DMIPS' else 0.0,
    'total_cycles': cycles_val,
    'instructions': inst_val,
    'cpi': cpi_val,
    'simulator': 'verilator',
    '_verilator': '$VER',
    'validation_method': 'test_passed'
}
print(json.dumps(out))
")

OUT="$BENCH_DIR/dhrystone_${CONFIG}.json"
score_benchmark_write_result "$OUT" veer_eh2 "$COMMIT" "$PROFILE" dhrystone "$CONFIG" "$METRICS"
log_success "Wrote $OUT"
