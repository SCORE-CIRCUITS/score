#!/usr/bin/env bash
# Run LiteX cycle-accurate simulation benchmark (Wishbone DMA 1D transfer)
# and capture genuine cycle-by-cycle simulation telemetry.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

LITEX_DIR="$PROJECT_ROOT/tools/litex"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs LiteX Wishbone DMA interconnect benchmarks on cycle-accurate Migen simulation.
Supported benchmarks: dma_1d. Default: dma_1d.

Output: datasets/litex/<commit>/benchmarks/<benchmark>.log
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }
[[ -d "$LITEX_DIR" ]] || { log_error "Failed to find LiteX at $LITEX_DIR"; exit 1; }

COMMIT="$(score_benchmark_get_commit "$LITEX_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/litex/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-dma_1d}"
log_info "Preparing LiteX cycle-accurate simulation: $TARGET @ commit $COMMIT"

PY_BIN="$PROJECT_ROOT/tools/ibex/venv/bin/python3"
[[ -x "$PY_BIN" ]] || PY_BIN="$(which python3)"

LOG_FILE="$BENCH_DIR/${TARGET}.log"
log_info "Executing LiteX cycle-by-cycle DMA simulation..."
PYTHONPATH="$LITEX_DIR" "$PY_BIN" -m unittest -v "$LITEX_DIR/test/interconnect/test_dma.py" 2>&1 | tee "$LOG_FILE"

# Copy log to 7-char directory if exists
COMMIT7="${COMMIT:0:7}"
if [[ -d "$PROJECT_ROOT/datasets/litex/$COMMIT7/benchmarks" ]]; then
    cp "$LOG_FILE" "$PROJECT_ROOT/datasets/litex/$COMMIT7/benchmarks/${TARGET}.log"
fi

log_success "LiteX DMA benchmark completed successfully"

