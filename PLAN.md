# SCORE: Verilator Open-Source Simulation Migration Plan

> [!IMPORTANT]
> **Goal**: Convert all 8 commercial-EDA-gated Category 4 SoC platforms and cluster subsystems into fully open-source **Verilator cycle-accurate simulation platforms**, eliminating dependencies on proprietary commercial tools (Mentor QuestaSim `vsim`, Synopsys `vcs`).
> **Core Principle**: Upstream chip RTL is already 100% synthesizable SystemVerilog (silicon tapeouts in TSMC, GF, IHP). We do **not** modify upstream core silicon RTL; we replace the proprietary simulation testbench collar with an open-source **Verilator C++ testbench harness** + **DPI-C ELF preloader**.

---

## Architecture: The Verilator Bridge Pattern

All commercial PULP platforms share an identical testbench collar architecture (`vip_<platform>_soc.sv`, `fixture_<platform>.sv`, `tb_<platform>_preloaded.sv`) relying on dynamic OOP SystemVerilog classes (`axi_test::axi_driver`), time delays (`#10ns`), and UVM constructs.

We replace that proprietary collar with a standardized, lightweight Verilator bridge:

```
┌────────────────────────────────────────────────────────────────────────┐
│                   SCORE Verilator Testbench Harness                    │
│                                                                        │
│   ┌────────────────────────────────┐  ┌─────────────────────────────┐  │
│   │   C++ Simulation Driver        │  │     DPI-C ELF Preloader     │  │
│   │   (tb_<platform>_verilator.cpp)│  │      (dpi_memutil.cc)       │  │
│   │   - Reset sequencing           │  │   - Reads ELF / Hex symbols │  │
│   │   - High-speed cycle ticking   │  │   - Direct injection to L2  │  │
│   │   - UART console stdout loop   │  │   - Sets boot address CSR   │  │
│   │   - EOC / timeout monitor      │  │                             │  │
│   └───────────────┬────────────────┘  └──────────────┬──────────────┘  │
│                   │                                  │                 │
│                   ▼                                  ▼                 │
│   ┌─────────────────────────────────────────────────────────────────┐  │
│   │        Synthesizable SystemVerilog Top Wrapper                  │  │
│   │        (tb_<platform>_verilator.sv)                             │  │
│   │        - Instantiates top DUT / synthesis wrapper               │  │
│   │        - Maps external AXI ports to simple BRAM / responder     │  │
│   │        - Exposes clock, reset, and UART TX to C++               │  │
│   └────────────────────────────────┬────────────────────────────────┘  │
└────────────────────────────────────┼───────────────────────────────────┘
                                     │
                                     ▼
        ┌─────────────────────────────────────────────────────────┐
        │                 Upstream Silicon RTL DUT                │
        │        (Safety Island, PULP Cluster, Chimera, etc.)     │
        └─────────────────────────────────────────────────────────┘
```

---

## Phased Implementation Roadmap

| Phase | Platform | Architecture Class | Complexity | Target Workloads | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Phase 1** | **Safety Island** | Triple-Core Lockstep (TCLS) **CV32E40P** subsystem | Low | Hello World, CoreMark | ✅ **Completed** (CoreMark: 849k cyc, CPI 1.44) |
| **Phase 2** | **PULP Cluster** | Multi-core **CV32E40P** compute cluster + TCDM | Medium | Matrix Multiply, Parallel Reduction, FIR | 🚀 **In Progress** |
| **Phase 3** | **Chimera** | Heterogeneous Multi-Accelerator SoC | Medium | DMA transfers, compute tiles, Hello World | 📋 Planned |
| **Phase 4** | **MAGIA & Picobello** | GenAI **RedMulE** FP16 tiles + **FlooNoC** 2D mesh | High | GeMM matrix multiply, NoC ping-pong | 📋 Planned |
| **Phase 5** | **Carfield & Astral** | Heterogeneous Automotive Full-SoC Integration | Very High | Full-chip heterogeneous boot & cluster handoff | 📋 Planned |

---

## Phase 1: Safety Island (`tools/safety-island`) — ✅ COMPLETED

### 1.1 Architecture & Scope
- **Upstream Location**: `tools/safety-island/` (Commit `584eb697`)
- **Core Architecture**: Triple-Core Lockstep (TCLS) **CV32E40P** (`rv32imc`) with CLIC interrupt controller, ECC-protected 128KB SRAM, and AXI4 crossbar.
- **Why it was blocked on commercial EDA**: Upstream `sim/Makefile` and `safed_sim.mk` invoked `vsim -c -do 'source compile.tcl'` with UVM/SVA dependencies.
- **Delivered Solution**:
  - Testbench: `scripts/assets/safety_island/tb_safety_island_verilator.sv` (pure synthesizable SV harness with AXI slave preloader and TBPrintf handler).
  - Software Suite: `scripts/assets/safety_island/sw/` (`hello.c`, `coremark` 2 iterations).
  - Runner: `scripts/benchmarks/run_safety_island_benchmarks.sh`.
  - Verified Benchmark Results:
    - `hello`: 1,187 cycles (`status: passed`).
    - `coremark`: 849,455 execution cycles, 589,747 retired instructions, CPI = 1.44, exit code 0 (`status: passed`).
  - Suite Registration: Registered in `benchmarks/soc/suite.json` and aggregated in `benchmarks/soc/aggregated_results.json`.

### 1.2 Implementation Steps
1. **Create Synthesizable Verilator Wrapper**:
   - Location: `tools/safety-island/rtl/tb/tb_safety_island_verilator.sv` (or in `scripts/assets/safety_island/`).
   - Instantiates `safety_island_synth_wrapper`.
   - Attaches AXI slave memory responder for memory space `[0x0000_0000 : 0x0080_0000]`.
   - Exposes top-level clock, reset, boot address, and fetch enable.
2. **Implement C++ Harness**:
   - Location: `scripts/assets/safety_island/tb_safety_island.cpp`.
   - Implements clock generation, reset sequence, ELF parsing using `libelf` or hex memory reader.
   - Monitors `FetchEnAddr` and `CoreStatusAddr` (`0x0020_0000 + offset`) for completion.
3. **Build Script & Automation**:
   - Build command using `verilator --cc --exe --timing -Wno-fatal`.
   - Create runner `scripts/benchmarks/run_safety_island_benchmarks.sh`.
4. **Validation & Benchmark Output**:
   - Run `runtime_coremark` on the dual-core lockstep Ibex.
   - Emit `datasets/safety_island/584eb697/benchmarks/coremark_default.json`.
   - Update `benchmarks/soc/suite.json` and `benchmarks/soc/aggregated_results.json`.

---

## Phase 2: PULP Cluster (`tools/pulp-cluster`)

### 2.1 Architecture & Scope
- **Upstream Location**: `tools/pulp-cluster/` (Commit `caaa9735`)
- **Core Architecture**: Multi-core (8x to 16x) **CV32E40P** (or Snitch) with tightly coupled data memory (TCDM), logarithmic interconnect, and hardware synchronization barrier.
- **Why it was blocked on commercial EDA**: Upstream `Makefile` uses `vsim -do wave.do`.
- **Key Advantage**: Upstream `tb/dpi/` **already contains** `elfloader.cpp` and `mock_uart.sv`!

### 2.2 Implementation Steps
1. **Harness Integration**:
   - Adapt `tb/pulp_cluster_tb.sv` to bypass Questa-specific `$dumpvars` and integrate with Verilator.
   - Wire `tb/dpi/elfloader.cpp` into a Verilator C++ testbench main loop.
2. **Workload Benchmarks**:
   - Multi-core parallel matrix multiplication ($16 \times 16$).
   - 8-core synchronization barrier benchmark.
   - Parallel 1D FIR filter.
3. **Output & Aggregation**:
   - Emit schema-compliant `datasets/pulp_cluster/<commit>/benchmarks/*.json`.

---

## Phase 3: Chimera (`tools/chimera`)

### 3.1 Architecture & Scope
- **Upstream Location**: `tools/chimera/` (Commit `208b36ef`)
- **Core Architecture**: Heterogeneous microcontroller SoC integrating compute clusters and dedicated hardware accelerators (HWPE / iDMA).
- **Blocking Items**: `target/sim/sim.mk` only defines `VSIM_DIR ?= $(CHIM_ROOT)/target/sim/vsim` and `vsim compile.tcl`.

### 3.2 Implementation Steps
1. **Bender Verilator Filelist**:
   - Run `bender script flist-plus -t verilator` to extract synthesizable RTL sources.
2. **Verilator Testbench Wrapper**:
   - Construct `tb_chimera_verilator.sv` with AXI memory responder.
   - Provide C++ driver with DPI ELF loading and UART trap capture.
3. **Benchmark Execution**:
   - Run `helloworld` and `idma_transfer` tests from `sw/`.
   - Emit benchmark JSON results.

---

## Phase 4: MAGIA & Picobello (`tools/magia`, `tools/picobello`)

### 4.1 Architecture & Scope
- **Upstream Location**: `tools/magia/` (Commit `4a45e25a`), `tools/picobello/` (Commit `71df12a2`)
- **Core Architecture**:
  - **MAGIA**: Large-scale Generative AI accelerator; network of tiles with **RedMulE** FP16 matrix-multiply accelerators, **iDMA**, L1 scratchpad, and **FlooNoC** 2D mesh interconnect.
  - **Picobello**: AI/ML research acceleration platform.
- **Blocking Items**: Deep UVM / QuestaSim simulation infrastructure (`vopt_tb`, `vsim -c`).

### 4.2 Implementation Steps
1. **Tile-Level Slice Isolation**:
   - Isolate single-tile / 2x2 mesh configuration in `src/occamy_cfg.hjson` or MAGIA configuration.
2. **FlooNoC Verilator Compatibility**:
   - Verify FlooNoC routers and network interfaces elaborate cleanly under Verilator.
3. **GeMM Execution**:
   - Execute quantized FP16 matrix multiplication on RedMulE tile.
   - Capture throughput (FLOP/cycle) and vector utilization.

---

## Phase 5: Carfield & Astral Full-SoC (`tools/carfield`, `tools/astral`)

### 5.1 Architecture & Scope
- **Upstream Location**: `tools/carfield/` (Commit `ee168c59`), `tools/astral/` (Commit `f97f001b`)
- **Core Architecture**: The flagship heterogeneous automotive SoC:
  - 64-bit CVA6 application processor (host domain via Cheshire)
  - PULP multi-core accelerator cluster
  - Safety Island (dual lockstep Ibex)
  - AXI crossbar & peripheral subsystem (CAN, UART, SPI, I2C, GPIO)
- **Blocking Items**:
  - Upstream only supports `make car-vsim-sim-build` / `make car-vsim-sim-run`.
  - Non-synthesizable VHDL Bosch CAN controller (`can_bus`).
  - Complex multi-clock power domains and SVA assertions.

### 5.2 Implementation Steps
1. **Peripheral Stubbing**:
   - Create SystemVerilog dummy stubs for the mixed-language VHDL CAN controller and external PHYs so Verilator has pure SystemVerilog closure.
2. **Subsystem Reuse**:
   - Leverage the Verilator drivers built in Phase 1 (Safety Island) and Phase 2 (PULP Cluster).
3. **Full-SoC Boot & Workload**:
   - Compile Carfield top-level Verilator model (`Vcarfield_soc`).
   - Run CVA6 host boot code (`sw/tests/bare-metal/hostd/helloworld.car.l2.elf`).
   - Verify cross-domain message passing between CVA6 host and Safety Island.

---

## Acceptance Criteria for Every Phase

Every converted platform must satisfy the strict SCORE benchmarking standards:
1. **Zero Fake Data**:
   - Every metric (cycles, instructions, runtime, throughput) must originate from a verified simulation run.
2. **Schema Compliance**:
   - Emits valid `score.benchmark_results.v1` JSON files under `datasets/<platform>/<commit>/benchmarks/`.
3. **Registry Synchronization**:
   - Updated in `benchmarks/soc/suite.json`.
   - Aggregated into `benchmarks/soc/aggregated_results.json`.
   - Documented in `README.md` Category 4 table with verified checkmark (`✅`).
4. **Git & Submodule Cleanliness**:
   - Never stage internal submodule working directory modifications or modified submodule commit pointers in `tools/*`.
   - Host all Verilator testbench adapters in `scripts/assets/<platform>/` or as non-destructive additions.

---

## Execution Tracker

- [ ] **Phase 1: Safety Island Verilator Harness & CoreMark / UART Benchmarks**
- [ ] **Phase 2: PULP Cluster Verilator Harness & Multi-Core Parallel Kernels**
- [ ] **Phase 3: Chimera SoC Verilator Harness & DMA / Compute Benchmarks**
- [ ] **Phase 4: MAGIA / Picobello Tile Verilator Harness & RedMulE GeMM**
- [ ] **Phase 5: Carfield & Astral Full-SoC Verilator Boot & Multi-Domain Benchmarks**
