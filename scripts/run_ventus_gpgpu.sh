#!/usr/bin/env bash
# End-to-end ventus_gpgpu flow for SCORE: verify → generate → benchmark.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common_logging.sh"
init_script_logging run_ventus_gpgpu

log_info "Starting full verification and benchmark pipeline for ventus_gpgpu"
"$SCRIPT_DIR/generate_ventus_gpgpu.sh"
log_success "Pipeline run for ventus_gpgpu completed successfully."
