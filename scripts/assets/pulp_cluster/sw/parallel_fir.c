/* Copyright 2026 SCORE Project.
 * 8-Core Parallel FIR Filter for PULP Cluster.
 */

#include "pulp_cluster.h"

#define NUM_SAMPLES 256
#define NUM_TAPS    16

int32_t signal_in[NUM_SAMPLES];
int32_t fir_taps[NUM_TAPS];
int32_t signal_out[NUM_SAMPLES];

int main(int core_id, int num_cores) {
    if (core_id == 0) {
        print_str("\n[PULP CLUSTER] 8-Core Parallel FIR Filter Starting...\n");
        // Initialize signal and taps
        for (int i = 0; i < NUM_SAMPLES; i++) {
            signal_in[i] = (i * 3 + 7) & 0x1F;
            signal_out[i] = 0;
        }
        for (int t = 0; t < NUM_TAPS; t++) {
            fir_taps[t] = (t + 1);
        }
    }

    // Barrier before computation
    cluster_barrier(core_id, num_cores);

    // Each core filters (NUM_SAMPLES / num_cores) = 32 samples
    int samples_per_core = NUM_SAMPLES / num_cores;
    int start_s = core_id * samples_per_core;
    int end_s = start_s + samples_per_core;

    for (int i = start_s; i < end_s; i++) {
        int32_t acc = 0;
        for (int t = 0; t < NUM_TAPS; t++) {
            if (i >= t) {
                acc += signal_in[i - t] * fir_taps[t];
            }
        }
        signal_out[i] = acc;
    }

    // Barrier after computation
    cluster_barrier(core_id, num_cores);

    if (core_id == 0) {
        int errors = 0;
        for (int i = 0; i < NUM_SAMPLES; i++) {
            int32_t expected = 0;
            for (int t = 0; t < NUM_TAPS; t++) {
                if (i >= t) {
                    expected += signal_in[i - t] * fir_taps[t];
                }
            }
            if (signal_out[i] != expected) {
                errors++;
            }
        }

        print_str("[PULP CLUSTER] FIR Filter Verification: ");
        if (errors == 0) {
            print_str("PASSED! (All 256 output samples match reference)\n");
            return 0;
        } else {
            print_str("FAILED! Error count = ");
            print_dec(errors);
            print_str("\n");
            return 1;
        }
    }

    return 0;
}
