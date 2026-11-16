#!/usr/bin/env bash
#
# Install/initialize PipelineC HLS tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/pipelinec"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_pipelinec

if [[ ! -d "$TOOL_DIR/src" ]]; then
    log_info "Initializing tools/pipelinec submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" pipelinec
fi

log_success "PipelineC is ready at $TOOL_DIR"
