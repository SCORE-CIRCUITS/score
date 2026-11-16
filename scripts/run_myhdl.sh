#!/usr/bin/env bash
#
# End-to-end MyHDL flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_myhdl.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_myhdl.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_myhdl

log_info "Step 1: Installing/Checking MyHDL..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating MyHDL RTL & snapshot..."
bash "$GENERATE_SCRIPT"

log_success "MyHDL pipeline completed successfully!"
