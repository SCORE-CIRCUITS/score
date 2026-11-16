#!/usr/bin/env bash
# SCORE generate for RISC-V Matrix Extensions & Tile Tensor Accelerators.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
NAME="matrix_extensions"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/snapshot"
LOG_DIR="$DATASET_DIR/logs"

mkdir -p "$LOG_DIR"
source "$SCRIPT_DIR/common_logging.sh"
init_script_logging_files generate_matrix_extensions "$LOG_DIR/main.log"

log_info "Snapshotting matrix extension specifications and hardware descriptions..."
mkdir -p "$DATASET_DIR/integrated-matrix-extension"
mkdir -p "$DATASET_DIR/riscv-matrix-extension-spec"
mkdir -p "$DATASET_DIR/tvm-vta"

rsync -a --delete --exclude '.git' "$PROJECT_ROOT/tools/integrated-matrix-extension/" "$DATASET_DIR/integrated-matrix-extension/"
rsync -a --delete --exclude '.git' "$PROJECT_ROOT/tools/riscv-matrix-extension-spec/" "$DATASET_DIR/riscv-matrix-extension-spec/"
rsync -a --delete --exclude '.git' "$PROJECT_ROOT/tools/tvm-vta/" "$DATASET_DIR/tvm-vta/"

{
    echo "Matrix Extensions SCORE Snapshot"
    echo "Timestamp: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo "Tracked: integrated-matrix-extension, riscv-matrix-extension-spec, tvm-vta"
} > "$DATASET_DIR/summary.txt"

log_success "Matrix extensions generate done → $DATASET_DIR"
