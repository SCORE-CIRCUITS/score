#!/usr/bin/env bash
#
# SCORE generate for google/xls — Accelerated Development of Hardware Designs (HLS & DSLX).
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/xls"
NAME="xls"
PROJECT="google/xls"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
# shellcheck source=scripts/common_simple_rtl.sh
source "$SCRIPT_DIR/common_simple_rtl.sh"
cd "$PROJECT_ROOT"

[[ -d "$TOOL_DIR/xls" ]] || { log_error "Missing $TOOL_DIR/xls — run scripts/add-optional-tools.sh xls"; exit 1; }

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/$COMMIT_ID"
LOG_DIR="$DATASET_DIR/logs"
GEN_DIR="$DATASET_DIR/rtl_generated"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"

mkdir -p "$LOG_DIR" "$GEN_DIR"
init_script_logging_files generate_xls "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

log_info "Snapshotting Google XLS HLS framework and DSLX examples @ $COMMIT_ID..."
score_simple_snapshot_paths "$TOOL_DIR" "$DATASET_DIR" "$NAME" xls docs_src MODULE.bazel README.md
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

snap_count="$(score_simple_count_rtl "$DATASET_DIR/rtl_snapshot/$NAME")"

{
    echo "Google XLS SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Snapshot files: $snap_count"
} > "$DATASET_DIR/xls_summary.txt"

log_success "Google XLS generate complete → $DATASET_DIR"
