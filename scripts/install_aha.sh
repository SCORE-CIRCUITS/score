#!/usr/bin/env bash
#
# Install/initialize Stanford AHA tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/aha"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_aha

if [[ ! -d "$TOOL_DIR/aha" ]]; then
    log_info "Initializing tools/aha submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" aha
fi

log_success "Stanford AHA is ready at $TOOL_DIR"
