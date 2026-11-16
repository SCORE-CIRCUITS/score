# CV32E40P Core & PULP Packed-SIMD (XpulpV2) Documentation

![License: Apache 2.0](https://img.shields.io/badge/license-Apache%202.0-blue)
![Archetype: Archetype 1 - Packed Sub-Word SIMD](https://img.shields.io/badge/Archetype-Packed%20SIMD%20(Zero--VRF)-orange)

This document details the **OpenHW Group CV32E40P** (formerly `RI5CY`) and its sub-word SIMD / DSP extensions (`XpulpV2`), serving as the primary hardware exemplar for **Archetype 1: Packed Sub-Word SIMD (DSP Extension / Zero-VRF)** in the SCORE Taxonomy.

---

## 1. Overview & Architectural Role

* **Repository Location:** [`tools/cv32e40p/`](file:///home/yongfu/proj/score/tools/cv32e40p)
* **Upstream Source:** [github.com/openhwgroup/cv32e40p](https://github.com/openhwgroup/cv32e40p)
* **ISA Support:** RV32IMC[F] + Custom PULP DSP Extensions (`XpulpV2`)
* **Pipeline:** 4-stage in-order pipeline (IF, ID, EX, WB)
* **Key Paper:** Gautschi et al., *"Near-Threshold RISC-V Core With DSP Extensions for Mobile Applications"*, IEEE TVLSI 2017.

### Architectural Mechanism: Zero-VRF Sub-Word SIMD
Unlike standard vector coprocessors (RVV 1.0) which require a distinct Vector Register File (VRF), Archetype 1 cores partition the existing 32-bit scalar general-purpose registers (`x0–x31`) into:
* **Dual 16-bit Sub-Words:** Executing two 16-bit operations per clock cycle (e.g. `pv.add.h`, `pv.sub.h`, `pv.dotsp.h`).
* **Quad 8-bit Sub-Words:** Executing four 8-bit operations per clock cycle (e.g. `pv.add.b`, `pv.sub.b`, `pv.dotsp.b`).
* **Fused Dot-Product MACs:** Performing 4-way multiply-accumulate with 32-bit accumulation in a single cycle (`pv.sdotsp.b`).

---

## 2. Directory Structure in `tools/cv32e40p`

```
tools/cv32e40p/
├── bender/               # Bender package dependencies
├── docs/                 # User manual and microarchitecture specifications
├── example_tb/           # Core-level simulation testbench (Verilator / Questasim)
├── fpu/                  # Optional IEEE-754 FP32 coprocessor unit
├── rtl/                  # SystemVerilog source files
│   ├── cv32e40p_alu.sv   # Sub-word SIMD ALU & DSP datapath
│   ├── cv32e40p_core.sv  # Top-level core wrapper
│   └── cv32e40p_id_stage.sv # Instruction decode logic
└── vendor/               # Upstream vendor IP cells
```

---

## 3. PPA & Microarchitectural Trade-Offs

| Metric | Measured Value (TSMC 65nm / GF 22nm) |
|---|---|
| **Gate Count (Standard RV32IMC)** | ~18 kGE |
| **Gate Count with XpulpV2 DSP** | ~28 kGE (+55% area for dual/quad SIMD ALUs) |
| **Operating Frequency** | 350–500 MHz (22nm FD-SOI) |
| **Throughput on 8-bit Dot-Product** | 4 MACs / cycle |
| **Limitation vs RVV 1.0** | Fixed VLEN = 32b; severe register pressure; cannot chain vector operations. |

---

## 4. Integration into SCORE

* **Category Mapping:** Category 1 (MCU & Scalar Cores) when evaluated as a standalone processor; Category 3 (Taxonomy Reference for Archetype 1).
* **Reference Workload:** `pulp-dsp` FIR filters, 8-bit quantized matrix multiply, and fixed-point FFT.
