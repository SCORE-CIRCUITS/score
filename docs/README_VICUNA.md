# Vicuna RISC-V Vector Coprocessor Documentation

![License: Apache 2.0](https://img.shields.io/badge/license-Apache%202.0-blue)
![Archetype: Archetype 2 - Compact Embedded Vector Unit](https://img.shields.io/badge/Archetype-Compact%20Embedded%20Vector-teal)

This document details the **Vicuna Vector Coprocessor** (developed at TU Wien), serving alongside **Spatz** as a representative implementation of **Archetype 2: Compact Embedded Vector Unit (Zve32 / Zve64)** in the SCORE Taxonomy.

---

## 1. Overview & Architectural Role

* **Repository Location:** [`tools/vicuna/`](file:///home/yongfu/proj/score/tools/vicuna)
* **Upstream Source:** [github.com/vproc/vicuna](https://github.com/vproc/vicuna)
* **ISA Support:** RISC-V Vector Extension v1.0 (`Zve32x`, `Zve32f`, `Zve64x`, `Zve64d`)
* **Coupling Interface:** Open Vector Interface (OVI) / Decoupled Coprocessor Port (compatible with Ibex, CV32E40X, and PicoRV32)
* **Key Paper:** Penz et al., *"Vicuna: An Open-Source RISC-V Vector Coprocessor for Compact Embedded Systems"*, DATE 2024 / IEEE Micro.

### Architectural Mechanism: Modular Embedded Vector Datapath
Vicuna is written in SystemVerilog and specifically architected for FPGA and ultra-low-area ASIC deployments:
* **Configurable VLEN:** Scalable from 128 to 512 bits.
* **Compact Single-Port VRF:** Implemented using standard FPGA block RAMs or single-port ASIC SRAM macros, significantly reducing routing complexity compared to Ara's multi-port VRF.
* **Vector Chaining Support:** Features hazard detection to chain arithmetic instructions behind memory loads when register banks do not collide.

---

## 2. Directory Structure in `tools/vicuna`

```
tools/vicuna/
├── doc/                  # Microarchitectural documentation
├── fpga/                 # FPGA synthesis scripts (Xilinx Vivado, Lattice, Intel)
├── sim/                  # Simulation testbench files (Verilator, VCS)
├── sw/                   # Software benchmarks (GEMM, 2D Conv, FFT, Softmax)
└── rtl/                  # SystemVerilog source files
    ├── vicuna_alu.sv     # 32-bit / 64-bit vector arithmetic logic unit
    ├── vicuna_mul.sv     # Vector multiplier datapath
    ├── vicuna_lsu.sv     # Vector load/store unit
    ├── vicuna_regfile.sv # BRAM/SRAM-optimized vector register file
    └── vicuna_top.sv     # Top-level coprocessor wrapper
```

---

## 3. Comparative Position vs Spatz

| Dimension | Vicuna (TU Wien) | Spatz (ETH Zurich) |
|---|---|---|
| **Primary Target** | FPGAs & General Embedded SoCs | Ultra-Low-Power ASICs (PULP/Snitch) |
| **VRF Implementation** | Single-Port BRAM / SRAM | Latch-based 2 KiB Multi-Bank |
| **Host Interface** | Open Vector Interface (OVI) | OBI Shared TCDM Crossbar |
| **Area Footprint** | ~45–65 kGE | ~35–45 kGE |
| **Double Precision (FP64)** | Optional (`Zve64d`) | Native Shared Pipelined FPU |

---

## 4. Integration into SCORE

* **Category Mapping:** Category 3 (Vector & Coprocessor Acceleration Engines).
* **Workloads:** Integer and floating-point GEMM, 2D convolution, and edge TinyML kernels.
