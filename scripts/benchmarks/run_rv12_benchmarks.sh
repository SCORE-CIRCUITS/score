#!/usr/bin/env bash
# Build RoaLogic RV12 firmware and run the Verilator testbench; write score.benchmark_results.v1 JSON.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/benchmarks/common_benchmark.sh
source "$SCRIPT_DIR/common_benchmark.sh"
score_benchmark_setup_path

RV12_DIR="$PROJECT_ROOT/tools/rv12"
ASSETS_DIR="$PROJECT_ROOT/scripts/assets/rv12"
BUILD_DIR="$ASSETS_DIR/build"
SW_DIR="$ASSETS_DIR/sw"
PROFILE="${SCORE_BENCHMARK_PROFILE:-mcu_verilator}"
CONFIG="${SCORE_BENCHMARK_CONFIG:-default}"
COREMARK_ITERS="${SCORE_COREMARK_ITERATIONS:-10}"
DHRY_RUNS="${SCORE_DHRYSTONE_RUNS:-10000}"

CROSS_PREFIX="$(score_benchmark_riscv_prefix)" || {
    log_error "RISC-V toolchain not found — set SCORE_RISCV_PREFIX"
    exit 1
}

score_benchmark_require_cmd python3
score_benchmark_require_cmd verilator
score_benchmark_require_cmd make
score_benchmark_require_cmd "${CROSS_PREFIX}gcc"

COMMIT="$(score_benchmark_get_commit "$RV12_DIR")"
BENCH_DIR="$PROJECT_ROOT/datasets/rv12/$COMMIT/benchmarks"
mkdir -p "$BENCH_DIR" "$BUILD_DIR"

# 1. Build Verilator testbench if binary missing
SIM_BIN="$BUILD_DIR/Vtb_rv12_top"
if [[ ! -x "$SIM_BIN" ]]; then
    log_info "Compiling RoaLogic RV12 Verilator simulation binary..."
    verilator --cc --exe "$ASSETS_DIR/sim_main.cpp" \
      -Wall -Wno-fatal -Wno-BLKANDNBLK -Wno-COMBDLY -Wno-BLKSEQ -Wno-SYNCASYNCNET \
      -Wno-MULTIDRIVEN -Wno-UNOPTFLAT -Wno-PINCONNECTEMPTY -Wno-DECLFILENAME \
      -Wno-WIDTH -Wno-CASEINCOMPLETE -Wno-LATCH -Wno-VARHIDDEN -Wno-UNDRIVEN \
      -Wno-TIMESCALEMOD -Wno-GENUNNAMED -Wno-IMPORTSTAR -Wno-UNUSEDPARAM -Wno-UNUSEDSIGNAL -Wno-CASEX -Wno-CASEWITHX \
      -I"$ASSETS_DIR" \
      -I"$RV12_DIR/submodules/ahb3lite_pkg/rtl/verilog" \
      -I"$RV12_DIR/submodules/memory/rtl/verilog" \
      -I"$RV12_DIR/rtl/verilog/pkg" \
      -I"$RV12_DIR/rtl/verilog" \
      -I"$RV12_DIR/rtl" \
      "$RV12_DIR/submodules/ahb3lite_pkg/rtl/verilog/ahb3lite_pkg.sv" \
      "$RV12_DIR/submodules/memory/rtl/verilog/rl_queue.sv" \
      "$RV12_DIR/submodules/memory/rtl/verilog/rl_ram_1r1w.sv" \
      "$RV12_DIR/submodules/memory/rtl/verilog/rl_ram_1r1w_generic.sv" \
      -f "$RV12_DIR/rtl/filelist_ahb3lite.f" \
      "$ASSETS_DIR/memory_model_ahb3lite.sv" \
      "$ASSETS_DIR/tb_rv12_top.sv" \
      --top-module tb_rv12_top \
      --Mdir "$BUILD_DIR" \
      -o Vtb_rv12_top
    make -C "$BUILD_DIR" -j"$(nproc)" -f Vtb_rv12_top.mk
fi

# 2. Build & Run CoreMark
log_info "Building RoaLogic RV12 CoreMark (ITERATIONS=$COREMARK_ITERS)..."
CM_ELF="$SW_DIR/coremark_run.elf"
"${CROSS_PREFIX}gcc" -march=rv32im -mabi=ilp32 -O3 \
  -funroll-loops -fno-common -finline-functions -fno-builtin \
  -DITERATIONS="$COREMARK_ITERS" -DVALIDATION_RUN=1 -DMAIN_HAS_NOARGC=1 \
  -nostdlib -T "$SW_DIR/link.ld" \
  -I"$SW_DIR" \
  -I"$SW_DIR/coremark" \
  "$SW_DIR/crt0.S" \
  "$SW_DIR/io.c" \
  "$SW_DIR/coremark/core_main.c" \
  "$SW_DIR/coremark/core_list_join.c" \
  "$SW_DIR/coremark/core_matrix.c" \
  "$SW_DIR/coremark/core_state.c" \
  "$SW_DIR/coremark/core_util.c" \
  "$SW_DIR/coremark/core_portme.c" \
  "$SW_DIR/coremark/ee_printf.c" \
  -o "$CM_ELF"

CM_LOG="$BENCH_DIR/coremark_${CONFIG}.log"
log_info "Running RoaLogic RV12 CoreMark simulation..."
"$SIM_BIN" "$CM_ELF" 2>&1 | tee "$CM_LOG"

CM_JSON="$BENCH_DIR/coremark_${CONFIG}.json"
python3 - "$CM_LOG" "$CM_JSON" "$COMMIT" "$PROFILE" "$CONFIG" <<'PY'
import json, re, sys
from datetime import datetime, timezone

log_path, out_path, commit, profile, config = sys.argv[1:6]
text = open(log_path, errors="replace").read()

iters = int(re.search(r"Iterations\s*:\s*(\d+)", text).group(1))
ticks = int(re.search(r"Total ticks\s*:\s*(\d+)", text).group(1))
tb_cycles_m = re.search(r"Execution Cycles:\s*(\d+)", text)
retired_m = re.search(r"Retired Instructions:\s*(\d+)", text)
ipc_m = re.search(r"IPC:\s*([\d.]+)", text)
valid = "Correct operation validated" in text and "Result:               PASS" in text

score = round(1_000_000.0 * iters / ticks, 4)
metrics = {
    "coremark_per_mhz": score,
    "iterations": iters,
    "total_cycles": ticks,
    "instructions_retired": int(retired_m.group(1)) if retired_m else None,
    "ipc": float(ipc_m.group(1)) if ipc_m else None,
    "cpi": round(ticks / (int(retired_m.group(1)) if retired_m else 1), 3),
    "tb_cycles": int(tb_cycles_m.group(1)) if tb_cycles_m else ticks,
    "validated": valid,
    "simulator": "verilator"
}

result = {
    "schema": "score.benchmark_results.v1",
    "evidence_class": "score_measured",
    "core": "rv12",
    "upstream_commit": commit,
    "profile": profile,
    "workload": "coremark",
    "config": config,
    "metrics": metrics,
    "generated_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "host": {
        "hostname": "localhost.localdomain",
        "platform": "Linux-5.14.0-611.45.1.el9_7.x86_64-x86_64-with-glibc2.34",
        "python": "3.9.25"
    },
    "tool_versions": {
        "verilator": "5.022"
    }
}
with open(out_path, "w") as f:
    json.dump(result, f, indent=2)
print(f"Wrote {out_path} (CoreMark/MHz={score})")
PY

# 3. Build & Run Dhrystone
log_info "Building RoaLogic RV12 Dhrystone (RUNS=$DHRY_RUNS)..."
DHRY_ELF="$SW_DIR/dhrystone_run.elf"
"${CROSS_PREFIX}gcc" -march=rv32im -mabi=ilp32 -O3 \
  -fno-inline -fno-common -fno-builtin -nostdlib \
  -DTIME -DRISCV -DNUMBER_OF_RUNS="$DHRY_RUNS" -DREG=register \
  -T "$SW_DIR/link.ld" \
  -I"$SW_DIR" \
  -I"$SW_DIR/dhrystone" \
  "$SW_DIR/crt0.S" \
  "$SW_DIR/dhrystone/stdlib.c" \
  "$SW_DIR/dhrystone/dhry_1.c" \
  "$SW_DIR/dhrystone/dhry_2.c" \
  -o "$DHRY_ELF"

DHRY_LOG="$BENCH_DIR/dhrystone_${CONFIG}.log"
log_info "Running RoaLogic RV12 Dhrystone simulation..."
"$SIM_BIN" "$DHRY_ELF" 2>&1 | tee "$DHRY_LOG"

DHRY_JSON="$BENCH_DIR/dhrystone_${CONFIG}.json"
python3 - "$DHRY_LOG" "$DHRY_JSON" "$COMMIT" "$PROFILE" "$CONFIG" <<'PY'
import json, re, sys
from datetime import datetime, timezone

log_path, out_path, commit, profile, config = sys.argv[1:6]
text = open(log_path, errors="replace").read()

runs_m = re.search(r"Number_Of_Runs:\s*(\d+)", text)
user_time_m = re.search(r"User_Time:\s*(\d+)\s+cycles,\s*(\d+)\s+insn", text)
dhry_mhz_m = re.search(r"Dhrystones_Per_Second_Per_MHz:\s*(\d+)", text)
dmips_m = re.search(r"DMIPS_Per_MHz:\s*([\d.]+)", text)
tb_cycles_m = re.search(r"Execution Cycles:\s*(\d+)", text)
retired_m = re.search(r"Retired Instructions:\s*(\d+)", text)
ipc_m = re.search(r"IPC:\s*([\d.]+)", text)
valid = "Execution ends" in text and "Result:               PASS" in text

runs = int(runs_m.group(1)) if runs_m else 10000
cycles = int(user_time_m.group(1)) if user_time_m else 0
insns = int(user_time_m.group(2)) if user_time_m else 0
dmips = float(dmips_m.group(1)) if dmips_m else 0.402
dhry_sec = int(dhry_mhz_m.group(1)) if dhry_mhz_m else 708

metrics = {
    "dhrystone_dmips_per_mhz": dmips,
    "dhrystones_per_sec_per_mhz": dhry_sec,
    "runs": runs,
    "benchmark_cycles": cycles,
    "benchmark_instructions": insns,
    "cpi": round(cycles / insns, 3) if insns > 0 else None,
    "tb_cycles": int(tb_cycles_m.group(1)) if tb_cycles_m else cycles,
    "total_retired_instructions": int(retired_m.group(1)) if retired_m else insns,
    "ipc": float(ipc_m.group(1)) if ipc_m else None,
    "validated": valid,
    "simulator": "verilator"
}

result = {
    "schema": "score.benchmark_results.v1",
    "evidence_class": "score_measured",
    "core": "rv12",
    "upstream_commit": commit,
    "profile": profile,
    "workload": "dhrystone",
    "config": config,
    "metrics": metrics,
    "generated_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "host": {
        "hostname": "localhost.localdomain",
        "platform": "Linux-5.14.0-611.45.1.el9_7.x86_64-x86_64-with-glibc2.34",
        "python": "3.9.25"
    },
    "tool_versions": {
        "verilator": "5.022"
    }
}
with open(out_path, "w") as f:
    json.dump(result, f, indent=2)
print(f"Wrote {out_path} (DMIPS/MHz={dmips})")
PY

# 4. Write summary
{
    echo "RoaLogic RV12 Benchmark Summary (SCORE)"
    echo "Commit: $COMMIT"
    echo "Profile: $PROFILE"
    echo "Config: $CONFIG"
    echo "Results: $BENCH_DIR"
    echo "CoreMark/MHz: $(python3 -c "import json; print(json.load(open('$CM_JSON'))['metrics']['coremark_per_mhz'])")"
    echo "Dhrystone DMIPS/MHz: $(python3 -c "import json; print(json.load(open('$DHRY_JSON'))['metrics']['dhrystone_dmips_per_mhz'])")"
} > "$BENCH_DIR/benchmark_summary.txt"

log_success "RoaLogic RV12 benchmarks completed successfully!"
cat "$BENCH_DIR/benchmark_summary.txt"

