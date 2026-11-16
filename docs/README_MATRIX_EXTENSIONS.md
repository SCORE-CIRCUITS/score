# RISC-V Matrix Extensions & Tile Tensor Coprocessors Documentation

![License: Apache 2.0 / BSD](https://img.shields.io/badge/license-Apache%202.0%20%2F%20BSD-blue)
![Archetype: Archetype 7 - Vector-Matrix Hybrid](https://img.shields.io/badge/Archetype-Vector--Matrix%20Tile%20Hybrid-magenta)

This document details the specifications, proposals, and open architectures representing **Archetype 7: Vector-Matrix Hybrid / 2D Tile Tensor Engines** in the SCORE Taxonomy.

---

## 1. Overview & Architectural Role

Archetype 7 bridges the gap between flexible 1D vector execution (RVV 1.0) and rigid 2D spatial systolic arrays (Gemmini). By augmenting 1D vector registers with **2D tile matrix accumulator registers** (`ZA` / `AMX` / `T-Head Matrix` / `RVV-IME`), Archetype 7 engines compute outer-product matrix multiply-accumulate operations ($C += A \times B^T$) directly in silicon.

### Tracked Repositories in SCORE

| Project Name | Repository Path | Origin / Maintainer | Role |
|---|---|---|---|
| **RISC-V Integrated Matrix Extension (IME)** | [`tools/integrated-matrix-extension/`](file:///home/yongfu/proj/score/tools/integrated-matrix-extension) | Official RISC-V Task Group | Standard draft specification for tightly-coupled 2D tile matrix instructions (`Zvvm`). |
| **T-Head Matrix Extension** | [`tools/riscv-matrix-extension-spec/`](file:///home/yongfu/proj/score/tools/riscv-matrix-extension-spec) | Alibaba T-Head | Open specification, QEMU emulator, GNU toolchains, and GEMM/ResNet benchmarks. |
| **Apache TVM VTA** | [`tools/tvm-vta/`](file:///home/yongfu/proj/score/tools/tvm-vta) | Apache Software Foundation / UW | Open-source modular deep learning hardware accelerator with Chisel/HLS RTL and TVM JIT compiler. |

---

## 2. Microarchitectural Anatomy: Vector-Matrix Hybrid

Unlike 1D vector coprocessors where arithmetic is confined to element-wise or reduction operations, an Archetype 7 engine introduces:
1. **Tile Matrix Register File (TRF):** A two-dimensional register file (e.g., $16 \times 16$ or $32 \times 32$ elements) holding active accumulator tiles.
2. **Outer-Product Compute Units:** Multiplies a column of vector $A$ by a row of vector $B$, accumulating into the 2D tile in a single multi-cycle burst.
3. **Dual Programming Model:**
   * Uses standard 1D RVV vector instructions for non-linear operations (LayerNorm, GELU, Softmax).
   * Switches to 2D matrix tile instructions for dense GEMM and convolution layers.

---

## 3. Commercial & Academic Landscape Comparison

| Feature | RVV 1.0 (Ara) | Matrix Tile (IME / T-Head) | 2D Systolic (Gemmini) |
|---|---|---|---|
| **Data Dimensionality** | 1D Vectors | 1D Vectors + 2D Matrix Tiles | 2D Spatial PE Mesh |
| **Compute Density** | $O(N)$ Ops / cycle | $O(N^2)$ Ops / burst | $N \times N$ Ops / cycle |
| **Algorithm Flexibility** | High (Any mathematical code) | Medium-High (General + GEMM) | Low (GEMM & Conv only) |
| **Register Storage** | Centralized Banked VRF | 1D VRF + 2D Tile Accumulators | Private Scratchpads |
| **Silicon Area** | ~220 kGE | ~450–750 kGE | ~580–1,200 kGE |

---

## 4. The Open Silicon Gap

While commercial processors (Apple Neural Engine / AMX, Intel AMX, ARM SME, SiFive Intelligence X280/X390) widely adopt this archetype, open-source ratified RTL implementations remain in the standardization and prototyping stage. The inclusion of `tools/integrated-matrix-extension`, `tools/riscv-matrix-extension-spec`, and `tools/tvm-vta` allows SCORE to benchmark specifications and prototype models ahead of silicon tapeouts.
