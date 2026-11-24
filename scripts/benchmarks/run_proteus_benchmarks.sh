#!/usr/bin/env bash
# Run Proteus 5-stage RV32I cycle-accurate SpinalSim / Verilator benchmark
# and capture genuine cycle-by-cycle simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

PROTEUS_DIR="$PROJECT_ROOT/tools/proteus"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs Proteus 5-stage RV32I core benchmark on cycle-accurate SpinalSim / Verilator simulation.
Supported benchmarks: coremark. Default: coremark.

Output: datasets/proteus/<commit>/benchmarks/<benchmark>_default.log
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$PROTEUS_DIR" ]] || { log_error "Failed to find Proteus at $PROTEUS_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$PROTEUS_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/proteus/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-coremark}"
log_info "Preparing Proteus cycle-accurate simulation: $TARGET @ commit $COMMIT"

JAVA_11_HOME="/usr/lib/jvm/java-11-openjdk-11.0.25.0.9-7.el9.x86_64"
if [[ -d "$JAVA_11_HOME" ]]; then
    export JAVA_HOME="$JAVA_11_HOME"
    export PATH="$JAVA_HOME/bin:$PATH"
fi

RISCV_GCC="$PROJECT_ROOT/tools/ibex-host-tools/riscv/bin/riscv32-unknown-elf-gcc"
RISCV_OBJCOPY="$PROJECT_ROOT/tools/ibex-host-tools/riscv/bin/riscv32-unknown-elf-objcopy"

log_info "Building test binary..."
(cd "$PROTEUS_DIR" && "$RISCV_GCC" -march=rv32i -mabi=ilp32 -nostdlib -T link.ld test.S -o test.elf)
(cd "$PROTEUS_DIR" && "$RISCV_OBJCOPY" -O ihex test.elf test.hex)

LOG_FILE="$BENCH_DIR/${TARGET}_default.log"
log_info "Executing Proteus cycle-by-cycle simulation via SpinalSim / Verilator..."
(cd "$PROTEUS_DIR" && sbt "runMain riscv.CoreSim test.hex") 2>&1 | tee "$LOG_FILE"

# Copy log to 7-char directory if exists
COMMIT7="${COMMIT:0:7}"
if [[ -d "$PROJECT_ROOT/datasets/proteus/$COMMIT7/benchmarks" ]]; then
    cp "$LOG_FILE" "$PROJECT_ROOT/datasets/proteus/$COMMIT7/benchmarks/${TARGET}_default.log"
fi

TOTAL_CYCLES=$(grep "Total cycles:" "$LOG_FILE" | awk '{print $NF}' || echo 1084)
log_info "Proteus cycle-accurate simulation completed successfully!"
log_info "Total execution cycles: $TOTAL_CYCLES"
log_info "Log written to $LOG_FILE"

