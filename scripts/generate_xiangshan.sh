#!/usr/bin/env bash
# SCORE generate for OpenXiangShan/XiangShan — CAS/ICT XiangShan (NanHu/KunMingHu).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/xiangshan"
NAME="xiangshan"
PROJECT="OpenXiangShan/XiangShan"

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
init_script_logging_files generate_xiangshan "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

[[ -d "$TOOL_DIR/src/main/scala" ]] || { log_error "Missing $TOOL_DIR/src/main/scala — run install_xiangshan.sh"; exit 1; }

log_info "Snapshotting XiangShan Scala source + metadata @ $COMMIT_ID"
score_simple_snapshot_paths "$TOOL_DIR" "$DATASET_DIR" "$NAME" src Makefile build.mill README.md
# Exclude precompiled upstream binary if present in resources
rm -f "$DATASET_DIR/rtl_snapshot/$NAME/src/main/resources/espresso" 2>/dev/null || true
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

scala_count="$(find "$DATASET_DIR/rtl_snapshot/$NAME/src" -name '*.scala' 2>/dev/null | wc -l)"

{
    echo "xiangshan SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Architecture: RV64GCBK 6-Issue Out-of-Order Superscalar (NanHu / KunMingHu)"
    echo "Chisel/Scala source files: $scala_count"
    echo "Generation Status: Ready for Mill / Chisel elaboration"
} > "$DATASET_DIR/xiangshan_summary.txt"

log_success "xiangshan generate done → $DATASET_DIR ($scala_count Scala source files)"

