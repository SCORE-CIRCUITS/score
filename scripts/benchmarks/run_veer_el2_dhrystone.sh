#!/usr/bin/env bash
# Run VeeR EL2 upstream Dhrystone (TEST=dhry) on Verilator; write score.benchmark_results.v1 JSON.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"
score_benchmark_setup_path

VEER_DIR="$PROJECT_ROOT/tools/veer-el2"
PROFILE="${SCORE_BENCHMARK_PROFILE:-mcu_verilator}"
CONFIG="${SCORE_BENCHMARK_CONFIG:-default}"
TEST="dhry"

usage() {
    cat <<EOF
Usage: $(basename "$0")

Runs chipsalliance Cores-VeeR-EL2 TEST=dhry via tools/Makefile + Verilator.
Requires: install_veer_el2.sh, Verilator.
Uses canned hex: tools/veer-el2/testbench/hex/user_mode0/dhry.hex.

Output: datasets/veer_el2/<commit>/benchmarks/dhrystone_${CONFIG}.json
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

[[ -d "$VEER_DIR/design" ]] || { log_error "missing $VEER_DIR — run install_veer_el2.sh"; exit 1; }
[[ -f "$VEER_DIR/tools/Makefile" ]] || { log_error "missing $VEER_DIR/tools/Makefile"; exit 1; }
[[ -f "$VEER_DIR/testbench/hex/user_mode0/dhry.hex" ]] || {
    log_error "missing canned Dhrystone hex at $VEER_DIR/testbench/hex/user_mode0/dhry.hex"
    exit 1
}
score_benchmark_require_cmd python3
score_benchmark_require_cmd verilator

COMMIT="$(score_benchmark_get_commit "$VEER_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/veer_el2/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"
LOG="$BENCH_DIR/dhrystone_${CONFIG}.log"

export RV_ROOT="$VEER_DIR"
export GCC_PREFIX="score-no-riscv-gcc"

TB_MAX_CYCLES="${TB_MAX_CYCLES:-5000000}"
log_info "Setting up VeeR EL2 Dhrystone hex"
cp "$VEER_DIR/testbench/hex/user_mode0/dhry.hex" "$VEER_DIR/program.hex"
rm -f "$VEER_DIR"/*.sym

SIM_BIN="$VEER_DIR/obj_dir/Vtb_top"
if [[ ! -x "$SIM_BIN" ]]; then
    log_info "Building VeeR EL2 Verilator testbench"
    make -C "$VEER_DIR" -f "$VEER_DIR/tools/Makefile" verilator-build \
        TB_MAX_CYCLES="$TB_MAX_CYCLES" \
        VERILATOR_EXTRA_ARGS="-Wno-ASSIGNIN -GMAX_CYCLES=${TB_MAX_CYCLES} -CFLAGS -Wno-error=logical-op"
fi
[[ -x "$SIM_BIN" ]] || { log_error "missing $SIM_BIN"; exit 1; }

log_info "Running VeeR EL2 Verilator TEST=$TEST TB_MAX_CYCLES=$TB_MAX_CYCLES"
(
    cd "$VEER_DIR"
    ./obj_dir/Vtb_top --test-halt
) 2>&1 | tee "$LOG"

METRICS="$(python3 - "$LOG" <<'PY'
import json, re, sys
text = open(sys.argv[1], errors="replace").read()

dhry_sec_mhz = None
m_sec_mhz = re.search(r"Dhrystones per Second per MHz:\s*([\d.]+)", text)
if m_sec_mhz:
    dhry_sec_mhz = float(m_sec_mhz.group(1))

dmips = None
if dhry_sec_mhz:
    dmips = round(dhry_sec_mhz / 1757.0, 4)

mcycle = None
minstret = None
m_mcycle = re.search(r"mcycle\s*=\s*(\d+)", text)
if m_mcycle:
    mcycle = int(m_mcycle.group(1))
m_minstret = re.search(r"minstret\s*=\s*(\d+)", text)
if m_minstret:
    minstret = int(m_minstret.group(1))

runs_m = re.search(r"Run time\s*=\s*(\d+)\s+clocks for\s+(\d+)\s+Dhrystones", text)
benchmark_clocks = int(runs_m.group(1)) if runs_m else None
runs = int(runs_m.group(2)) if runs_m else None

if dmips is None and dhry_sec_mhz is None:
    raise SystemExit("could not parse Dhrystone metrics from VeeR EL2 output")

validated = "TEST_PASSED" in text

out = {
    "dhrystone_dmips_per_mhz": dmips,
    "dhrystones_per_sec_per_mhz": dhry_sec_mhz,
    "validated": validated,
    "simulator": "verilator",
    "firmware_source": "canned_hex",
}
if mcycle is not None:
    out["total_cycles"] = mcycle
if minstret is not None:
    out["instructions_retired"] = minstret
if benchmark_clocks is not None:
    out["benchmark_cycles"] = benchmark_clocks
if runs is not None:
    out["runs"] = runs

print(json.dumps(out))
PY
)" || {
    log_error "Dhrystone parse failed on $LOG"
    exit 1
}

VER="$(score_benchmark_verilator_version)"
METRICS=$(python3 -c "import json; m=json.loads('''$METRICS'''); m['_verilator']='$VER'; m['veer_test']='$TEST'; print(json.dumps(m))")

OUT="$BENCH_DIR/dhrystone_${CONFIG}.json"
score_benchmark_write_result "$OUT" veer_el2 "$COMMIT" "$PROFILE" dhrystone "$CONFIG" "$METRICS"
log_success "Wrote $OUT"
