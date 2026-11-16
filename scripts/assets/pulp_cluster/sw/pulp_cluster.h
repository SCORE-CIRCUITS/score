/* Copyright 2026 SCORE Project.
 * Baremetal utility header for 8-core PULP Cluster.
 */

#ifndef PULP_CLUSTER_H
#define PULP_CLUSTER_H

#include <stdint.h>

#define UART_BASE         0x03002000
#define CLUST_CTRL_BASE   0x10200000
#define EOC_REG           (CLUST_CTRL_BASE + 0x000)
#define FETCH_EN_REG      (CLUST_CTRL_BASE + 0x008)
#define RETURN_REG        (CLUST_CTRL_BASE + 0x100)

/* UART output functions */
static inline void uart_putchar(char c) {
    volatile uint32_t *uart_thr = (volatile uint32_t *)UART_BASE;
    *uart_thr = (uint32_t)(uint8_t)c;
}

static inline void print_str(const char *s) {
    while (*s) {
        uart_putchar(*s++);
    }
}

static inline void print_dec(int val) {
    if (val < 0) {
        uart_putchar('-');
        val = -val;
    }
    if (val == 0) {
        uart_putchar('0');
        return;
    }
    char buf[12];
    int idx = 0;
    while (val > 0) {
        buf[idx++] = '0' + (val % 10);
        val /= 10;
    }
    for (int i = idx - 1; i >= 0; i--) {
        uart_putchar(buf[i]);
    }
}

static inline void print_hex(uint32_t val) {
    const char hex_chars[] = "0123456789ABCDEF";
    print_str("0x");
    for (int i = 7; i >= 0; i--) {
        uart_putchar(hex_chars[(val >> (i * 4)) & 0xF]);
    }
}

/* Fast Multi-Core Barrier in Shared TCDM (0x10010000) */
/* Volatile flags array for 8 cores */
#define BARRIER_FLAGS_BASE 0x10010100

static inline void cluster_barrier(int core_id, int num_cores) {
    volatile uint32_t *flags = (volatile uint32_t *)BARRIER_FLAGS_BASE;

    flags[core_id] = 1;

    if (core_id == 0) {
        for (int i = 1; i < num_cores; i++) {
            while (flags[i] == 0) {
                asm volatile ("" : : : "memory");
            }
        }
        for (int i = 1; i < num_cores; i++) {
            flags[i] = 2; // release
        }
        flags[0] = 0;
    } else {
        while (flags[core_id] != 2) {
            asm volatile ("" : : : "memory");
        }
        flags[core_id] = 0;
    }
}

#endif /* PULP_CLUSTER_H */
