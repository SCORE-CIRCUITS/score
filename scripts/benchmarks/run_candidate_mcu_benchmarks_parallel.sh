#!/usr/bin/env bash
# SCORE Parallel Benchmark Runner for Onboarded Candidate MCU Cores
# Runs snapshots, lint, and cycle-accurate benchmarks concurrently across available CPU cores.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
cd "$PROJECT_ROOT"

echo "=========================================================="
echo " SCORE Parallel Benchmark Orchestrator (96-Core Server)"
echo " Candidates: VeeR EH1, VeeR EH2, CV32E40P, FemtoRV32"
echo "=========================================================="

mkdir -p logs/benchmarks_parallel

echo "[Phase 1] Launching parallel RTL snapshots and lint checks..."
(
    ./scripts/generate_veer_eh1.sh > logs/benchmarks_parallel/generate_veer_eh1.log 2>&1 && echo "  [OK] VeeR EH1 snapshot & lint"
) &
PID1=$!

(
    ./scripts/generate_veer_eh2.sh > logs/benchmarks_parallel/generate_veer_eh2.log 2>&1 && echo "  [OK] VeeR EH2 snapshot & lint"
) &
PID2=$!

(
    ./scripts/generate_cv32e40p.sh > logs/benchmarks_parallel/generate_cv32e40p.log 2>&1 && echo "  [OK] CV32E40P snapshot & lint"
) &
PID3=$!

(
    ./scripts/generate_femtorv.sh > logs/benchmarks_parallel/generate_femtorv.log 2>&1 && echo "  [OK] FemtoRV snapshot & lint"
) &
PID4=$!

wait "$PID1" "$PID2" "$PID3" "$PID4"
echo "Phase 1 complete: All RTL snapshots and manifests ready."

echo ""
echo "[Phase 2] Launching parallel cycle-accurate benchmark simulations..."

# Launch benchmarks in parallel
(
    ./scripts/benchmarks/run_veer_eh1_coremark.sh > logs/benchmarks_parallel/veer_eh1_coremark.log 2>&1
    ./scripts/benchmarks/run_veer_eh1_dhrystone.sh > logs/benchmarks_parallel/veer_eh1_dhrystone.log 2>&1
    echo "  [OK] VeeR EH1 (CoreMark & Dhrystone)"
) &
B_PID1=$!

(
    ./scripts/benchmarks/run_veer_eh2_coremark.sh > logs/benchmarks_parallel/veer_eh2_coremark.log 2>&1
    ./scripts/benchmarks/run_veer_eh2_dhrystone.sh > logs/benchmarks_parallel/veer_eh2_dhrystone.log 2>&1
    echo "  [OK] VeeR EH2 (CoreMark & Dhrystone)"
) &
B_PID2=$!

(
    ./scripts/benchmarks/run_cv32e40p_benchmarks.sh > logs/benchmarks_parallel/cv32e40p.log 2>&1
    echo "  [OK] CV32E40P (CoreMark, Dhrystone & PULP-DSP)"
) &
B_PID3=$!

(
    ./scripts/benchmarks/run_femtorv_coremark.sh > logs/benchmarks_parallel/femtorv_coremark.log 2>&1
    ./scripts/benchmarks/run_femtorv_dhrystone.sh > logs/benchmarks_parallel/femtorv_dhrystone.log 2>&1
    echo "  [OK] FemtoRV32 (CoreMark & Dhrystone)"
) &
B_PID4=$!

wait "$B_PID1" "$B_PID2" "$B_PID3" "$B_PID4"
echo "Phase 2 complete: All parallel simulations finished."

echo ""
echo "[Phase 3] Aggregating results into SCORE database..."
python3 scripts/benchmarks/collect_core_benchmark_results.py

echo "=========================================================="
echo " Parallel verification & benchmarking successfully completed!"
echo "=========================================================="
