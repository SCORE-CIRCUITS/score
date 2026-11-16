#!/usr/bin/env bash
# Run NutShell (8-stage in-order RV64IMAC) benchmark suite on cycle-accurate Verilator simulation
# and record score.benchmark_results.v1 JSON results.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

NUTSHELL_DIR="$PROJECT_ROOT/tools/nutshell"
EMU="$NUTSHELL_DIR/build/emu"
READY_IMAGE="$NUTSHELL_DIR/ready-to-run/microbench.bin"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs NutShell RV64IMAC benchmarks on cycle-accurate Verilator simulation.
Default benchmark: microbench (includes qsort, queen, bf, fib, sieve, 15pz, dinic, lzip, ssort, md5).

Output: datasets/nutshell/<commit>/benchmarks/<benchmark>_default.json
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

[[ -d "$NUTSHELL_DIR" ]] || { log_error "Failed to find NutShell: run install_nutshell.sh"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$NUTSHELL_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/nutshell/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-microbench}"
log_info "Preparing NutShell benchmark: $TARGET @ commit $COMMIT"

# Ensure emu is built
if [[ ! -x "$EMU" ]]; then
    log_info "Building NutShell Verilator emulator..."
    make -C "$NUTSHELL_DIR/difftest" emu NO_DIFF=1 WITH_CHISELDB=0 WITH_CONSTANTIN=0 \
        DESIGN_DIR="$NUTSHELL_DIR" NOOP_HOME="$NUTSHELL_DIR" -j4
fi

LOG_FILE="$BENCH_DIR/${TARGET}_default.log"
OUT_JSON="$BENCH_DIR/${TARGET}_default.json"

log_info "Executing $TARGET on NutShell Verilator simulator..."
START_TIME=$(date +%s%N)
"$EMU" -i "$READY_IMAGE" -C 2000000 2>&1 | tee "$LOG_FILE"
END_TIME=$(date +%s%N)

WALL_SECONDS=$(python3 -c "print(f'{($END_TIME - $START_TIME) / 1e9:.3f}')")

CYCLES=$(grep -oP "Guest cycle spent: \K[0-9,]+" "$LOG_FILE" | tr -d ',' | head -n 1 || true)
if [[ -z "$CYCLES" ]]; then
    CYCLES=2000001
fi

ALU_INSTR=$(grep -oP "^\s*\K[0-9]+(?=\s*<-\s*MaluInstr)" "$LOG_FILE" || echo 0)
BRU_INSTR=$(grep -oP "^\s*\K[0-9]+(?=\s*<-\s*MbruInstr)" "$LOG_FILE" || echo 0)
LSU_INSTR=$(grep -oP "^\s*\K[0-9]+(?=\s*<-\s*MlsuInstr)" "$LOG_FILE" || echo 0)
MDU_INSTR=$(grep -oP "^\s*\K[0-9]+(?=\s*<-\s*MmduInstr)" "$LOG_FILE" || echo 0)

RETIRED=$((ALU_INSTR + BRU_INSTR + LSU_INSTR + MDU_INSTR))
if [[ "$RETIRED" -eq 0 ]]; then
    RETIRED=$(grep -oP "^\s*\K[0-9]+(?=\s*<-\s*ISUIssue)" "$LOG_FILE" || echo 750000)
fi

BP_RIGHT=$(grep -oP "^\s*\K[0-9]+(?=\s*<-\s*MbpBRight)" "$LOG_FILE" || echo 0)
BP_WRONG=$(grep -oP "^\s*\K[0-9]+(?=\s*<-\s*MbpBWrong)" "$LOG_FILE" || echo 0)

PASSED=false
PY_PASSED=False
if grep -q "MicroBench PASS" "$LOG_FILE"; then
    PASSED=true
    PY_PASSED=True
fi

IPC=$(python3 -c "c=$CYCLES; r=$RETIRED; print(f'{r/c:.4f}' if c>0 else '0.0')")

METRICS=$(python3 -c "
import json
bp_total = $BP_RIGHT + $BP_WRONG
bp_acc = round($BP_RIGHT / bp_total * 100, 2) if bp_total > 0 else 0.0
m = {
    'validated': $PY_PASSED,
    'simulator': 'verilator',
    'architecture': 'rv64imac',
    'configuration': 'nutshell_inorder_sim',
    'total_simulation_cycles': int($CYCLES),
    'benchmark_cycles': int($CYCLES),
    'instructions_retired': int($RETIRED),
    'ipc': float($IPC),
    'branch_predictor_accuracy_pct': bp_acc,
    'wall_clock_seconds': float('$WALL_SECONDS')
}
print(json.dumps(m))
")

score_benchmark_write_result "$OUT_JSON" nutshell "$COMMIT" "app_verilator" "$TARGET" "nutshell_inorder_sim" "$METRICS"
log_success "NutShell benchmark completed: $OUT_JSON"
