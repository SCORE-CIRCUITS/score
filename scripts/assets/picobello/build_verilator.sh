#!/usr/bin/env bash
# Copyright 2026 SCORE Project
# SPDX-License-Identifier: Apache-2.0
#
# Build script for native Verilator simulation model of Picobello SoC.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

mkdir -p "${SCRIPT_DIR}/obj_dir"

echo "=== Building Picobello Verilator Model (Vpicobello_top_verilator) ==="
echo "Top module: picobello_top_verilator"
echo "Output directory: ${SCRIPT_DIR}/obj_dir"

verilator --cc --exe --build -j 64 --top-module picobello_top_verilator \
  --timing -timescale 1ns/1ps \
  -Wno-fatal -Wno-lint -Wno-style -Wno-MULTIDRIVEN -Wno-UNOPTFLAT -Wno-BLKANDNBLK \
  -Wno-SHORTREAL -Wno-WIDTHCONCAT -Wno-SELRANGE -Wno-ENUMVALUE -Wno-COMBDLY \
  -DCVA6_NO_LEGACY_TRACE -DASSERTS_OFF -DPRIM_ASSERT_SV \
  --x-assign 0 --x-initial 0 -O1 \
  -CFLAGS "-std=c++17 -I${SCRIPT_DIR} -I${REPO_ROOT}/tools/cheshire/target/sim/src -I${REPO_ROOT}/tools/cheshire/target/sim/verilator/src -Wno-error -Wno-array-bounds -Wno-stringop-overflow -Wno-format" \
  -f "${SCRIPT_DIR}/picobello_vlt.flist" \
  "${SCRIPT_DIR}/main.cpp" \
  "${REPO_ROOT}/tools/cheshire/target/sim/src/elfloader.cpp" \
  -Mdir "${SCRIPT_DIR}/obj_dir" -o Vpicobello_top_verilator

echo "=== Picobello Verilator Model Built Successfully! ==="
ls -lh "${SCRIPT_DIR}/obj_dir/Vpicobello_top_verilator"
