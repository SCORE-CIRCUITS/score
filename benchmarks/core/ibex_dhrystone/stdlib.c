// Freestanding stdlib and IO stubs for Ibex Simple System Dhrystone benchmark
#include <stdarg.h>
#include <stdint.h>
#include "simple_system_regs.h"

#define DEV_WRITE(addr, val) (*((volatile uint32_t *)(addr)) = val)

extern long time();
extern long insn();

extern char *malloc();
extern int printf(const char *format, ...);
extern void *memcpy(void *dest, const void *src, long n);
extern char *strcpy(char *dest, const char *src);
extern int strcmp(const char *s1, const char *s2);

char heap_memory[4096];
int heap_memory_used = 0;

long time()
{
    int cycles;
    asm volatile ("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

long insn()
{
    int insns;
    asm volatile ("csrr %0, minstret" : "=r"(insns));
    return insns;
}

char *malloc(int size)
{
    char *p = heap_memory + heap_memory_used;
    heap_memory_used += (size + 3) & ~3;
    if (heap_memory_used > sizeof(heap_memory)) {
        DEV_WRITE(SIM_CTRL_BASE + SIM_CTRL_CTRL, 1);
        while (1);
    }
    return p;
}

static void printf_c(int c)
{
    DEV_WRITE(SIM_CTRL_BASE + SIM_CTRL_OUT, (unsigned char)c);
}

static void printf_s(char *p)
{
    while (*p)
        DEV_WRITE(SIM_CTRL_BASE + SIM_CTRL_OUT, (unsigned char)*(p++));
}

static void printf_d(int val)
{
    char buffer[32];
    char *p = buffer;
    if (val < 0) {
        printf_c('-');
        val = -val;
    }
    while (val || p == buffer) {
        *(p++) = '0' + val % 10;
        val = val / 10;
    }
    while (p != buffer)
        printf_c(*(--p));
}

int printf(const char *format, ...)
{
    int i;
    va_list ap;

    va_start(ap, format);

    for (i = 0; format[i]; i++) {
        if (format[i] == '%') {
            while (format[++i]) {
                if (format[i] == 'l' || format[i] == 'u')
                    continue;
                if (format[i] == 'c') {
                    printf_c(va_arg(ap, int));
                    break;
                }
                if (format[i] == 's') {
                    printf_s(va_arg(ap, char*));
                    break;
                }
                if (format[i] == 'd') {
                    printf_d(va_arg(ap, int));
                    break;
                }
            }
        } else {
            printf_c(format[i]);
        }
    }

    va_end(ap);
    return 0;
}

void *memcpy(void *aa, const void *bb, long n)
{
    char *a = aa;
    const char *b = bb;
    while (n--) *(a++) = *(b++);
    return aa;
}

char *strcpy(char* dst, const char* src)
{
    char *r = dst;
    while (*src) {
        *(dst++) = *(src++);
    }
    *dst = 0;
    return r;
}

int strcmp(const char *s1, const char *s2)
{
    while (*s1 && *s1 == *s2) {
        s1++;
        s2++;
    }
    return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}
