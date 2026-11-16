#!/usr/bin/env bash
#
# End-to-end PipelineC HLS flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_pipelinec.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_pipelinec.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_pipelinec

log_info "Step 1: Installing/Checking PipelineC..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating PipelineC HLS designs & snapshot..."
bash "$GENERATE_SCRIPT"

log_success "PipelineC pipeline completed successfully!"
