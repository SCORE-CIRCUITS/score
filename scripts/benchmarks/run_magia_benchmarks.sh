#!/usr/bin/env bash
# Copyright 2026 SCORE Project
# SPDX-License-Identifier: Apache-2.0
#
# Benchmark execution runner for MAGIA GenAI accelerator tile under native Verilator simulation.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

SIM_BIN="${REPO_ROOT}/scripts/assets/magia/obj_dir/Vtb_magia_verilator"
HEX_DIR="${REPO_ROOT}/scripts/assets/magia/sw/bin"
OUT_DIR="${REPO_ROOT}/datasets/magia/4a45e25a/benchmarks"

mkdir -p "${OUT_DIR}"

if [[ ! -x "${SIM_BIN}" ]]; then
    echo "ERROR: Simulation binary not found at ${SIM_BIN}" >&2
    exit 1
fi

BENCHMARKS=("hello_world" "l1_test")

HOSTNAME="$(hostname)"
OS_STR="Linux-$(uname -r)-$(uname -m)-with-glibc$(getconf GNU_LIBC_VERSION 2>/dev/null || echo 2.34)"
SIMULATOR_STR="verilator-5.022"
TOOLCHAIN_STR="${REPO_ROOT}/tools/ibex-host-tools/riscv/bin/riscv32-unknown-elf-"

for bench in "${BENCHMARKS[@]}"; do
    hex_file="${HEX_DIR}/${bench}.hex"
    log_file="${OUT_DIR}/${bench}_run.log"
    json_file="${OUT_DIR}/${bench}.json"

    if [[ ! -f "${hex_file}" ]]; then
        echo "WARNING: Hex file not found: ${hex_file}, skipping..." >&2
        continue
    fi

    echo "=============================================================="
    echo "Running MAGIA Benchmark: ${bench}"
    echo "Image: ${hex_file}"
    echo "=============================================================="

    start_ns=$(date +%s%N)
    set +e
    "${SIM_BIN}" "+IMAGE=${hex_file}" "+MAX_CYCLES=5000000" > "${log_file}" 2>&1
    sim_status=$?
    end_ns=$(date +%s%N)
    set -e

    wall_sec=$(awk "BEGIN {printf \"%.4f\", (${end_ns} - ${start_ns}) / 1000000000}")

    cat "${log_file}"

    # Extract metrics from simulation output
    exit_code=$(grep -oP 'Exit Code:\s+\K[0-9]+' "${log_file}" | tail -n 1 || echo "-1")
    total_cycles=$(grep -oP 'Total Cycles:\s+\K[0-9]+' "${log_file}" | tail -n 1 || echo "0")
    retired_insts=$(grep -oP 'Retired Instructions:\s+\K[0-9]+' "${log_file}" | tail -n 1 || echo "0")
    cpi=$(grep -oP 'CPI:\s+\K[0-9.]+' "${log_file}" | tail -n 1 || echo "null")

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
  "core": "magia",
  "architecture": "rv32imf",
  "profile": "soc_verilator",
  "benchmark": "${bench}",
  "configuration": "cv32e40p_redmule_spm_floonoc",
  "environment": {
    "hostname": "${HOSTNAME}",
    "os": "${OS_STR}",
    "simulator": "${SIMULATOR_STR}",
    "toolchain": "${TOOLCHAIN_STR}"
  },
  "metrics": {
    "execution_cycles": ${total_cycles},
    "total_simulation_cycles": ${total_cycles},
    "wall_time_sec": ${wall_sec},
    "retired_instructions": ${retired_insts},
    "cpi": ${cpi}
  },
  "status": "${status_str}",
  "run_at_utc": "${run_time_utc}"
}
EOF

    echo "Saved result to ${json_file}"
done

echo "=============================================================="
echo "All MAGIA Benchmarks Completed Successfully!"
echo "=============================================================="

