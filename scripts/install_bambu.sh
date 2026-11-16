#!/usr/bin/env bash
#
# Install/initialize PandA-Bambu tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/bambu"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_bambu

if [[ ! -d "$TOOL_DIR/src" ]]; then
    log_info "Initializing tools/bambu submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" bambu
fi

log_success "PandA-Bambu is ready at $TOOL_DIR"
