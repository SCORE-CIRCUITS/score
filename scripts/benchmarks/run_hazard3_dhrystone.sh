#!/usr/bin/env bash
# Run Dhrystone on Hazard3 CXXRTL testbench and write score.benchmark_results.v1 JSON.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"
score_benchmark_setup_path

HAZARD3_DIR="$PROJECT_ROOT/tools/hazard3"
SIM_DIR="$HAZARD3_DIR/test/sim"
DHRY_DIR="$SIM_DIR/dhrystone"
TB_DIR="$SIM_DIR/tb_cxxrtl"
PROFILE="${SCORE_BENCHMARK_PROFILE:-mcu_verilator}"
CONFIG="${SCORE_BENCHMARK_CONFIG:-default}"
CROSS_PREFIX="$(score_benchmark_riscv_prefix)" || {
    log_error "RISC-V toolchain not found — set SCORE_RISCV_PREFIX"
    exit 1
}
CXX="$(score_benchmark_cxx)" || {
    log_error "C++ compiler not found — set SCORE_CXX"
    exit 1
}

usage() {
    cat <<EOF
Usage: $(basename "$0")

Requires: yosys, clang++, ${CROSS_PREFIX}gcc
Builds Hazard3 CXXRTL tb + upstream Dhrystone, runs simulation, parses Dhrystone score.

Output: datasets/hazard3/<commit>/benchmarks/dhrystone_<config>.json
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

[[ -d "$HAZARD3_DIR/hdl" ]] || { log_error "missing $HAZARD3_DIR — run install_hazard3.sh"; exit 1; }
[[ -d "$DHRY_DIR" ]] || { log_error "missing $DHRY_DIR"; exit 1; }
score_benchmark_require_cmd python3
score_benchmark_require_cmd yosys
score_benchmark_require_cmd "$CXX"
score_benchmark_require_cmd "${CROSS_PREFIX}gcc"

COMMIT="$(score_benchmark_get_commit "$HAZARD3_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/hazard3/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"
LOG="$BENCH_DIR/dhrystone_${CONFIG}.log"

log_info "Building Hazard3 CXXRTL testbench (config=$CONFIG)"
make -C "$TB_DIR" CLANGXX="$CXX" CONFIG="$CONFIG"

TBEXEC="$TB_DIR/tb"
[[ -x "$TBEXEC" ]] || { log_error "testbench binary not found at $TBEXEC"; exit 1; }

log_info "Building Hazard3 Dhrystone firmware"
MEMMAP_LD="$PROJECT_ROOT/benchmarks/core/hazard3_coremark/memmap.ld"
if [[ ! -f "$MEMMAP_LD" ]]; then
    MEMMAP_LD="$PROJECT_ROOT/tools/hazard3/test/sim/common/memmap.ld"
fi

mkdir -p "$DHRY_DIR/tmp"
(
    cd "$DHRY_DIR"
    "${CROSS_PREFIX}gcc" -O3 -fno-inline -std=gnu99 -march=rv32imac -mabi=ilp32 \
        -Wno-implicit-function-declaration -Wno-implicit-int \
        ../common/init.S src/dhrystone_main.c src/dhrystone.c src/util.c \
        -T "$MEMMAP_LD" -Wl,--noinhibit-exec -I../common \
        -o tmp/dhrystone.elf
    "${CROSS_PREFIX}objcopy" -O binary tmp/dhrystone.elf tmp/dhrystone.bin
)

[[ -f "$DHRY_DIR/tmp/dhrystone.bin" ]] || { log_error "dhrystone.bin not produced"; exit 1; }

log_info "Running Hazard3 Dhrystone simulation"
"$TBEXEC" --bin "$DHRY_DIR/tmp/dhrystone.bin" --cycles 10000000 --cpuret 2>&1 | tee "$LOG"

METRICS="$(python3 - "$LOG" <<'PY'
import json, re, sys
text = open(sys.argv[1], errors="replace").read()

dhry_sec = None
m_sec = re.search(r"Dhrystones per Second:\s*([\d.]+)", text)
if m_sec:
    dhry_sec = float(m_sec.group(1))

dmips = None
if dhry_sec:
    dmips = round(dhry_sec / 1757.0, 4)

cycles = None
m_cycles = re.search(r"Ran for (\d+) cycles", text)
if m_cycles:
    cycles = int(m_cycles.group(1))

usec_m = re.search(r"Microseconds for one run through Dhrystone:\s*([\d.]+)", text)
usec = float(usec_m.group(1)) if usec_m else None

runs_m = re.search(r"Trying (\d+) runs through Dhrystone", text)
runs = int(runs_m.group(1)) if runs_m else None

if dmips is None and dhry_sec is None:
    raise SystemExit("could not parse Dhrystone metrics from Hazard3 output")

validated = "CPU requested halt. Exit code 0" in text

out = {
    "dhrystone_dmips_per_mhz": dmips,
    "dhrystones_per_sec": dhry_sec,
    "validated": validated,
    "simulator": "cxxrtl",
    "hazard3_config": "default",
}
if cycles is not None:
    out["total_cycles"] = cycles
if usec is not None:
    out["usec_per_run"] = usec
if runs is not None:
    out["runs"] = runs

print(json.dumps(out))
PY
)" || {
    log_error "Dhrystone parse failed on $LOG"
    exit 1
}

VER="$(score_benchmark_verilator_version)"
METRICS=$(python3 -c "import json; m=json.loads('''$METRICS'''); m['_verilator']='$VER'; print(json.dumps(m))")

OUT="$BENCH_DIR/dhrystone_${CONFIG}.json"
score_benchmark_write_result "$OUT" hazard3 "$COMMIT" "$PROFILE" dhrystone "$CONFIG" "$METRICS"
log_success "Wrote $OUT"
