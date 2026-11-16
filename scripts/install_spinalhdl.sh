#!/usr/bin/env bash
#
# Install/initialize SpinalHDL tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/spinalhdl"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_spinalhdl

if [[ ! -d "$TOOL_DIR/core" ]]; then
    log_info "Initializing tools/spinalhdl submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" spinalhdl
fi

log_success "SpinalHDL is ready at $TOOL_DIR"
