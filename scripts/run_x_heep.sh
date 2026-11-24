#!/usr/bin/env bash
# End-to-end x_heep flow for SCORE: verify → generate → benchmark.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_x_heep

log_info "Starting full verification and benchmark pipeline for x_heep"
"$SCRIPT_DIR/generate_x_heep.sh"
log_success "Pipeline run for x_heep completed successfully."
