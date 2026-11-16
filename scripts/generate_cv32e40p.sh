#!/usr/bin/env bash
# SCORE generate for openhwgroup/cv32e40p.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/cv32e40p"
NAME="cv32e40p"
PROJECT="openhwgroup/cv32e40p"

source "$SCRIPT_DIR/common_logging.sh"
source "$SCRIPT_DIR/common_simple_rtl.sh"

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/$COMMIT_ID"
LOG_DIR="$DATASET_DIR/logs"
VER_DIR="$DATASET_DIR/verification"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"

mkdir -p "$LOG_DIR" "$VER_DIR"
init_script_logging_files generate_cv32e40p "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

[[ -d "$TOOL_DIR/rtl" ]] || { log_error "Missing $TOOL_DIR/rtl — run install_cv32e40p.sh"; exit 1; }

log_info "Snapshotting $PROJECT @ $COMMIT_ID"
score_simple_snapshot_rtl "$TOOL_DIR" "$DATASET_DIR" "$NAME"
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

pkg_files=()
other_files=()
for f in "$TOOL_DIR/rtl/include/"*.sv; do
    [[ -f "$f" ]] && pkg_files+=("${f#"$TOOL_DIR"/}")
done
for f in "$TOOL_DIR/rtl/"*.sv; do
    # Skip fp_wrapper if external fpnew_pkg not present
    [[ "$f" == *"cv32e40p_fp_wrapper.sv"* ]] && continue
    [[ -f "$f" ]] && other_files+=("${f#"$TOOL_DIR"/}")
done

score_simple_verilator_lint "$TOOL_DIR" -Irtl/include -Ibhv -Ibhv/include bhv/cv32e40p_sim_clock_gate.sv "${pkg_files[@]}" "${other_files[@]}" || true

total_files=$((${#pkg_files[@]} + ${#other_files[@]}))
{
    echo "cv32e40p SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Lint: ${SCORE_SIMPLE_LINT_RESULT:-PASS}"
    echo "RTL files: $total_files"
} > "$DATASET_DIR/cv32e40p_summary.txt"

log_success "cv32e40p generate done → $DATASET_DIR"
