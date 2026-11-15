    .section .text
    .global _start
    .global main

_start:
    /* Set stack pointer to top of RAM (below 64KB) */
    lui sp, 0x0F
    addi sp, sp, 0

    /* Clear BSS */
    la a0, __bss_start
    la a1, __bss_end
1:  bgeu a0, a1, 2f
    sw zero, 0(a0)
    addi a0, a0, 4
    j 1b
2:
    /* Call CoreMark main */
    jal ra, main

    /* Halt simulation via servile_mux at 0x90000000 */
    li t0, 0x90000000
    sw zero, 0(t0)
3:  j 3b

