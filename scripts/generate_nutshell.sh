#!/usr/bin/env bash
# SCORE generate for OSCPU/NutShell — UCAS NutShell RV64IMAC core.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/nutshell"
NAME="nutshell"
PROJECT="OSCPU/NutShell"

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
init_script_logging_files generate_nutshell "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

[[ -d "$TOOL_DIR/src/main/scala" ]] || { log_error "Missing $TOOL_DIR/src/main/scala — run install_nutshell.sh"; exit 1; }

export NOOP_HOME="$TOOL_DIR"
log_info "Generating NutShell SystemVerilog RTL via Mill Chisel..."
CFG_OK=0
if ( cd "$TOOL_DIR" && make verilog ) >"$LOG_DIR/chisel_verilog.log" 2>&1; then
    CFG_OK=1
    log_success "NutShell Verilog generated successfully → build/rtl"
    if [[ -d "$TOOL_DIR/build/rtl" ]]; then
        mkdir -p "$GEN_DIR/rtl"
        cp -p "$TOOL_DIR/build/rtl/"*.sv "$GEN_DIR/rtl/" 2>/dev/null || true
    fi
else
    log_warning "NutShell Verilog generation failed — check $LOG_DIR/chisel_verilog.log"
fi

log_info "Snapshotting NutShell Scala source + generated RTL @ $COMMIT_ID"
score_simple_snapshot_paths "$TOOL_DIR" "$DATASET_DIR" "$NAME" src build.mill
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

rtl_count=0
if [[ -d "$GEN_DIR/rtl" ]]; then
    rtl_count="$(ls "$GEN_DIR/rtl"/*.sv 2>/dev/null | wc -l)"
fi

if [[ "$CFG_OK" -eq 1 ]]; then cfg_status=OK; else cfg_status=FAIL; fi
{
    echo "nutshell SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "RTL Generation: $cfg_status (Mill 0.12 Chisel 7.11)"
    echo "Generated SystemVerilog files: $rtl_count"
} > "$DATASET_DIR/nutshell_summary.txt"

log_success "nutshell generate done → $DATASET_DIR"
