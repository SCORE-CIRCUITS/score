#!/usr/bin/env bash
# SCORE generate for T-head-Semi/openc906 — Alibaba XuanTie C906 RV64GCV core.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/c906"
NAME="c906"
PROJECT="T-head-Semi/openc906"

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
init_script_logging_files generate_c906 "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

[[ -d "$TOOL_DIR/C906_RTL_FACTORY/gen_rtl" ]] || { log_error "Missing $TOOL_DIR/C906_RTL_FACTORY/gen_rtl — run install_c906.sh"; exit 1; }

export CODE_BASE_PATH="$TOOL_DIR/C906_RTL_FACTORY"
log_info "Compiling XuanTie C906 testbench with iverilog..."
CFG_OK=0
if ( cd "$TOOL_DIR/smart_run" && mkdir -p work && make compile SIM=iverilog ) >"$LOG_DIR/iverilog_compile.log" 2>&1; then
    CFG_OK=1
    log_success "C906 compiled successfully with iverilog → work/xuantie_core.vvp"
    if [[ -f "$TOOL_DIR/smart_run/work/xuantie_core.vvp" ]]; then
        cp -p "$TOOL_DIR/smart_run/work/xuantie_core.vvp" "$GEN_DIR/"
    fi
else
    log_warning "iverilog compilation failed — check $LOG_DIR/iverilog_compile.log"
fi

log_info "Snapshotting C906 RTL and testbench @ $COMMIT_ID"
score_simple_snapshot_paths "$TOOL_DIR" "$DATASET_DIR" "$NAME" C906_RTL_FACTORY smart_run
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

rtl_count="$(score_simple_count_rtl "$DATASET_DIR/rtl_snapshot/$NAME")"
if [[ "$CFG_OK" -eq 1 ]]; then cfg_status=OK; else cfg_status=FAIL; fi
{
    echo "c906 SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Simulation model: $cfg_status (SIM=iverilog)"
    echo "Design files: $rtl_count"
} > "$DATASET_DIR/c906_summary.txt"

log_success "c906 generate done → $DATASET_DIR"
