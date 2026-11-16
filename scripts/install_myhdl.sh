#!/usr/bin/env bash
#
# Install/initialize MyHDL tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/myhdl"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_myhdl

if [[ ! -d "$TOOL_DIR/myhdl" ]]; then
    log_info "Initializing tools/myhdl submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" myhdl
fi

log_success "MyHDL is ready at $TOOL_DIR"
