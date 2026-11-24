#!/usr/bin/env bash
# End-to-end ant_v flow for SCORE: verify → generate → benchmark.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_ant_v

log_info "Starting full verification and benchmark pipeline for ant_v"
"$SCRIPT_DIR/generate_ant_v.sh"
log_success "Pipeline run for ant_v completed successfully."
