# Hwacha Decoupled Vector-Fetch Coprocessor Documentation

![License: BSD 3-Clause](https://img.shields.io/badge/license-BSD%203--Clause-blue)
![Archetype: Archetype 5 - Decoupled Access-Execute](https://img.shields.io/badge/Archetype-Decoupled%20Access--Execute%20(DAE)-purple)

This document details the **UC Berkeley Hwacha** vector-thread coprocessor, serving as a historical pioneer and architectural reference for **Archetype 5: Decoupled Access-Execute (DAE) Streaming Vector Engines** in the SCORE Taxonomy.

---

## 1. Overview & Architectural Role

* **Repository Location:** [`tools/hwacha/`](file:///home/yongfu/proj/score/tools/hwacha)
* **Upstream Source:** [github.com/ucb-bar/hwacha](https://github.com/ucb-bar/hwacha)
* **Design Language:** Chisel (Scala)
* **Coupling Interface:** RoCC (Rocket Custom Coprocessor Interface) attached to Rocket Chip or BOOM
* **Key Papers:**
  * Lee et al., *"The Hwacha Vector-Fetch Architecture Manual"*, UC Berkeley EECS Technical Report UCB/EECS-2015-262.
  * Lee et al., *"Space-Time Multiplexing of SMT Workloads on Vector Microarchitectures"*, ISCA 2014.

### Architectural Mechanism: Decoupled Access-Execute (DAE) & Vector-Fetch
Hwacha decouples memory access from vector arithmetic execution:
1. **Vector Command Queue:** The host Rocket core offloads high-level vector commands (`vsetcfg`, `vf`) into Hwacha's non-blocking command queue without stalling the scalar pipeline.
2. **Autonomous Vector Sequencer & Prefetcher:** Hwacha fetches micro-threads autonomously and streams operands into dedicated execution lanes.
3. **Decoupled Lane Datapath:** Arithmetic units execute micro-operations buffered in deep operand FIFOs, completely hiding memory latency and mitigating the scalar host instruction-issue wall that throttles traditional in-order vector coprocessors.

---

## 2. Directory Structure in `tools/hwacha`

```
tools/hwacha/
├── src/main/scala/
│   ├── Hwacha.scala          # Top-level RoCC module wrapper
│   ├── Sequencer.scala       # Micro-thread instruction sequencer
│   ├── Lane.scala            # Parallel vector lane datapath
│   ├── RegFile.scala         # Banked vector register file
│   ├── VLU.scala             # Vector Load Unit (decoupled address generator)
│   ├── VSU.scala             # Vector Store Unit
│   └── VXU.scala             # Vector Execution Unit (ALU, FPU, Multiplier)
```

---

## 3. The Utilization Collapse Resolution: Why DAE Matters

In the SCORE benchmark suite, standard in-order vector coprocessors (like Ara) experience **Utilization Collapse** on non-unit-stride or reduction-heavy kernels (e.g. Softmax drops to 23.0% utilization) because the scalar host core cannot decode and dispatch instructions fast enough.

Hwacha solves this through:
* **Vector-Thread Expansion:** One scalar instruction triggers an entire block of vectorized micro-threads autonomously.
* **Elastic FIFO Decoupling:** Memory access units (VLU) run ahead of compute units (VXU), filling queues before arithmetic begins.

---

## 4. Modern Peer in SCORE: Snitch SSR

While Hwacha used a custom pre-RVV vector ISA and was archived when modern Chipyard transitioned to RVV 1.0, its architectural principles are directly inherited by **Snitch + Stream Semantic Registers (SSR)** (located in [`tools/snitch-cluster/`](file:///home/yongfu/proj/score/tools/snitch-cluster)).
