#!/usr/bin/env bash
#
# End-to-end PyMTL3 flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_pymtl3.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_pymtl3.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_pymtl3

log_info "Step 1: Installing/Checking PyMTL3..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating PyMTL3 snapshot..."
bash "$GENERATE_SCRIPT"

log_success "PyMTL3 pipeline completed successfully!"
