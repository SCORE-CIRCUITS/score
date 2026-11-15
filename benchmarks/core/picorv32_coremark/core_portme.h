#ifndef CORE_PORTME_H
#define CORE_PORTME_H

#include <stddef.h>
#include <stdint.h>

#define HAS_FLOAT 0
#define HAS_TIME_H 0
#define USE_CLOCK 0
#define HAS_STDIO 1
#define HAS_PRINTF 1

#define CORETIMETYPE uint32_t
typedef uint32_t ee_u32;
typedef uint16_t ee_u16;
typedef uint8_t  ee_u8;
typedef int32_t  ee_s32;
typedef int16_t  ee_s16;
typedef int8_t   ee_s8;
typedef uintptr_t ee_ptr_int;
typedef size_t   ee_size_t;

#define align_mem(x) (void *)(4 + (((ee_ptr_int)(x)-1) & ~3))

#ifndef COMPILER_FLAGS
#define COMPILER_FLAGS "-O3"
#endif

#ifndef COMPILER_VERSION
#define COMPILER_VERSION "GCC 10.2.0"
#endif

#ifndef MEM_LOCATION
#define MEM_LOCATION "STACK"
#endif

#ifndef SEED_METHOD
#define SEED_METHOD SEED_VOLATILE
#endif

#ifndef MEM_METHOD
#define MEM_METHOD MEM_STACK
#endif

#define MULTITHREAD 1
#define default_num_contexts 1

typedef struct CORE_PORTABLE_S {
    ee_u8 portable_id;
} core_portable;

#define NSECS_PER_SEC 100000000
#define CORE_TICKS CORETIMETYPE
#define TIMER_RES_DIVIDER 1
#define SAMPLE_TIME_IMPLEMENTATION 1
#define EE_TICKS_PER_SEC NSECS_PER_SEC

#if HAS_FLOAT
typedef double secs_ret;
#else
typedef ee_u32 secs_ret;
#endif

int ee_printf(const char *format, ...);
void start_time(void);
void stop_time(void);
CORE_TICKS get_time(void);
secs_ret time_in_secs(CORE_TICKS ticks);
void portable_init(core_portable *p, int *argc, char *argv[]);
void portable_fini(core_portable *p);
ee_u32 default_num_contexts_func(void);

#endif /* CORE_PORTME_H */
