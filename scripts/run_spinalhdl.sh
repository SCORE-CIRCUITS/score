#!/usr/bin/env bash
#
# End-to-end SpinalHDL flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_spinalhdl.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_spinalhdl.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_spinalhdl

log_info "Step 1: Installing/Checking SpinalHDL..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating SpinalHDL snapshot..."
bash "$GENERATE_SCRIPT"

log_success "SpinalHDL pipeline completed successfully!"
