#include <stdint.h>

extern int printf(const char *format, ...);

void print_uart(const char *str) {
    printf("%s", str);
}

void init_uart(uint32_t freq, uint32_t baud) {
    (void)freq;
    (void)baud;
}

uintptr_t getStats(int counterid) {
    (void)counterid;
    uintptr_t c;
    asm volatile ("csrr %0, mcycle" : "=r"(c));
    return c;
}
