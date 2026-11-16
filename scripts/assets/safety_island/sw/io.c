/* Copyright 2026 SCORE Project.
 * IO support for Safety Island (TBPrintf at 0x00206000).
 */

#include <stdint.h>

#define TB_PRINTF_ADDR   ((volatile uint32_t *)0x00206000)
#define CORE_STATUS_ADDR ((volatile uint32_t *)0x00200008)

void putchar(char c) {
    *TB_PRINTF_ADDR = (uint32_t)c;
}

int puts(const char *s) {
    while (*s) {
        putchar(*s++);
    }
    putchar('\n');
    return 0;
}

void exit_sim(int code) {
    *CORE_STATUS_ADDR = (1u << 31) | (uint32_t)(code & 0x7FFFFFFF);
    for (;;) {
        __asm__ volatile ("wfi");
    }
}
