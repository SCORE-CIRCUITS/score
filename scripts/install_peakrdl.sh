#!/usr/bin/env bash
#
# Install/initialize PeakRDL tool for SCORE.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/peakrdl"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_peakrdl

if [[ ! -d "$TOOL_DIR/examples" ]]; then
    log_info "Initializing tools/peakrdl submodule..."
    bash "$SCRIPT_DIR/add-optional-tools.sh" peakrdl
fi

log_success "PeakRDL is ready at $TOOL_DIR"
