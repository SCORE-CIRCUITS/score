#!/usr/bin/env bash
# End-to-end proteus flow for SCORE: verify → generate → benchmark.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_proteus

log_info "Starting full verification and benchmark pipeline for proteus"
"$SCRIPT_DIR/generate_proteus.sh"
log_success "Pipeline run for proteus completed successfully."
