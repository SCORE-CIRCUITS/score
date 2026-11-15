    .section .text
    .global start
    .global main

start:
    /* Set stack pointer to top of 256KB RAM (below 0x40000) */
    lui sp, 0x3F
    addi sp, sp, 0x0

    /* Clear BSS */
    la a0, __bss_start
    la a1, __bss_end
bss_clear_loop:
    bgeu a0, a1, bss_clear_done
    sw zero, 0(a0)
    addi a0, a0, 4
    j bss_clear_loop
bss_clear_done:

    /* Jump to CoreMark main() */
    jal ra, main

    /* Trap on completion */
    ebreak
1:  j 1b

