#!/usr/bin/env bash
#
# Install/initialize RgGen register tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/rggen"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_rggen

if [[ ! -d "$TOOL_DIR/lib" ]]; then
    log_info "Initializing tools/rggen submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" rggen
fi

log_success "RgGen is ready at $TOOL_DIR"
