#ifndef CORE_PORTME_H
#define CORE_PORTME_H

#include <stdint.h>
#include <stddef.h>

#define HAS_FLOAT 0
#define HAS_TIME_H 0
#define USE_CLOCK 0
#define HAS_STDIO 1
#define HAS_PRINTF 1

#define CORE_TICKS uintptr_t
#define ee_u8 uint8_t
#define ee_u16 uint16_t
#define ee_u32 uint32_t
#define ee_s16 int16_t
#define ee_s32 int32_t
#define ee_ptr_int uintptr_t
#define ee_size_t size_t

#define COMPILER_VERSION "GCC 13.2.0"
#define COMPILER_FLAGS "-O3"
#define MEM_LOCATION "STACK"
#define SC_MEM_LOCATION "STACK"

#define SEED_METHOD 1
#define MEM_METHOD 1
#define MULTITHREAD 1

extern int printf(const char *format, ...);
#define ee_printf printf

#define align_mem(x) (void *)(4 + (((ee_ptr_int)(x)-1) & ~3))
#define CORETIMETYPE ee_u32

typedef struct CORE_PORTABLE_S {
    ee_u8 portable_id;
} core_portable;

void portable_init(core_portable *p, int *argc, char *argv[]);
void portable_fini(core_portable *p);

#endif
