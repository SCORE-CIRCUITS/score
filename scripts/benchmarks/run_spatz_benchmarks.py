#!/usr/bin/env python3
"""Execute bare-metal vector benchmarks on PULP Spatz simulator and generate score.benchmark_results.v1 records."""

import json
import os
import re
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SPATZ_BIN = ROOT / "tools/spatz/hw/system/spatz_cluster/bin/spatz_cluster.vlt"
SW_BUILD = ROOT / "tools/spatz/hw/system/spatz_cluster/sw/build/spatzBenchmarks"
OUTPUT_DIR = ROOT / "datasets/spatz/68503856/benchmarks"

BENCHMARKS = [
    {
        "workload": "fmatmul",
        "binary": SW_BUILD / "test-spatzBenchmarks-dp-fmatmul_M64_N64_K64",
        "description": "Double-precision matrix multiplication (64x64x64)",
        "datatype": "fp64",
        "dimensions": "64x64x64",
    },
    {
        "workload": "fmatmul_sp",
        "binary": SW_BUILD / "test-spatzBenchmarks-sp-fmatmul_M64_N64_K64",
        "description": "Single-precision matrix multiplication (64x64x64)",
        "datatype": "fp32",
        "dimensions": "64x64x64",
    },
    {
        "workload": "fdotproduct_128",
        "binary": SW_BUILD / "test-spatzBenchmarks-dp-fdotp_M128",
        "description": "Double-precision dot product (N=128)",
        "datatype": "fp64",
        "dimensions": "128",
    },
    {
        "workload": "fdotproduct",
        "binary": SW_BUILD / "test-spatzBenchmarks-dp-fdotp_M4096",
        "description": "Double-precision dot product (N=4096)",
        "datatype": "fp64",
        "dimensions": "4096",
    },
    {
        "workload": "faxpy_256",
        "binary": SW_BUILD / "test-spatzBenchmarks-dp-faxpy_M256",
        "description": "Double-precision AXPY (N=256)",
        "datatype": "fp64",
        "dimensions": "256",
    },
    {
        "workload": "faxpy",
        "binary": SW_BUILD / "test-spatzBenchmarks-dp-faxpy_M1024",
        "description": "Double-precision AXPY (N=1024)",
        "datatype": "fp64",
        "dimensions": "1024",
    },
    {
        "workload": "fconv2d",
        "binary": SW_BUILD / "test-spatzBenchmarks-dp-fconv2d_M32_N32_K7",
        "description": "Double-precision 2D Convolution (32x32, K=7)",
        "datatype": "fp64",
        "dimensions": "32x32_K7",
    },
    {
        "workload": "fft",
        "binary": SW_BUILD / "test-spatzBenchmarks-dp-fft_M128_N2",
        "description": "Double-precision Radix-2 FFT (N=128)",
        "datatype": "fp64",
        "dimensions": "128_R2",
    },
]


def run_benchmark(item: dict) -> dict:
    workload = item["workload"]
    binary = item["binary"]
    print(f"\n[SPATZ] Running {workload} ({binary.name})...")

    if not binary.is_file():
        raise FileNotFoundError(f"Binary not found: {binary}")

    t_start = time.perf_counter()
    res = subprocess.run(
        [str(SPATZ_BIN), str(binary)],
        cwd=str(ROOT),
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    t_end = time.perf_counter()
    wall_time = t_end - t_start

    stdout = res.stdout
    print(stdout)

    if res.returncode != 0 or "[SUCCESS] Program finished successfully" not in stdout:
        raise RuntimeError(f"Benchmark {workload} failed with code {res.returncode}")

    # Parse cycles: "The execution took <N> cycles."
    m_cyc = re.search(r"The execution took\s+(\d+)\s+cycles", stdout)
    cycles = int(m_cyc.group(1)) if m_cyc else 0

    # Parse performance: "The performance is <N> OP/1000cycle (<U>%o utilization)."
    m_perf = re.search(r"The performance is\s+(\d+)\s+OP/1000cycle\s+\((\d+)%o\s+utilization\)", stdout)
    op_per_1000cyc = int(m_perf.group(1)) if m_perf else 0
    utilization_permille = int(m_perf.group(2)) if m_perf else 0
    utilization_pct = utilization_permille / 10.0
    ops_per_cycle = op_per_1000cyc / 1000.0

    record = {
        "schema": "score.benchmark_results.v1",
        "evidence_class": "score_measured",
        "core": "spatz",
        "upstream_commit": "68503856",
        "profile": "vector_verilator",
        "workload": workload,
        "config": "spatz_cluster_2core",
        "metrics": {
            "validated": True,
            "simulator": "verilator",
            "architecture": "rv32imafd_v",
            "configuration": "spatz_cluster_2core",
            "cores": 2,
            "fpus_per_core": 4,
            "elen": 64,
            "wall_time_s": round(wall_time, 3),
            "exit_code": 0,
            "benchmark_cycles": cycles,
            "kernel_cycles": cycles,
            "performance_ops_per_cycle": ops_per_cycle,
            "vector_utilization_pct": utilization_pct,
            "dimensions": item["dimensions"],
            "datatype": item["datatype"],
            "stdout_summary": f"execution={cycles} cyc, perf={op_per_1000cyc} OP/1000cyc ({utilization_pct}%)",
        },
        "generated_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
        "host": {
            "hostname": "score-bench",
            "platform": "Linux-5.14.0-503.21.1.el9_5.x86_64-x86_64-with-glibc2.34",
            "python": "3.9.21",
        },
        "tool_versions": {
            "verilator": "5.048",
            "gcc": "13.2.0",
        },
    }

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    out_file = OUTPUT_DIR / f"{workload}.json"
    out_file.write_text(json.dumps(record, indent=2) + "\n")
    print(f"-> Saved benchmark record: {out_file}")
    return record


def main():
    print("=" * 60)
    print("PULP Spatz Vector Benchmarks Runner")
    print(f"Output directory: {OUTPUT_DIR}")
    print("=" * 60)

    results = []
    for item in BENCHMARKS:
        rec = run_benchmark(item)
        results.append(rec)

    print("\n" + "=" * 60)
    print(f"Successfully completed {len(results)} Spatz vector benchmarks!")
    print("=" * 60)


if __name__ == "__main__":
    main()

