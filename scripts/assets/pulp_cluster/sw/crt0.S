/* Copyright 2026 SCORE Project.
 * Minimal multi-core baremetal crt0.S for 8-core PULP Cluster (CV32E40P/RI5CY).
 */

.section .vectors, "ax"
.option norvc
.org 0x0
    jal x0, _start
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler
    jal x0, default_handler

    /* Reset vector at offset 0x80 */
    .org 0x80
    jal x0, _start

.section .text._start, "ax"
.global _start
_start:
    /* Read mhartid CSR (0xF14 on PULP / CV32E40P) */
    csrr a0, 0xF14
    andi a0, a0, 0x1f             /* a0 = core_id (0..7) */

    /* Setup per-core stack in TCDM (128KB at 0x1000_0000) */
    /* Each core gets 8KB: stack_top = 0x10002000 + core_id * 0x2000 */
    li   t0, 0x10002000
    li   t1, 0x2000
    mul  t2, a0, t1
    add  sp, t0, t2

    /* Core 0 initializes BSS and release flags */
    bnez a0, .L_wait_bss

    la   t0, __bss_start
    la   t1, __bss_end
1:
    bgeu t0, t1, 2f
    sw   zero, 0(t0)
    addi t0, t0, 4
    j    1b
2:
    /* Signal non-zero cores that BSS is ready */
    li   t0, 0x10010000           /* TCDM sync flag */
    li   t1, 1
    sw   t1, 0(t0)
    j    .L_run_main

.L_wait_bss:
    li   t0, 0x10010000
3:
    lw   t1, 0(t0)
    beqz t1, 3b

.L_run_main:
    /* Call main(int core_id, int num_cores) */
    mv   s0, a0                   /* save core_id */
    mv   a0, s0                   /* arg0 = core_id */
    li   a1, 8                    /* arg1 = num_cores */
    call main

    /* If Core 0, write return code and trigger EOC */
    bnez s0, .L_hang

    /* 0x10200100 is ClustReturnInt */
    li   t0, 0x10200100
    sw   a0, 0(t0)

    /* 0x10200000 is EOC register (bit 0 = 1) */
    li   t0, 0x10200000
    li   t1, 1
    sw   t1, 0(t0)

.L_hang:
    wfi
    j    .L_hang

default_handler:
    mret
