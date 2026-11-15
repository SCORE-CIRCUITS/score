#include "coremark.h"

ee_u32 default_num_contexts = 1;
volatile ee_s32 seed1_volatile = 0x0;
volatile ee_s32 seed2_volatile = 0x0;
volatile ee_s32 seed3_volatile = 0x66;
volatile ee_s32 seed4_volatile = 1;
volatile ee_s32 seed5_volatile = 0;

void portable_init(core_portable *p, int *argc, char *argv[]) {}
void portable_fini(core_portable *p) {}

void start_time(void) {}
void stop_time(void) {}

CORE_TICKS get_time(void) {
    uintptr_t c;
    asm volatile ("csrr %0, mcycle" : "=r"(c));
    return c;
}

secs_ret time_in_secs(CORE_TICKS ticks) {
    return ((secs_ret)ticks) / 1000000;
}
