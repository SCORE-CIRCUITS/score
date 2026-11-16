#!/usr/bin/env bash
# SCORE generate for BrunoLevy/learn-fpga (FemtoRV32).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/femtorv"
NAME="femtorv"
PROJECT="BrunoLevy/learn-fpga"

source "$SCRIPT_DIR/common_logging.sh"
source "$SCRIPT_DIR/common_simple_rtl.sh"
cd "$PROJECT_ROOT"

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/$COMMIT_ID"
LOG_DIR="$DATASET_DIR/logs"
VER_DIR="$DATASET_DIR/verification"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
mkdir -p "$LOG_DIR" "$VER_DIR"
init_script_logging_files generate_femtorv "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

[[ -d "$TOOL_DIR/FemtoRV/RTL" ]] || { log_error "Missing $TOOL_DIR/FemtoRV/RTL — run install_femtorv.sh"; exit 1; }

log_info "Snapshotting FemtoRV RTL @ $COMMIT_ID"
score_simple_snapshot_paths "$TOOL_DIR/FemtoRV" "$DATASET_DIR" "$NAME" RTL
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

log_info "Running Verilator lint on femtoRV32_bench"
SCORE_SIMPLE_LINT_RESULT="PASS"
verilator -DBENCH_VERILATOR --top-module femtoRV32_bench --lint-only \
    -I"$TOOL_DIR/FemtoRV/RTL" \
    -I"$TOOL_DIR/FemtoRV/RTL/PROCESSOR" \
    -I"$TOOL_DIR/FemtoRV/RTL/DEVICES" \
    -I"$TOOL_DIR/FemtoRV/RTL/PLL" \
    "$TOOL_DIR/FemtoRV/RTL/femtosoc_bench.v" > "$VER_DIR/verilator_lint_rtl.log" 2>&1 || SCORE_SIMPLE_LINT_RESULT="FAIL"

rtl_count="$(score_simple_count_rtl "$DATASET_DIR/rtl_snapshot/$NAME")"
{
    echo "femtorv SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Lint: $SCORE_SIMPLE_LINT_RESULT"
    echo "RTL files: $rtl_count"
} > "$DATASET_DIR/femtorv_summary.txt"

log_success "femtorv generate done → $DATASET_DIR"
