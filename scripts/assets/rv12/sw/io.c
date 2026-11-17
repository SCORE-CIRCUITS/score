/* Copyright 2026 SCORE Project.
 * IO support for RoaLogic RV12 Verilator simulation.
 */

#include <stdint.h>
#include <stddef.h>

#define UART_TX_ADDR   ((volatile uint32_t *)0x80100000)
#define TOHOST_ADDR    ((volatile uint32_t *)0x80100008)

int putchar(int c) {
    *UART_TX_ADDR = (uint32_t)(uint8_t)c;
    return c;
}

int puts(const char *s) {
    while (*s) {
        putchar(*s++);
    }
    putchar('\n');
    return 0;
}

void print_hex(uint32_t val, int digits) {
    for (int i = (digits - 1) * 4; i >= 0; i -= 4) {
        uint32_t nibble = (val >> i) & 0xF;
        putchar(nibble < 10 ? '0' + nibble : 'a' + nibble - 10);
    }
}

void print_dec(uint32_t val) {
    char buf[12];
    int i = 0;
    if (val == 0) {
        putchar('0');
        return;
    }
    while (val > 0) {
        buf[i++] = '0' + (val % 10);
        val /= 10;
    }
    while (i > 0) {
        putchar(buf[--i]);
    }
}

void *memcpy(void *dest, const void *src, size_t n) {
    uint8_t *d = (uint8_t *)dest;
    const uint8_t *s = (const uint8_t *)src;
    while (n--) {
        *d++ = *s++;
    }
    return dest;
}

void *memset(void *s, int c, size_t n) {
    uint8_t *p = (uint8_t *)s;
    while (n--) {
        *p++ = (uint8_t)c;
    }
    return s;
}

int memcmp(const void *s1, const void *s2, size_t n) {
    const uint8_t *p1 = (const uint8_t *)s1;
    const uint8_t *p2 = (const uint8_t *)s2;
    while (n--) {
        if (*p1 != *p2) return *p1 - *p2;
        p1++;
        p2++;
    }
    return 0;
}

size_t strlen(const char *s) {
    size_t len = 0;
    while (*s++) len++;
    return len;
}

char *strcpy(char *dest, const char *src) {
    char *d = dest;
    while ((*d++ = *src++));
    return dest;
}

int strcmp(const char *s1, const char *s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(const unsigned char *)s1 - *(const unsigned char *)s2;
}

void exit_sim(int code) {
    *TOHOST_ADDR = ((uint32_t)code << 1) | 1u;
    for (;;) {
        __asm__ volatile ("wfi");
    }
}
