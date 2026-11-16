/* Copyright 2026 SCORE Project.
 * Minimal baremetal crt0.S for Safety Island (CV32E40P).
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

    .org 0x80
.section .text._start, "ax"
.global _start
_start:
    /* Set stack pointer */
    la sp, __stack_top

    /* Zero BSS */
    la t0, __bss_start
    la t1, __bss_end
1:
    bgeu t0, t1, 2f
    sw zero, 0(t0)
    addi t0, t0, 4
    j 1b
2:

    /* Call main */
    call main

    /* Terminate: write return code to CoreStatus register (0x00200008) */
    /* Bit 31 = 1 indicates completion, [30:0] = exit code */
    li t0, 0x00200008
    li t1, 0x80000000
    or t1, t1, a0
    sw t1, 0(t0)

3:  wfi
    j 3b

default_handler:
    mret
