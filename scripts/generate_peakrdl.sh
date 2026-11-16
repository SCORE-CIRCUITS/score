#!/usr/bin/env bash
#
# SCORE generate for SystemRDL/PeakRDL — SystemRDL 2.0 to SystemVerilog Register Block Generator.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TOOL_DIR="$PROJECT_ROOT/tools/peakrdl"
NAME="peakrdl"
PROJECT="SystemRDL/PeakRDL"

# shellcheck source=scripts/common_logging.sh
source "$SCRIPT_DIR/common_logging.sh"
# shellcheck source=scripts/common_simple_rtl.sh
source "$SCRIPT_DIR/common_simple_rtl.sh"
cd "$PROJECT_ROOT"

[[ -d "$TOOL_DIR/examples" ]] || { log_error "Missing $TOOL_DIR/examples — run scripts/add-optional-tools.sh peakrdl"; exit 1; }

COMMIT_ID="$(score_simple_get_commit "$TOOL_DIR")"
DATASET_DIR="$PROJECT_ROOT/datasets/$NAME/$COMMIT_ID"
LOG_DIR="$DATASET_DIR/logs"
GEN_DIR="$DATASET_DIR/rtl_generated"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"

mkdir -p "$LOG_DIR" "$GEN_DIR"
init_script_logging_files generate_peakrdl "$LOG_DIR/main.log" "$LOG_DIR/session_${TIMESTAMP}.log"

log_info "Generating SystemVerilog register files from SystemRDL using PeakRDL @ $COMMIT_ID..."

# Copy generated SystemVerilog register block and UVM package
if [[ -d "$TOOL_DIR/examples/regblock" ]]; then
    cp -rp "$TOOL_DIR/examples/regblock/"* "$GEN_DIR/"
fi
if [[ -f "$TOOL_DIR/examples/atxmega_spi_uvm_pkg.sv" ]]; then
    cp -p "$TOOL_DIR/examples/atxmega_spi_uvm_pkg.sv" "$GEN_DIR/"
fi

log_info "Snapshotting PeakRDL sources and SystemRDL examples..."
score_simple_snapshot_paths "$TOOL_DIR" "$DATASET_DIR" "$NAME" examples docs peakrdl peakrdl-cli
score_simple_write_manifest "$DATASET_DIR" "$PROJECT" "$NAME" "$COMMIT_ID"

gen_sv_count=$(find "$GEN_DIR" -name "*.sv" -o -name "*.v" | wc -l)
snap_count="$(score_simple_count_rtl "$DATASET_DIR/rtl_snapshot/$NAME")"

{
    echo "PeakRDL SCORE snapshot ($PROJECT)"
    echo "Commit: $COMMIT_ID"
    echo "Dataset: $DATASET_DIR"
    echo "Generated SystemVerilog register files: $gen_sv_count"
    echo "Snapshot files: $snap_count"
} > "$DATASET_DIR/peakrdl_summary.txt"

log_success "PeakRDL generate complete → $DATASET_DIR ($gen_sv_count generated SV files)"
