#!/usr/bin/env bash
#
# End-to-end BlackParrot flow for SCORE: submodule → install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
INSTALL_SCRIPT="$SCRIPT_DIR/install_black_parrot.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_black_parrot.sh"

SKIP_INSTALL=false
SKIP_GENERATE=false

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_black_parrot

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Run the full SCORE BlackParrot pipeline:
  1. ${INSTALL_SCRIPT} (Clone / check tools/black-parrot with submodules)
  2. ${GENERATE_SCRIPT} (Verify and snapshot RTL into datasets/black_parrot/<commit>)

Options:
  -h, --help           Show this help
  --skip-install       Skip install step
  --skip-generate      Skip generate step
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) show_help; exit 0 ;;
        --skip-install) SKIP_INSTALL=true; shift ;;
        --skip-generate) SKIP_GENERATE=true; shift ;;
        *) log_error "Unknown option: $1"; exit 1 ;;
    esac
done

if [[ "$SKIP_INSTALL" != "true" ]]; then
    log_info "Step 1: Installing/Checking BlackParrot..."
    bash "$INSTALL_SCRIPT"
fi

if [[ "$SKIP_GENERATE" != "true" ]]; then
    log_info "Step 2: Generating & snapshotting BlackParrot RTL..."
    bash "$GENERATE_SCRIPT"
fi

log_success "BlackParrot pipeline completed successfully!"
