#!/usr/bin/env bash
# End-to-end vespa flow for SCORE: verify → generate → benchmark.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_vespa

log_info "Starting full verification and benchmark pipeline for vespa"
"$SCRIPT_DIR/generate_vespa.sh"
log_success "Pipeline run for vespa completed successfully."
