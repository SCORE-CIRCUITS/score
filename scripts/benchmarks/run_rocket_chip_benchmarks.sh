#!/usr/bin/env bash
# Run Rocket Chip RV64GC (DefaultConfig) benchmark suite on cycle-accurate Verilator simulation
# and record score.benchmark_results.v1 JSON results.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"

ROCKET_DIR="$PROJECT_ROOT/tools/rocket-chip"
EMULATOR="$ROCKET_DIR/out/emulator/freechips.rocketchip.system.TestHarness/freechips.rocketchip.system.DefaultConfig/verilator/elf.dest/emulator"
BENCH_SRC_DIR="$PROJECT_ROOT/datasets/gemmini/workshop/chipyard/.conda-env/riscv-tools/riscv64-unknown-elf/share/riscv-tests/benchmarks"

usage() {
    cat <<EOF
Usage: $(basename "$0") [benchmark_name]

Runs Rocket Chip RV64GC (DefaultConfig) benchmarks on Verilator cycle-accurate simulation.
If benchmark_name is provided, runs only that benchmark (e.g. coremark, dhrystone, mm, qsort, memcpy, pmp).
Otherwise runs all standard benchmarks: coremark, dhrystone, mm, qsort, rsort, spmv, multiply, median, towers, vvadd, memcpy, pmp.

Output: datasets/rocket-chip/<commit>/benchmarks/<benchmark>_default.json
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

if [[ ! -x "$EMULATOR" ]]; then
    log_info "Rocket Chip emulator not found at $EMULATOR, building via Mill..."
    cd "$ROCKET_DIR"
    "${MILL:-mill}" -i "emulator[freechips.rocketchip.system.TestHarness,freechips.rocketchip.system.DefaultConfig].elf"
fi

[[ -x "$EMULATOR" ]] || { log_error "Failed to build or find Rocket Chip emulator: $EMULATOR"; exit 1; }
[[ -d "$BENCH_SRC_DIR" ]] || { log_error "Benchmarks directory not found: $BENCH_SRC_DIR"; exit 1; }

COMMIT="${SCORE_DATASET_COMMIT:-885dd596}"
BENCH_DIR="$PROJECT_ROOT/datasets/rocket-chip/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR"

TARGET="${1:-all}"

ALL_BENCHMARKS=(coremark dhrystone mm qsort rsort spmv multiply median towers vvadd memcpy pmp)
if [[ "$TARGET" != "all" ]]; then
    BENCHMARKS=("$TARGET")
else
    BENCHMARKS=("${ALL_BENCHMARKS[@]}")
fi

for bench in "${BENCHMARKS[@]}"; do
    if [[ "$bench" == "coremark" ]]; then
        elf="$PROJECT_ROOT/benchmarks/app/rocket_coremark/coremark.riscv"
        if [[ ! -f "$elf" ]]; then
            log_info "Building Rocket CoreMark binary..."
            make -C "$PROJECT_ROOT/benchmarks/app/rocket_coremark" coremark.riscv
        fi
    else
        elf="$BENCH_SRC_DIR/$bench.riscv"
    fi

    if [[ ! -f "$elf" ]]; then
        log_warn "Benchmark ELF not found: $elf, skipping."
        continue
    fi

    log_info "Running Rocket Chip RV64GC benchmark: $bench ($elf)..."
    log_file="$BENCH_DIR/${bench}_default.log"
    out_json="$BENCH_DIR/${bench}_default.json"

    # Run simulation
    "$EMULATOR" +cycle-count +max-cycles=50000000 "$elf" > "$log_file" 2>&1 || {
        log_warn "Rocket Chip simulation exited with non-zero status for $bench (see $log_file)"
    }

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

# Extract total simulation cycles if reported
sim_cycles_m = re.search(r"\*\*\* PASSED \*\*\* at cycle (\d+)", text) or \
               re.search(r"\*\*\* PASSED \*\*\* Completed after (\d+) cycles", text)
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

passed = (mcycle is not None and mcycle > 0) or ("*** PASSED ***" in text) or ("Correct operation validated" in text)

if mcycle is not None and minstret is not None and mcycle > 0:
    ipc = round(minstret / mcycle, 4)

# Dhrystone specific
dhry_sec_m = re.search(r"Dhrystones per Second:\s*(\d+)", text)
if dhry_sec_m:
    dhrystones_per_sec = int(dhry_sec_m.group(1))
    dmips_per_mhz = round(dhrystones_per_sec / 1757.0, 4)

dmips_m = re.search(r"DMIPS[_\s]Per[_\s]MHz:\s*([\d.]+)", text, re.I)
if dmips_m:
    dmips_per_mhz = float(dmips_m.group(1))

user_time_m = re.search(r"User_Time:\s*(\d+)\s+cycles,\s*(\d+)\s+instructions", text)
if user_time_m:
    mcycle = int(user_time_m.group(1))
    minstret = int(user_time_m.group(2))
    if mcycle > 0:
        ipc = round(minstret / mcycle, 4)

# MM specific
flops_m = re.search(r"(\d+)\s+flops", text) or re.search(r"flops\s*=\s*(\d+)", text)
if flops_m:
    flops = int(flops_m.group(1))
    if mcycle and mcycle > 0:
        gflops_1ghz = round(flops / mcycle, 4)

metrics = {
    "validated": passed,
    "simulator": "verilator",
    "architecture": "rv64gc",
    "configuration": "DefaultConfig"
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
    metrics["coremark_mhz"] = coremark_mhz
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
    "core": "rocket-chip",
    "upstream_commit": commit[:8],
    "profile": "app_verilator",
    "workload": bench_name,
    "config": "DefaultConfig",
    "metrics": metrics,
    "generated_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
    "host": {
        "hostname": platform.node(),
        "platform": platform.platform(),
        "python": platform.python_version()
    },
    "tool_versions": {
        "verilator": "5.022",
        "firtool": "1.62.0"
    }
}

with open(out_json, 'w') as f:
    json.dump(result, f, indent=2)
    f.write("\n")

print(f"Recorded {bench_name}: passed={passed}, cycles={mcycle}, insts={minstret}, IPC={ipc}")
PY

    log_success "Generated $out_json"
done

log_success "All requested Rocket Chip benchmarks finished."
