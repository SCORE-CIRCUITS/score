#!/usr/bin/env bash
# run_naxriscv_benchmarks.sh: Cycle-accurate Verilator simulation runner for NaxRiscv
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TOOL_DIR="$REPO_ROOT/tools/naxriscv"
TB_DIR="$TOOL_DIR/src/test/cpp/naxriscv"
SIM_BIN="$TB_DIR/obj_dir/VNaxRiscv"

if [[ ! -x "$SIM_BIN" ]]; then
    echo "Compiling NaxRiscv Verilator simulation model..."
    make -C "$TB_DIR" compile -j"$(nproc)"
fi

echo "=== Running NaxRiscv Dhrystone 2.2 Benchmark ==="
"$SIM_BIN" \
    --name dhrystone \
    --load-elf "$TOOL_DIR/ext/NaxSoftware/baremetal/dhrystone/build/rv32ima/dhrystone.elf" \
    --start-symbol _start \
    --pass-symbol pass \
    --fail-symbol fail \
    --stats-print \
    --timeout 5000000

echo "=== Running NaxRiscv CoreMark 1.0 Benchmark ==="
"$SIM_BIN" \
    --name coremark \
    --load-elf "$TOOL_DIR/ext/NaxSoftware/baremetal/coremark/build/rv32im/coremark.elf" \
    --start-symbol _start \
    --pass-symbol pass \
    --fail-symbol fail \
    --stats-print \
    --timeout 5000000

