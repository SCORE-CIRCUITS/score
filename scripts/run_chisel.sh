#!/usr/bin/env bash
#
# End-to-end Chisel flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_chisel.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_chisel.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_chisel

log_info "Step 1: Installing/Checking Chisel..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating Chisel snapshot..."
bash "$GENERATE_SCRIPT"

log_success "Chisel pipeline completed successfully!"
