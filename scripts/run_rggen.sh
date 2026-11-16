#!/usr/bin/env bash
#
# End-to-end RgGen flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_rggen.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_rggen.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_rggen

log_info "Step 1: Installing/Checking RgGen..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating RgGen snapshot..."
bash "$GENERATE_SCRIPT"

log_success "RgGen pipeline completed successfully!"
