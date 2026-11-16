#!/usr/bin/env bash
# SCORE install for RISC-V Matrix Extensions & Tile Accelerators.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common_logging.sh"
init_script_logging install_matrix_extensions

log_info "Verifying Matrix Extension specifications and repositories..."
for d in tools/integrated-matrix-extension tools/riscv-matrix-extension-spec tools/tvm-vta; do
    if [[ -d "$PROJECT_ROOT/$d" ]]; then
        log_success "$d present"
    else
        log_warning "$d missing"
    fi
done

log_success "Matrix extensions repositories ready."
