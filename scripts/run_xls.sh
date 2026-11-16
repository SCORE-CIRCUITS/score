#!/usr/bin/env bash
#
# End-to-end Google XLS flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_xls.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_xls.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_xls

log_info "Step 1: Installing/Checking Google XLS..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating Google XLS snapshot..."
bash "$GENERATE_SCRIPT"

log_success "Google XLS pipeline completed successfully!"
