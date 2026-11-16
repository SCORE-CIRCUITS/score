#!/usr/bin/env bash
# SCORE generate for ucb-bar/hwacha.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/hwacha"
NAME="hwacha"
PROJECT="ucb-bar/hwacha"

source "$SCRIPT_DIR/common_logging.sh"
source "$SCRIPT_DIR/common_simple_rtl.sh"

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/$COMMIT_ID"
LOG_DIR="$DATASET_DIR/logs"
VER_DIR="$DATASET_DIR/verification"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"

mkdir -p "$LOG_DIR" "$VER_DIR"
init_script_logging_files generate_hwacha "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

[[ -d "$TOOL_DIR/src" ]] || { log_error "Missing $TOOL_DIR/src — run install_hwacha.sh"; exit 1; }

log_info "Snapshotting $PROJECT @ $COMMIT_ID"
score_simple_snapshot_rtl "$TOOL_DIR" "$DATASET_DIR" "$NAME"
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

{
    echo "hwacha SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Paradigm: Decoupled Access-Execute (DAE)"
    echo "Chisel Sources: $(find "$TOOL_DIR/src" -name '*.scala' | wc -l)"
} > "$DATASET_DIR/hwacha_summary.txt"

log_success "hwacha generate done → $DATASET_DIR"
