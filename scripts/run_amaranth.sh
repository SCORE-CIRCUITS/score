#!/usr/bin/env bash
#
# End-to-end Amaranth flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_amaranth.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_amaranth.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_amaranth

log_info "Step 1: Installing/Checking Amaranth..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating Amaranth snapshot..."
bash "$GENERATE_SCRIPT"

log_success "Amaranth pipeline completed successfully!"
