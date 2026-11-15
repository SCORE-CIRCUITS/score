#include "coremark.h"
#include "core_portme.h"

#if VALIDATION_RUN
volatile ee_s32 seed1_volatile = 0x3415;
volatile ee_s32 seed2_volatile = 0x3415;
volatile ee_s32 seed3_volatile = 0x66;
#endif
#if PERFORMANCE_RUN
volatile ee_s32 seed1_volatile = 0x0;
volatile ee_s32 seed2_volatile = 0x0;
volatile ee_s32 seed3_volatile = 0x66;
#endif
#if PROFILE_RUN
volatile ee_s32 seed1_volatile = 0x8;
volatile ee_s32 seed2_volatile = 0x8;
volatile ee_s32 seed3_volatile = 0x8;
#endif

#ifndef ITERATIONS
#define ITERATIONS 1
#endif

volatile ee_s32 seed4_volatile = ITERATIONS;
volatile ee_s32 seed5_volatile = 0;

static CORETIMETYPE start_time_val;
static CORETIMETYPE stop_time_val;

/* Read timer mtime from servant_timer at 0x80000000 */
static inline uint32_t read_timer(void) {
    return *((volatile uint32_t *)0x80000000);
}

void start_time(void) {
    start_time_val = read_timer();
}

void stop_time(void) {
    stop_time_val = read_timer();
}

CORE_TICKS get_time(void) {
    return stop_time_val - start_time_val;
}

secs_ret time_in_secs(CORE_TICKS ticks) {
    secs_ret retval = ((secs_ret)ticks) / (secs_ret)EE_TICKS_PER_SEC;
    return retval;
}

void portable_init(core_portable *p, int *argc, char *argv[]) {
    (void)argc;
    (void)argv;
    p->portable_id = 1;
}

void portable_fini(core_portable *p) {
    p->portable_id = 0;
    *((volatile uint32_t *)0x90000000) = 0;
}

