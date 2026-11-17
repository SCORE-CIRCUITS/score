#!/usr/bin/env bash
# SCORE generate for shaktiproject/c-class — IIT Madras SHAKTI C-Class.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/shakti"
NAME="shakti"
PROJECT="shaktiproject/c-class"

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
init_script_logging_files generate_shakti "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

[[ -d "$TOOL_DIR/src" ]] || { log_error "Missing $TOOL_DIR/src — run install_shakti.sh"; exit 1; }

log_info "Snapshotting SHAKTI C-Class Bluespec/Verilog RTL @ $COMMIT_ID"
score_simple_snapshot_paths "$TOOL_DIR" "$DATASET_DIR" "$NAME" src Makefile sample_config README.md
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

bsv_count="$(find "$DATASET_DIR/rtl_snapshot/$NAME/src" -name '*.bsv' 2>/dev/null | wc -l)"

{
    echo "shakti SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Architecture: RV64IMAFD / RV32IMAFD 6-Stage In-Order Core (SHAKTI C-Class)"
    echo "Bluespec SystemVerilog source files: $bsv_count"
    echo "Generation Status: Ready for BSC (Bluespec Compiler) elaboration"
} > "$DATASET_DIR/shakti_summary.txt"

log_success "shakti generate done → $DATASET_DIR ($bsv_count BSV files)"
