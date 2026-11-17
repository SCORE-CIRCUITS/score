/* Copyright 2026 SCORE Project.
 * Baremetal crt0.S for RoaLogic RV12.
 */

.section .text._start, "ax"
.global _start
_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

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

    /* Write return code to TOHOST at 0x80100008 */
    /* tohost format: (exit_code << 1) | 1 */
    slli a0, a0, 1
    ori  a0, a0, 1
    li   t0, 0x80100008
    sw   a0, 0(t0)

3:  wfi
    j 3b

.global exit
exit:
    slli a0, a0, 1
    ori  a0, a0, 1
    li   t0, 0x80100008
    sw   a0, 0(t0)
4:  wfi
    j 4b
