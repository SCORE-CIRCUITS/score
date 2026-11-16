#!/usr/bin/env bash
# Copyright 2026 SCORE Project
# SPDX-License-Identifier: Apache-2.0
#
# Benchmark execution runner for Carfield SoC platform under native Verilator simulation.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

SIM_BIN="${REPO_ROOT}/scripts/assets/carfield/obj_dir/Vcarfield_top_verilator"
SW_DIR="${REPO_ROOT}/scripts/assets/carfield/sw/bin"
OUT_DIR="${REPO_ROOT}/datasets/carfield/ee168c59/benchmarks"

mkdir -p "${OUT_DIR}"

if [[ ! -x "${SIM_BIN}" ]]; then
    echo "ERROR: Simulation binary not found at ${SIM_BIN}" >&2
    echo "Please build the Verilator model first." >&2
    exit 1
fi

# Ensure unlimited stack size to prevent SIGSEGV in large Verilator model construction
ulimit -s unlimited

# Benchmarks to run
if [[ $# -gt 0 ]]; then
    BENCHMARKS=("$@")
else
    BENCHMARKS=("helloworld")
fi

HOSTNAME="$(hostname)"
OS_STR="Linux-$(uname -r)-$(uname -m)-with-glibc$(getconf GNU_LIBC_VERSION 2>/dev/null || echo 2.34)"
SIMULATOR_STR="verilator-5.022"
TOOLCHAIN_STR="${REPO_ROOT}/tools/riscv_toolchain_wrapper/riscv64-unknown-elf-"

for bench in "${BENCHMARKS[@]}"; do
    elf_file="${SW_DIR}/${bench}.car.l2.elf"
    log_file="${OUT_DIR}/${bench}_run.log"
    json_file="${OUT_DIR}/${bench}.json"

    if [[ ! -f "${elf_file}" ]]; then
        echo "WARNING: ELF file not found: ${elf_file}, skipping..." >&2
        continue
    fi

    echo "=============================================================="
    echo "Running Carfield Automotive SoC Benchmark: ${bench}"
    echo "ELF: ${elf_file}"
    echo "=============================================================="

    start_ns=$(date +%s%N)
    set +e
    "${SIM_BIN}" "+BINARY=${elf_file}" "+PRELMODE=1" "+MAX_CYCLES=5000000" "+PROGRESS=100000" > "${log_file}" 2>&1
    sim_status=$?
    end_ns=$(date +%s%N)
    set -e

    wall_sec=$(awk "BEGIN {printf \"%.4f\", (${end_ns} - ${start_ns}) / 1000000000}")

    cat "${log_file}"

    # Extract metrics from simulation output
    exit_code=$(grep -oP '\[SLINK\] (?:SUCCESS|FAILED: return code \K[0-9]+)' "${log_file}" | tail -n 1 || echo "")
    if [[ "${exit_code}" == "[SLINK] SUCCESS" || "${exit_code}" == "SUCCESS" ]]; then
        exit_code=0
    elif [[ -z "${exit_code}" ]]; then
        exit_code="${sim_status}"
    fi

    # Cycles
    total_cycles=$(grep -oP '\[VLT\] Simulated \K[0-9]+' "${log_file}" | tail -n 1 || echo "")
    if [[ -z "${total_cycles}" ]]; then
        total_cycles=$(grep -oP 'cycle \K[0-9]+' "${log_file}" | tail -n 1 || echo "0")
    fi

    exec_cycles="${total_cycles}"
    sim_speed_khz=$(grep -oP '\(\K[0-9.]+(?=\s*kHz\))' "${log_file}" | tail -n 1 || echo "null")

    if [[ "${sim_status}" -eq 0 && "${exit_code}" == "0" ]]; then
        status_str="passed"
    else
        status_str="failed"
    fi

    run_time_utc=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Generate schema-compliant JSON
    cat <<EOF > "${json_file}"
{
  "schema": "score.benchmark_results.v1",
  "core": "carfield",
  "architecture": "rv64gc_dual_cluster",
  "profile": "soc_verilator",
  "benchmark": "${bench}",
  "configuration": "carfield_cheshire_cva6_pulp_safety_island",
  "environment": {
    "hostname": "${HOSTNAME}",
    "os": "${OS_STR}",
    "simulator": "${SIMULATOR_STR}",
    "toolchain": "${TOOLCHAIN_STR}"
  },
  "metrics": {
    "status": "${status_str}",
    "exit_code": ${exit_code},
    "execution_cycles": ${exec_cycles},
    "total_simulation_cycles": ${total_cycles},
    "sim_speed_khz": ${sim_speed_khz},
    "wall_clock_time_seconds": ${wall_sec}
  },
  "timestamp": "${run_time_utc}"
}
EOF

    echo "Saved benchmark JSON to ${json_file}"
done

echo "Carfield benchmark execution complete."
