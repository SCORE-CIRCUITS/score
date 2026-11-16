#!/usr/bin/env bash
#
# Install/initialize Chisel tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/chisel"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_chisel

if [[ ! -d "$TOOL_DIR/core" ]]; then
    log_info "Initializing tools/chisel submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" chisel
fi

log_success "Chisel is ready at $TOOL_DIR"
