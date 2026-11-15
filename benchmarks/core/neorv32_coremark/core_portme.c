#include "coremark.h"
#include "core_portme.h"
#include <neorv32.h>

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

void start_time(void) {
    start_time_val = (CORETIMETYPE)neorv32_cpu_get_cycle();
}

void stop_time(void) {
    stop_time_val = (CORETIMETYPE)neorv32_cpu_get_cycle();
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
    neorv32_uart0_setup(19200, 0);
    NEORV32_UART0->CTRL |= (1U << UART_CTRL_SIM_MODE);
    p->portable_id = 1;
}

void portable_fini(core_portable *p) {
    p->portable_id = 0;
}
