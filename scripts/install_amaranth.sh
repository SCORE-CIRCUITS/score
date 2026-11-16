#!/usr/bin/env bash
#
# Install/initialize Amaranth tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/amaranth"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_amaranth

if [[ ! -d "$TOOL_DIR/amaranth" ]]; then
    log_info "Initializing tools/amaranth submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" amaranth
fi

log_success "Amaranth is ready at $TOOL_DIR"
