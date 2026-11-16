#!/usr/bin/env bash
#
# End-to-end Stanford AHA flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_aha.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_aha.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_aha

log_info "Step 1: Installing/Checking Stanford AHA..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating Stanford AHA snapshot..."
bash "$GENERATE_SCRIPT"

log_success "Stanford AHA pipeline completed successfully!"
