/* Copyright 2026 SCORE Project.
 * CoreMark port implementation for Safety Island (CV32E40P).
 */

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
volatile ee_s32 seed4_volatile = ITERATIONS;
volatile ee_s32 seed5_volatile = 0;

static inline ee_u32 read_csr_mcycle(void) {
    ee_u32 val;
    __asm__ volatile ("csrr %0, mcycle" : "=r"(val));
    return val;
}

static inline ee_u32 read_csr_minstret(void) {
    ee_u32 val;
    __asm__ volatile ("csrr %0, minstret" : "=r"(val));
    return val;
}

CORETIMETYPE barebones_clock(void) {
    return read_csr_mcycle();
}

#define TIMER_RES_DIVIDER 1
#define SAMPLE_TIME_IMPLEMENTATION 1
#define EE_TICKS_PER_SEC 10000 /* Simulating 10 kHz for RTL simulation validation */

static CORETIMETYPE start_time_val, stop_time_val;
static ee_u32 start_inst_val, stop_inst_val;

void start_time(void) {
    start_time_val = barebones_clock();
    start_inst_val = read_csr_minstret();
}

void stop_time(void) {
    stop_time_val = barebones_clock();
    stop_inst_val = read_csr_minstret();
}

CORE_TICKS get_time(void) {
    return (CORE_TICKS)(stop_time_val - start_time_val);
}

secs_ret time_in_secs(CORE_TICKS ticks) {
    secs_ret retval = ((secs_ret)ticks) / (secs_ret)EE_TICKS_PER_SEC;
    return retval;
}

ee_u32 default_num_contexts = 1;

void portable_init(core_portable *p, int *argc, char *argv[]) {
    (void)argc;
    (void)argv;
    p->portable_id = 1;
}

void portable_fini(core_portable *p) {
    ee_u32 total_cycles = stop_time_val - start_time_val;
    ee_u32 total_instr  = stop_inst_val - start_inst_val;
    ee_printf("\n[ROALOGIC RV12 BENCHMARK METRICS]\n");
    ee_printf("Total execution cycles: %u\n", total_cycles);
    ee_printf("Total retired instructions: %u\n", total_instr);
    if (total_cycles > 0) {
        ee_printf("CPI: %u.%02u\n", total_cycles / total_instr,
                  ((total_cycles * 100) / total_instr) % 100);
    }
    p->portable_id = 0;
}
