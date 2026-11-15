#!/usr/bin/env bash
# Build DarkRISCV Dhrystone firmware and run the Icarus SoC sim; write score.benchmark_results.v1 JSON.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"
score_benchmark_setup_path

DARK_DIR="$PROJECT_ROOT/tools/darkriscv"
PROFILE="${SCORE_BENCHMARK_PROFILE:-mcu_verilator}"
CONFIG="${SCORE_BENCHMARK_CONFIG:-default}"
RUNS="${SCORE_DHRYSTONE_RUNS:-100}"
CROSS_PREFIX="$(score_benchmark_riscv_prefix)" || {
    log_error "RISC-V toolchain not found — set SCORE_RISCV_PREFIX"
    exit 1
}

usage() {
    cat <<EOF
Usage: $(basename "$0")

Builds DarkRISCV src/ with APPLICATION=dhrystone and runs sim/ via Icarus Verilog.
Requires: iverilog, ${CROSS_PREFIX}gcc.

Output: datasets/darkriscv/<commit>/benchmarks/dhrystone_${CONFIG}.json
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

[[ -d "$DARK_DIR/rtl" ]] || { log_error "missing $DARK_DIR"; exit 1; }
[[ -d "$DARK_DIR/src/dhrystone" ]] || { log_error "missing DarkRISCV Dhrystone port"; exit 1; }
score_benchmark_require_cmd python3
score_benchmark_require_cmd iverilog
score_benchmark_require_cmd "${CROSS_PREFIX}gcc"

COMMIT="$(score_benchmark_get_commit "$DARK_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/darkriscv/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"
LOG="$BENCH_DIR/dhrystone_${CONFIG}.log"

CROSS_BIN="$(dirname "${CROSS_PREFIX}gcc")"
CROSS_TRIPLE="$(basename "$CROSS_PREFIX")"
CROSS_TRIPLE="${CROSS_TRIPLE%-}"

export CROSS="$CROSS_TRIPLE"
export CCPATH="$CROSS_BIN"
if echo 'int x;' | "${CROSS_PREFIX}gcc" -march=rv32i_zicsr -mabi=ilp32 -c -xc - -o /dev/null 2>/dev/null; then
    export ARCH=rv32i_zicsr
else
    export ARCH=rv32i
    log_info "Toolchain has no zicsr march name; using ARCH=$ARCH"
fi
export ABI=ilp32
export APPLICATION=dhrystone
unset TARGET_ARCH TARGET_MACH || true

log_info "Building DarkRISCV Dhrystone (RUNS=$RUNS CROSS=$CROSS ARCH=$ARCH)"
make -C "$DARK_DIR/src" APPLICATION=dhrystone clean
make -C "$DARK_DIR/src" APPLICATION=dhrystone

[[ -f "$DARK_DIR/src/darksocv.mem" ]] || { log_error "darksocv.mem not produced"; exit 1; }

log_info "Running DarkRISCV Icarus sim (no VCD)"
make -C "$DARK_DIR/sim" clean
make -C "$DARK_DIR/sim" APPLICATION=dhrystone \
    ICARUS="iverilog -Wall -DSCORE_NO_VCD" 2>&1 | tee "$LOG"

METRICS="$(python3 - "$LOG" <<'PY'
import json, re, sys
text = open(sys.argv[1], encoding="utf-8", errors="replace").read()

dhry_sec_m = re.search(r"Dhrystones per Second:\s*(\d+)", text)
dmips_m = re.search(r"DMIPS \(Dhrystones/1757\):\s*(\d+)", text)
pipe_m = re.search(r"DarkRISCV Pipeline Report \((\d+) clocks, (\d+) instr, CPI = ([0-9.]+)\)", text)
us_m = re.search(r"Microseconds for one run through Dhrystone:\s*(\d+)", text)
runs_m = re.search(r"Execution starts,\s*(\d+)\s*runs", text)

if not dhry_sec_m or not dmips_m:
    raise SystemExit("could not parse DarkRISCV Dhrystone results (need Dhrystones per Second and DMIPS)")

dhry_sec = int(dhry_sec_m.group(1))
dmips = int(dmips_m.group(1))
runs = int(runs_m.group(1)) if runs_m else 100
clock_mhz = 100

clocks = int(pipe_m.group(1)) if pipe_m else 0
instrs = int(pipe_m.group(2)) if pipe_m else 0
cpi = float(pipe_m.group(3)) if pipe_m else 0.0

dmips_per_mhz = round(dhry_sec / (1757.0 * clock_mhz), 4)

print(json.dumps({
    "dhrystones_per_sec": dhry_sec,
    "dmips": dmips,
    "dmips_per_mhz": dmips_per_mhz,
    "number_of_runs": runs,
    "total_cycles": clocks,
    "instructions": instrs,
    "cpi": cpi,
    "clock_mhz": clock_mhz,
    "validated": ("simulation ok" in text) and ("DHRYSTONE PROGRAM" in text),
    "timing": "io.timeus",
}))
PY
)"
VER="$(score_benchmark_verilator_version)"
METRICS=$(python3 -c "import json; m=json.loads('''$METRICS'''); m['_verilator']='$VER'; m['simulator']='icarus'; print(json.dumps(m))")

OUT="$BENCH_DIR/dhrystone_${CONFIG}.json"
score_benchmark_write_result "$OUT" darkriscv "$COMMIT" "$PROFILE" dhrystone "$CONFIG" "$METRICS"
log_success "Wrote $OUT"
