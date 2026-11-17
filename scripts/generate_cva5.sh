#!/usr/bin/env bash
# SCORE generate for openhwgroup/cva5 — OpenHW Group CVA5 (Taiga).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/cva5"
NAME="cva5"
PROJECT="openhwgroup/cva5"

source "$SCRIPT_DIR/common_logging.sh"
source "$SCRIPT_DIR/common_simple_rtl.sh"
cd "$PROJECT_ROOT"

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/$COMMIT_ID"
LOG_DIR="$DATASET_DIR/logs"
VER_DIR="$DATASET_DIR/verification"
GEN_DIR="$DATASET_DIR/rtl_generated"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
mkdir -p "$LOG_DIR" "$VER_DIR" "$GEN_DIR"
init_script_logging_files generate_cva5 "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

[[ -d "$TOOL_DIR/core" ]] || { log_error "Missing $TOOL_DIR/core — run install_cva5.sh"; exit 1; }

log_info "Snapshotting CVA5 SystemVerilog RTL @ $COMMIT_ID"
score_simple_snapshot_paths "$TOOL_DIR" "$DATASET_DIR" "$NAME" core apu debug_module README.md LICENSE
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

sv_count="$(find "$DATASET_DIR/rtl_snapshot/$NAME" -name '*.sv' 2>/dev/null | wc -l)"

{
    echo "cva5 SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Architecture: RV32IMACB Decoupled In-Order / Out-of-Order Execution Core"
    echo "SystemVerilog RTL files: $sv_count"
    echo "Generation Status: Ready for Verilator / Vivado elaboration"
} > "$DATASET_DIR/cva5_summary.txt"

log_success "cva5 generate done → $DATASET_DIR ($sv_count SystemVerilog files)"
