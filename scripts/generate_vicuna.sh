#!/usr/bin/env bash
# SCORE generate for vproc/vicuna.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/vicuna"
NAME="vicuna"
PROJECT="vproc/vicuna"

source "$SCRIPT_DIR/common_logging.sh"
source "$SCRIPT_DIR/common_simple_rtl.sh"

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/$COMMIT_ID"
LOG_DIR="$DATASET_DIR/logs"
VER_DIR="$DATASET_DIR/verification"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"

mkdir -p "$LOG_DIR" "$VER_DIR"
init_script_logging_files generate_vicuna "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

[[ -d "$TOOL_DIR/rtl" ]] || { log_error "Missing $TOOL_DIR/rtl — run install_vicuna.sh"; exit 1; }

log_info "Snapshotting $PROJECT @ $COMMIT_ID"
score_simple_snapshot_rtl "$TOOL_DIR" "$DATASET_DIR" "$NAME"
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

pkg_files=()
other_files=()
[[ -f "$TOOL_DIR/rtl/vproc_pkg.sv" ]] && pkg_files+=("rtl/vproc_pkg.sv")
for f in "$TOOL_DIR/rtl/"*.sv; do
    [[ "$f" == *"vproc_pkg.sv"* ]] && continue
    [[ -f "$f" ]] && other_files+=("${f#"$TOOL_DIR"/}")
done

score_simple_verilator_lint "$TOOL_DIR" "${pkg_files[@]}" "${other_files[@]}" || true

total_files=$((${#pkg_files[@]} + ${#other_files[@]}))
{
    echo "vicuna SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Lint: ${SCORE_SIMPLE_LINT_RESULT:-PASS}"
    echo "RTL files: $total_files"
} > "$DATASET_DIR/vicuna_summary.txt"

log_success "vicuna generate done → $DATASET_DIR"
