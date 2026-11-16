#!/usr/bin/env bash
#
# End-to-end NutShell flow for SCORE: clone → install → generate → benchmarks.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
INSTALL_SCRIPT="$SCRIPT_DIR/install_nutshell.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_nutshell.sh"
BENCH_SCRIPT="$SCRIPT_DIR/benchmarks/run_nutshell_benchmarks.sh"

SKIP_INSTALL=false
SKIP_GENERATE=false
RUN_BENCH=true

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_nutshell

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Run the full SCORE NutShell pipeline:
  1. ${INSTALL_SCRIPT} (Clone / check tools/nutshell with difftest)
  2. ${GENERATE_SCRIPT} (Verify and snapshot RTL into datasets/nutshell/<commit>)
  3. ${BENCH_SCRIPT} (Run microbench benchmark suite on Verilator emulator)

Options:
  -h, --help           Show this help
  --skip-install       Skip install step
  --skip-generate      Skip generate step
  --no-bench           Skip running benchmark
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) show_help; exit 0 ;;
        --skip-install) SKIP_INSTALL=true; shift ;;
        --skip-generate) SKIP_GENERATE=true; shift ;;
        --no-bench) RUN_BENCH=false; shift ;;
        *) log_error "Unknown option: $1"; exit 1 ;;
    esac
done

if [[ "$SKIP_INSTALL" != "true" ]]; then
    log_info "Step 1: Installing/Checking NutShell..."
    bash "$INSTALL_SCRIPT"
fi

if [[ "$SKIP_GENERATE" != "true" ]]; then
    log_info "Step 2: Generating & snapshotting NutShell RTL..."
    bash "$GENERATE_SCRIPT"
fi

if [[ "$RUN_BENCH" == "true" ]]; then
    log_info "Step 3: Running NutShell benchmarks..."
    bash "$BENCH_SCRIPT" microbench
fi

log_success "NutShell pipeline completed successfully!"
