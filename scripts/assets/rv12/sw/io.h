#ifndef RV12_IO_H
#define RV12_IO_H

#include <stdint.h>
#include <stddef.h>

int putchar(int c);
int puts(const char *s);
void print_hex(uint32_t val, int digits);
void print_dec(uint32_t val);
void exit_sim(int code);

void *memcpy(void *dest, const void *src, size_t n);
void *memset(void *s, int c, size_t n);
int memcmp(const void *s1, const void *s2, size_t n);
size_t strlen(const char *s);
char *strcpy(char *dest, const char *src);
int strcmp(const char *s1, const char *s2);

#endif
