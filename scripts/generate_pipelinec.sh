#!/usr/bin/env bash
#
# SCORE generate for JulianKemmerer/PipelineC — HLS C-to-HDL compiler with auto-pipelining.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/pipelinec"
NAME="pipelinec"
PROJECT="JulianKemmerer/PipelineC"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
# shellcheck source=scripts/common_simple_rtl.sh
source "$SCRIPT_DIR/common_simple_rtl.sh"
cd "$PROJECT_ROOT"

[[ -d "$TOOL_DIR/src" ]] || { log_error "Missing $TOOL_DIR/src — run scripts/add-optional-tools.sh pipelinec"; exit 1; }

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/$COMMIT_ID"
LOG_DIR="$DATASET_DIR/logs"
GEN_DIR="$DATASET_DIR/rtl_generated"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"

mkdir -p "$LOG_DIR" "$GEN_DIR"
init_script_logging_files generate_pipelinec "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

log_info "Generating HLS RTL designs using PipelineC @ $COMMIT_ID..."

PIPELINEC_BIN="$TOOL_DIR/src/pipelinec"

# Test 1: Blink LED
log_info "[1/2] Synthesizing Blink LED to HDL..."
mkdir -p "$GEN_DIR/blink"
python3 "$PIPELINEC_BIN" "$TOOL_DIR/examples/blink.c" --comb --no_synth --out_dir "$GEN_DIR/blink" > "$LOG_DIR/blink_gen.log" 2>&1 || true

# Test 2: FIR Filter
log_info "[2/2] Synthesizing FIR Filter to HDL..."
mkdir -p "$GEN_DIR/fir"
python3 "$PIPELINEC_BIN" "$TOOL_DIR/examples/fir.c" --comb --no_synth --out_dir "$GEN_DIR/fir" > "$LOG_DIR/fir_gen.log" 2>&1 || true

log_info "Snapshotting PipelineC compiler sources and examples..."
score_simple_snapshot_paths "$TOOL_DIR" "$DATASET_DIR" "$NAME" src examples include docs
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

gen_vhdl_count=$(find "$GEN_DIR" -name "*.vhd" -o -name "*.v" | wc -l)
snap_count="$(score_simple_count_rtl "$DATASET_DIR/rtl_snapshot/$NAME")"

{
    echo "PipelineC SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Generated HDL files: $gen_vhdl_count"
    echo "Snapshot files: $snap_count"
} > "$DATASET_DIR/pipelinec_summary.txt"

log_success "PipelineC generate complete → $DATASET_DIR ($gen_vhdl_count generated HDL files)"
