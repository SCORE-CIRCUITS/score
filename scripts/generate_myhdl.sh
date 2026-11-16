#!/usr/bin/env bash
#
# SCORE generate for myhdl/myhdl — Python as a Hardware Description Language (toVerilog / toVHDL).
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/myhdl"
NAME="myhdl"
PROJECT="myhdl/myhdl"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
# shellcheck source=scripts/common_simple_rtl.sh
source "$SCRIPT_DIR/common_simple_rtl.sh"
cd "$PROJECT_ROOT"

[[ -d "$TOOL_DIR/myhdl" ]] || { log_error "Missing $TOOL_DIR/myhdl — run scripts/add-optional-tools.sh myhdl"; exit 1; }

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/$COMMIT_ID"
LOG_DIR="$DATASET_DIR/logs"
GEN_DIR="$DATASET_DIR/rtl_generated"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"

mkdir -p "$LOG_DIR" "$GEN_DIR"
init_script_logging_files generate_myhdl "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

log_info "Generating Verilog and VHDL using MyHDL @ $COMMIT_ID..."

(
    cd "$GEN_DIR"
    python3 -c "
import sys
sys.path.insert(0, '$TOOL_DIR')
import importlib.util
spec = importlib.util.spec_from_file_location('dff', '$TOOL_DIR/example/cookbook/dff/dff.py')
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
mod.convert()
"
) > "$LOG_DIR/convert.log" 2>&1 || true

log_info "Snapshotting MyHDL sources and examples..."
score_simple_snapshot_paths "$TOOL_DIR" "$DATASET_DIR" "$NAME" myhdl example doc
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

gen_rtl_count=$(find "$GEN_DIR" -name "*.v" -o -name "*.vhd" | wc -l)
snap_count="$(score_simple_count_rtl "$DATASET_DIR/rtl_snapshot/$NAME")"

{
    echo "MyHDL SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Generated Verilog/VHDL files: $gen_rtl_count"
    echo "Snapshot files: $snap_count"
} > "$DATASET_DIR/myhdl_summary.txt"

log_success "MyHDL generate complete → $DATASET_DIR ($gen_rtl_count generated RTL files)"
