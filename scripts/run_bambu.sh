#!/usr/bin/env bash
#
# End-to-end PandA-Bambu flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_bambu.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_bambu.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_bambu

log_info "Step 1: Installing/Checking PandA-Bambu..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating PandA-Bambu snapshot..."
bash "$GENERATE_SCRIPT"

log_success "PandA-Bambu pipeline completed successfully!"
