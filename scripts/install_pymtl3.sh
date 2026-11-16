#!/usr/bin/env bash
#
# Install/initialize PyMTL3 tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/pymtl3"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_pymtl3

if [[ ! -d "$TOOL_DIR/pymtl3" ]]; then
    log_info "Initializing tools/pymtl3 submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" pymtl3
fi

log_success "PyMTL3 is ready at $TOOL_DIR"
