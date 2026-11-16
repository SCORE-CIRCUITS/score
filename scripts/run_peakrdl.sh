#!/usr/bin/env bash
#
# End-to-end PeakRDL flow for SCORE: install → generate.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install_peakrdl.sh"
GENERATE_SCRIPT="$SCRIPT_DIR/generate_peakrdl.sh"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_peakrdl

log_info "Step 1: Installing/Checking PeakRDL..."
bash "$INSTALL_SCRIPT"

log_info "Step 2: Generating PeakRDL SystemVerilog registers & snapshot..."
bash "$GENERATE_SCRIPT"

log_success "PeakRDL pipeline completed successfully!"
