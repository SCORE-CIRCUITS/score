#!/usr/bin/env bash
# Run Dhrystone 2.1 on Ibex Simple System (Verilator) and write score.benchmark_results.v1 JSON.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"
score_benchmark_setup_path
score_benchmark_activate_ibex_venv

IBEX_DIR="$PROJECT_ROOT/tools/ibex"
PROFILE="${SCORE_BENCHMARK_PROFILE:-mcu_verilator}"
CONFIGS=()

usage() {
    cat <<EOF
Usage: $(basename "$0") [--config NAME]... [--profile mcu_verilator]

Runs Dhrystone on Ibex simple system for each config (default: small).
Requires: ./scripts/install_ibex.sh and ibex venv/fusesoc.

Output: datasets/ibex/<commit>/benchmarks/dhrystone_<config>.json
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage; exit 0 ;;
        --profile) PROFILE="$2"; shift 2 ;;
        --config) CONFIGS+=("$2"); shift 2 ;;
        *) log_error "unknown argument: $1"; usage; exit 1 ;;
    esac
done

[[ -d "$IBEX_DIR" ]] || { log_error "missing $IBEX_DIR — run install_ibex.sh"; exit 1; }
if [[ ${#CONFIGS[@]} -eq 0 ]]; then
    CONFIGS=(small)
fi

COMMIT="$(score_benchmark_get_commit "$IBEX_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/ibex/$COMMIT"
BENCH_DIR="$DATASET_DIR/benchmarks"
mkdir -p "$BENCH_DIR"

score_benchmark_require_cmd python3
score_benchmark_require_cmd verilator
score_benchmark_require_cmd fusesoc

CROSS_PREFIX="$(score_benchmark_riscv_prefix)" || {
    log_error "RISC-V toolchain not found — set SCORE_RISCV_PREFIX"
    exit 1
}
export PATH="$(dirname "${CROSS_PREFIX}gcc"):$PATH"

cd "$IBEX_DIR"

if [[ -f "$IBEX_DIR/venv/bin/activate" ]]; then
    # shellcheck disable=SC1091
    source "$IBEX_DIR/venv/bin/activate"
fi

ibex_rv_isa_for_config() {
    case "$1" in
        micro) echo rv32imc ;;
        *) echo rv32im ;;
    esac
}

VERILATOR_VER="$(score_benchmark_verilator_version)"
HOST_JSON="$(score_benchmark_host_json)"

for cfg in "${CONFIGS[@]}"; do
    log_info "Ibex Dhrystone config=$cfg"
    BUILD_DIR="$IBEX_DIR/build/score_coremark_${cfg}"
    SIM_BIN=$(find "$BUILD_DIR" -name 'Vibex_simple_system' -type f 2>/dev/null | head -1 || true)
    if [[ -z "$SIM_BIN" || ! -x "$SIM_BIN" ]]; then
        log_info "Building Ibex simulation for config=$cfg..."
        rm -rf "$BUILD_DIR"
        mkdir -p "$BUILD_DIR"
        read -r -a IBEX_FUSESOC_OPTS < <(score_benchmark_filter_ibex_fusesoc_opts "$cfg" "$IBEX_DIR")
        (
            cd "$IBEX_DIR"
            fusesoc --cores-root="$IBEX_DIR" run --target=sim --setup --build \
                --build-root="$BUILD_DIR" \
                lowrisc:ibex:ibex_simple_system \
                "${IBEX_FUSESOC_OPTS[@]}"
        )
        SIM_BIN=$(find "$BUILD_DIR" -name 'Vibex_simple_system' -type f | head -1)
    fi
    [[ -n "$SIM_BIN" && -x "$SIM_BIN" ]] || { log_error "Verilator binary not found for $cfg"; exit 1; }

    RV_ISA="$(ibex_rv_isa_for_config "$cfg")"
    DHRY_SRC_DIR="$PROJECT_ROOT/benchmarks/core/ibex_dhrystone"
    make -C "$DHRY_SRC_DIR" clean >/dev/null 2>&1 || true
    make -C "$DHRY_SRC_DIR" CROSS_PREFIX="$CROSS_PREFIX" RV_ISA="$RV_ISA" IBEX_DIR="$IBEX_DIR"

    ELF="$DHRY_SRC_DIR/dhrystone.elf"
    [[ -f "$ELF" ]] || { log_error "dhrystone.elf not built"; exit 1; }

    LOG="$BENCH_DIR/dhrystone_${cfg}.log"
    rm -f "$IBEX_DIR/ibex_simple_system.log"
    "$SIM_BIN" --meminit=ram,"$ELF" 2>&1 | tee "$LOG"

    if [[ -f "$IBEX_DIR/ibex_simple_system.log" ]]; then
        cat "$IBEX_DIR/ibex_simple_system.log" >> "$LOG"
    fi

    METRICS="$(python3 - "$LOG" <<'PY'
import json, re, sys
text = open(sys.argv[1], errors="replace").read()

dmips = None
m = re.search(r"DMIPS_Per_MHz:\s*([\d.]+)", text)
if m:
    dmips = float(m.group(1))

dhry_sec = None
m_sec = re.search(r"Dhrystones_Per_Second_Per_MHz:\s*([\d.]+)", text)
if m_sec:
    dhry_sec = float(m_sec.group(1))

cycles = None
m_cycles = re.search(r"Cycles:\s*(\d+)", text) or re.search(r"User_Time:\s*(\d+)\s+cycles", text)
if m_cycles:
    cycles = int(m_cycles.group(1))

user_cycles = None
m_uc = re.search(r"User_Time:\s*(\d+)\s+cycles", text)
if m_uc:
    user_cycles = int(m_uc.group(1))

insn = None
m_insn = re.search(r"Instructions Retired:\s*(\d+)", text) or re.search(r"User_Time:.*?(\d+)\s+insn", text)
if m_insn:
    insn = int(m_insn.group(1))

cpi = None
m_cpi = re.search(r"Cycles_Per_Instruction:\s*([\d.]+)", text)
if m_cpi:
    cpi = float(m_cpi.group(1))

if dmips is None and dhry_sec is None:
    raise SystemExit("could not parse Dhrystone metrics from Ibex output")

validated = "DONE" in text

out = {
    "dhrystone_dmips_per_mhz": dmips,
    "dhrystones_per_sec_per_mhz": dhry_sec,
    "validated": validated,
    "simulator": "verilator",
    "ibex_config": sys.argv[1].split("_")[-1].replace(".log", ""),
}
if cycles is not None:
    out["total_cycles"] = cycles
if user_cycles is not None:
    out["benchmark_cycles"] = user_cycles
if insn is not None:
    out["instructions_retired"] = insn
if cpi is not None:
    out["cpi"] = cpi

print(json.dumps(out))
PY
)" || {
        log_error "Dhrystone parse failed on $LOG"
        exit 1
    }

    METRICS=$(python3 -c "import json; m=json.loads('''$METRICS'''); m['_verilator']='$VERILATOR_VER'; m['ibex_config']='$cfg'; print(json.dumps(m))")

    OUT="$BENCH_DIR/dhrystone_${cfg}.json"
    score_benchmark_write_result "$OUT" ibex "$COMMIT" "$PROFILE" dhrystone "$cfg" "$METRICS"
    log_success "Wrote $OUT"
done
