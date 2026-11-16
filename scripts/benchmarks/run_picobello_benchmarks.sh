#!/usr/bin/env bash
# Copyright 2026 SCORE Project
# SPDX-License-Identifier: Apache-2.0
#
# Benchmark execution runner for Picobello SoC platform under native Verilator simulation.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

SIM_BIN="${REPO_ROOT}/scripts/assets/picobello/obj_dir/Vpicobello_top_verilator"
SW_DIR="${REPO_ROOT}/scripts/assets/picobello/sw/bin"
OUT_DIR="${REPO_ROOT}/datasets/picobello/71df12a2/benchmarks"

mkdir -p "${OUT_DIR}"

if [[ ! -x "${SIM_BIN}" ]]; then
    echo "ERROR: Simulation binary not found at ${SIM_BIN}" >&2
    echo "Please build the Verilator model first." >&2
    exit 1
fi

# Benchmarks to run
if [[ $# -gt 0 ]]; then
    BENCHMARKS=("$@")
else
    BENCHMARKS=("helloworld" "sanity" "access_clk_gating_rst_ctrl_reg" "access_l2")
fi

HOSTNAME="$(hostname)"
OS_STR="Linux-$(uname -r)-$(uname -m)-with-glibc$(getconf GNU_LIBC_VERSION 2>/dev/null || echo 2.34)"
SIMULATOR_STR="verilator-5.022"
TOOLCHAIN_STR="${REPO_ROOT}/datasets/gemmini/workshop/chipyard/.conda-env/riscv-tools/bin/riscv64-unknown-elf-"

for bench in "${BENCHMARKS[@]}"; do
    elf_file="${SW_DIR}/${bench}.spm.elf"
    log_file="${OUT_DIR}/${bench}_run.log"
    json_file="${OUT_DIR}/${bench}.json"

    if [[ ! -f "${elf_file}" ]]; then
        echo "WARNING: ELF file not found: ${elf_file}, skipping..." >&2
        continue
    fi

    echo "=============================================================="
    echo "Running Picobello SoC Benchmark: ${bench}"
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
    # Pattern: [SLINK] Hart 0 finished with code 0 (cycle 426699)
    exit_code=$(grep -oP 'Hart 0 finished with code \K[0-9]+' "${log_file}" | tail -n 1 || echo "")
    if [[ -z "${exit_code}" ]]; then
        exit_code="${sim_status}"
    fi

    # Cycles
    total_cycles=$(grep -oP '\[VLT\] Simulated \K[0-9]+' "${log_file}" | tail -n 1 || echo "")
    if [[ -z "${total_cycles}" ]]; then
        total_cycles=$(grep -oP 'finished with code \d+ \(cycle \K[0-9]+' "${log_file}" | tail -n 1 || echo "0")
    fi

    exec_cycles=$(grep -oP 'finished with code \d+ \(cycle \K[0-9]+' "${log_file}" | tail -n 1 || echo "${total_cycles}")

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
  "core": "picobello",
  "architecture": "rv64gc_cva6_snitch",
  "profile": "soc_verilator",
  "benchmark": "${bench}",
  "configuration": "cheshire_cva6_8snitch_8memtile_floonoc",
  "environment": {
    "hostname": "${HOSTNAME}",
    "os": "${OS_STR}",
    "simulator": "${SIMULATOR_STR}",
    "toolchain": "${TOOLCHAIN_STR}"
  },
  "metrics": {
    "execution_cycles": ${exec_cycles},
    "total_simulation_cycles": ${total_cycles},
    "wall_time_sec": ${wall_sec},
    "simulation_speed_khz": ${sim_speed_khz},
    "exit_code": ${exit_code}
  },
  "status": "${status_str}",
  "run_at_utc": "${run_time_utc}"
}
EOF

    echo "Saved result to ${json_file}"
done

echo "=============================================================="
echo "All Picobello Benchmarks Completed!"
