# Vortex Open-Source RISC-V GPGPU Documentation

![License: Apache 2.0](https://img.shields.io/badge/license-Apache%202.0-blue)
![Archetype: Archetype 8 - Many-Core SIMT](https://img.shields.io/badge/Archetype-Many--Core%20SIMT%20(GPGPU)-crimson)

This document details the **Vortex GPGPU** (developed at Georgia Tech), serving as the primary hardware exemplar for **Archetype 8: Many-Core SIMT (GPGPU Coprocessor)** in the SCORE Taxonomy.

---

## 1. Overview & Architectural Role

* **Repository Location:** [`tools/vortex/`](file:///home/yongfu/proj/score/tools/vortex)
* **Upstream Source:** [github.com/vortexgpgpu/vortex](https://github.com/vortexgpgpu/vortex)
* **Design Language:** SystemVerilog
* **Software Toolchain:** LLVM/Clang compiler with **VOLT** runtime (supporting OpenCL 1.2, CUDA, and Vulkan SPIR-V)
* **Key Papers:**
  * Tine et al., *"Vortex: An Open-Source Full-Stack RISC-V GPGPU"*, IEEE MICRO / ASPLOS.
  * Tine et al., *"VOLT: An Open-Source Compiler Infrastructure for Accelerated Computing on RISC-V"*, DAC 2023.

### Architectural Mechanism: SIMT Execution & Warp Scheduling
Rather than executing single vector instructions over long vectors (SIMD), Vortex adopts the **Single-Instruction Multiple-Threads (SIMT)** execution paradigm:
1. **Warp Scheduling:** Cores group 4 to 32 parallel scalar threads into warps, executing in lockstep.
2. **Branch Divergence Stack:** Hardware divergence handling automatically masks inactive threads when conditional branches diverge, re-converging at reconvergence points.
3. **Memory Coalescing:** Memory access requests from threads within a warp are analyzed and coalesced into single high-bandwidth burst transfers.
4. **Hierarchical Clusters:** Vortex scales from a single compute unit (CU) to multi-core, multi-cluster architectures communicating over AXI/NoC crossbars.

---

## 2. Directory Structure in `tools/vortex`

```
tools/vortex/
├── hw/                   # SystemVerilog RTL
│   ├── rtl/              # Core pipeline, ALU, FPU, warp scheduler, LSU
│   ├── syn/              # ASIC & FPGA synthesis scripts (Synopsys, Vivado)
│   └── unittest/         # Module-level unit tests
├── sim/                  # Cycle-accurate simulators
│   ├── simx/             # High-speed C++ functional simulator
│   └── vlsim/            # Verilator-based cycle-accurate RTL simulator
├── sw/                   # Software stack & drivers
│   ├── compiler/         # LLVM / Clang / POCL CUDA/OpenCL compiler
│   └── runtime/          # OpenCL / CUDA runtime libraries
└── tests/                # GPGPU benchmark suite (Rodinia, Polybench, DeepBench)
```

---

## 3. Comparative Position: SIMD (RVV 1.0) vs SIMT (Vortex)

| Dimension | RVV 1.0 (Ara / Spatz) | SIMT GPGPU (Vortex) |
|---|---|---|
| **Programming Model** | Vectorized Assembly / C Intrinsics | SPMD Thread Code (CUDA / OpenCL / C++) |
| **Control Flow** | Vector Predication / Masks | Dynamic Hardware Warp Divergence |
| **Instruction Issue** | 1 Vector Instruction = Multi-Cycle Wave | 1 Warp Instruction = Single-Cycle Wave |
| **Area Efficiency** | High compute per gate (low control overhead) | Lower area efficiency (warp buffers, divergence) |
| **Workload Flexibility**| General Scientific & Linear Algebra | Irregular Parallelism, Graph Analytics, Shaders |
| **Silicon Area** | ~220 kGE (4 Lanes) | ~1,500–3,500 kGE (Cluster) |

---

## 4. Integration into SCORE

* **Category Mapping:** Category 3 (Extended Coprocessor Taxonomy & Future GPGPU Benchmark Harness).
* **Workloads:** OpenCL Matrix Multiply, 2D Convolution, Ray Tracing, and Reduction sweeps.
