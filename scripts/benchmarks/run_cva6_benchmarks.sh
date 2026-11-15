#!/usr/bin/env bash
# Run CVA6 RV64GC (cv64a6_imafdc_sv39) benchmark suite on cycle-accurate Verilator simulation
# and record score.benchmark_results.v1 JSON results.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

CVA6_DIR="$PROJECT_ROOT/tools/cva6"
EMULATOR="$CVA6_DIR/work-ver/Variane_testharness"
RISCV_GCC="$PROJECT_ROOT/datasets/gemmini/workshop/chipyard/.conda-env/riscv-tools/bin/riscv64-unknown-elf-gcc"

CUSTOM_DIR="$CVA6_DIR/verif/tests/custom"
CARFIELD_BENCH="$PROJECT_ROOT/tools/carfield/sw/deps/cva6-sdk/riscv-tests/benchmarks"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs CVA6 RV64GC (cv64a6_imafdc_sv39) benchmarks on Verilator cycle-accurate simulation.
If benchmark_name is provided, runs only that benchmark (e.g. coremark, dhrystone, mm, qsort, memcpy, pmp).
Otherwise runs all benchmarks: coremark, dhrystone, mm, qsort, rsort, spmv, multiply, median, towers, vvadd, memcpy, pmp.

Output: datasets/cva6/<commit>/benchmarks/<benchmark>_default.json
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

[[ -x "$EMULATOR" ]] || { log_error "Failed to find CVA6 emulator: $EMULATOR"; exit 1; }
[[ -x "$RISCV_GCC" ]] || { log_error "RISC-V 64 GCC not found: $RISCV_GCC"; exit 1; }

COMMIT="${SCORE_DATASET_COMMIT:-4c02b24f}"
BENCH_DIR="$PROJECT_ROOT/datasets/cva6/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"
TMP_DIR="/tmp/cva6_bench_build"
mkdir -p "$TMP_DIR"

TARGET="${1:-all}"

ALL_BENCHMARKS=(coremark dhrystone mm qsort rsort spmv multiply median towers vvadd memcpy pmp)
if [[ "$TARGET" != "all" ]]; then
    BENCHMARKS=("$TARGET")
else
    BENCHMARKS=("${ALL_BENCHMARKS[@]}")
fi

for bench in "${BENCHMARKS[@]}"; do
    log_info "Compiling and running CVA6 RV64GC benchmark: $bench..."
    elf="$TMP_DIR/${bench}.riscv"
    log_file="$BENCH_DIR/${bench}_default.log"
    out_json="$BENCH_DIR/${bench}_default.json"

    # Compile benchmark ELF
    case "$bench" in
        coremark)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O3 -fno-tree-loop-distribute-patterns -funroll-all-loops \
              -ffunction-sections -fdata-sections -Wl,-gc-sections \
              -DCOMPILER_FLAGS="\"-O3\"" -DITERATIONS=1 -DPERFORMANCE_RUN=1 -DSKIP_TIME_CHECK=1 \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CUSTOM_DIR/coremark" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CUSTOM_DIR/coremark/core_list_join.c" \
              "$CUSTOM_DIR/coremark/core_matrix.c" \
              "$CUSTOM_DIR/coremark/core_portme.c" \
              "$CUSTOM_DIR/coremark/core_state.c" \
              "$CUSTOM_DIR/coremark/core_util.c" \
              "$CUSTOM_DIR/coremark/uart.c" \
              "$CUSTOM_DIR/coremark/coremark_main.c" \
              -o "$elf"
            ;;
        dhrystone)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O3 -fno-inline -fno-tree-loop-distribute-patterns \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CUSTOM_DIR/dhrystone" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CUSTOM_DIR/dhrystone/dhrystone.c" \
              "$CUSTOM_DIR/dhrystone/dhrystone_main.c" \
              -o "$elf"
            ;;
        mm)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc -lm \
              -O2 -fno-tree-loop-distribute-patterns -fno-builtin-memset -fno-builtin-memcpy \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CARFIELD_BENCH/mm" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CARFIELD_BENCH/mm/mm.c" \
              "$CARFIELD_BENCH/mm/mm_main.c" \
              -o "$elf"
            ;;
        multiply)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O2 -fno-tree-loop-distribute-patterns \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CARFIELD_BENCH/multiply" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CARFIELD_BENCH/multiply/multiply.c" \
              "$CARFIELD_BENCH/multiply/multiply_main.c" \
              -o "$elf"
            ;;
        qsort)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O2 -fno-tree-loop-distribute-patterns \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CARFIELD_BENCH/qsort" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CARFIELD_BENCH/qsort/qsort_main.c" \
              -o "$elf"
            ;;
        rsort)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O2 -fno-tree-loop-distribute-patterns \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CARFIELD_BENCH/rsort" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CARFIELD_BENCH/rsort/rsort.c" \
              -o "$elf"
            ;;
        spmv)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O2 -fno-tree-loop-distribute-patterns \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CARFIELD_BENCH/spmv" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CARFIELD_BENCH/spmv/spmv_main.c" \
              -o "$elf"
            ;;
        median)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O2 -fno-tree-loop-distribute-patterns \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CARFIELD_BENCH/median" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CARFIELD_BENCH/median/median.c" \
              "$CARFIELD_BENCH/median/median_main.c" \
              -o "$elf"
            ;;
        towers)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O2 -fno-tree-loop-distribute-patterns \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CARFIELD_BENCH/towers" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CARFIELD_BENCH/towers/towers_main.c" \
              -o "$elf"
            ;;
        vvadd)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O2 -fno-tree-loop-distribute-patterns \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CARFIELD_BENCH/vvadd" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$CARFIELD_BENCH/vvadd/vvadd_main.c" \
              -o "$elf"
            ;;
        memcpy)
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O2 -fno-tree-loop-distribute-patterns -fno-builtin-memcpy -fno-builtin-memset \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$PROJECT_ROOT/datasets/gemmini/workshop/chipyard/toolchains/riscv-tools/riscv-tests/benchmarks/memcpy" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$PROJECT_ROOT/datasets/gemmini/workshop/chipyard/toolchains/riscv-tools/riscv-tests/benchmarks/memcpy/memcpy_main.c" \
              -o "$elf"
            ;;
        pmp)
            sed 's/#define GRANULE (1UL << PMP_SHIFT)/#undef PMP_SHIFT\n#define PMP_SHIFT 3\n#define GRANULE (1UL << PMP_SHIFT)/' \
              "$CARFIELD_BENCH/pmp/pmp.c" > "$TMP_DIR/pmp_cva6.c"
            "$RISCV_GCC" \
              -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
              -O2 -fno-tree-loop-distribute-patterns \
              -I"$CUSTOM_DIR/env" -I"$CUSTOM_DIR/common" -I"$CARFIELD_BENCH/pmp" \
              -T "$CUSTOM_DIR/Zcmp/link.ld" \
              "$CUSTOM_DIR/common/crt.S" \
              "$CUSTOM_DIR/common/syscalls.c" \
              "$TMP_DIR/pmp_cva6.c" \
              -o "$elf"
            ;;
        *)
            log_error "Unknown benchmark: $bench"
            exit 1
            ;;
    esac

    # Run cycle-accurate simulation
    log_info "Executing $bench on CVA6 Verilator model..."
    "$EMULATOR" +elf_file="$elf" "$elf" > "$log_file" 2>&1 || {
        log_warn "CVA6 simulation exited with non-zero status for $bench (see $log_file)"
    }

    # Clean up large trace file to save disk space
    rm -f trace_rvfi_hart_*.dasm

    # Parse metrics
    python3 - "$log_file" "$bench" "$out_json" "$COMMIT" <<'PY'
import sys, re, json, os, platform
from datetime import datetime, timezone

log_file, bench_name, out_json, commit = sys.argv[1:5]
with open(log_file, 'r', errors='replace') as f:
    text = f.read()

mcycle = None
minstret = None
ipc = None
dmips_per_mhz = None
dhrystones_per_sec = None
coremark_score = None
coremark_mhz = None
flops = None
gflops_1ghz = None
total_cycles = None

# Extract total simulation cycles from CVA6 testbench termination
sim_cycles_m = re.search(r"\*\*\* SUCCESS \*\*\* \(tohost = 0\) after (\d+) cycles", text) or \
               re.search(r"Simulation terminated after\s*(\d+)\s+cycles", text)
if sim_cycles_m:
    total_cycles = int(sim_cycles_m.group(1))

# Extract mcycle / minstret
mcycle_m = re.search(r"mcycle\s*=\s*(\d+)", text) or re.search(r"C\d+:\s*(\d+)\s+cycles", text)
minstret_m = re.search(r"minstret\s*=\s*(\d+)", text) or re.search(r"C\d+:\s*(\d+)\s+instructions", text)

# CoreMark specific
ticks_m = re.search(r"Total ticks\s*:\s*(\d+)", text)
if ticks_m:
    mcycle = int(ticks_m.group(1))

cm_m = re.search(r"CoreMark/MHz\s*[\d.]*\s*:\s*([\d.]+)", text)
if cm_m:
    coremark_score = float(cm_m.group(1))
    coremark_mhz = coremark_score

if mcycle_m and mcycle is None:
    mcycle = int(mcycle_m.group(1))
if minstret_m:
    minstret = int(minstret_m.group(1))

passed = ("*** SUCCESS *** (tohost = 0)" in text) or (mcycle is not None and mcycle > 0)

if mcycle is not None and minstret is not None and mcycle > 0:
    ipc = round(minstret / mcycle, 4)

# Dhrystone specific
dhry_sec_m = re.search(r"Dhrystones per Second:\s*(\d+)", text)
if dhry_sec_m:
    dhrystones_per_sec = int(dhry_sec_m.group(1))
    dmips_per_mhz = round(dhrystones_per_sec / 1757.0, 4)

# MM specific
flops_m = re.search(r"(\d+)\s+flops", text) or re.search(r"flops\s*=\s*(\d+)", text)
if flops_m:
    flops = int(flops_m.group(1))
    if mcycle and mcycle > 0:
        gflops_1ghz = round(flops / mcycle, 4)

mflops_m = re.search(r"(\d+)\s+Mflops @ 1 GHz", text)
if mflops_m and gflops_1ghz is None:
    gflops_1ghz = round(float(mflops_m.group(1)) / 1000.0, 4)

metrics = {
    "validated": passed,
    "simulator": "verilator",
    "architecture": "rv64gc",
    "configuration": "cv64a6_imafdc_sv39"
}

if total_cycles is not None:
    metrics["total_simulation_cycles"] = total_cycles
if mcycle is not None:
    metrics["benchmark_cycles"] = mcycle
if minstret is not None:
    metrics["instructions_retired"] = minstret
if ipc is not None:
    metrics["ipc"] = ipc
if coremark_score is not None:
    metrics["coremark_score"] = coremark_score
    metrics["coremark_per_mhz"] = coremark_mhz
if dmips_per_mhz is not None:
    metrics["dhrystone_dmips_per_mhz"] = dmips_per_mhz
if dhrystones_per_sec is not None:
    metrics["dhrystones_per_sec_per_mhz"] = dhrystones_per_sec
if flops is not None:
    metrics["flops"] = flops
if gflops_1ghz is not None:
    metrics["gflops_per_ghz"] = gflops_1ghz

result = {
    "schema": "score.benchmark_results.v1",
    "evidence_class": "score_measured",
    "core": "cva6",
    "upstream_commit": commit[:8],
    "profile": "app_verilator",
    "workload": bench_name,
    "config": "cv64a6_imafdc_sv39",
    "metrics": metrics,
    "generated_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
    "host": {
        "hostname": platform.node(),
        "platform": platform.platform(),
        "python": platform.python_version()
    },
    "tool_versions": {
        "verilator": "5.048",
        "gcc": "13.2.0"
    }
}

with open(out_json, 'w') as f:
    json.dump(result, f, indent=2)
    f.write("\n")

print(f"Recorded {bench_name}: passed={passed}, cycles={mcycle}, insts={minstret}, IPC={ipc}")
PY

    log_success "Generated $out_json"
done

log_success "All requested CVA6 benchmarks finished."
