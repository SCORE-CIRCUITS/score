/* Copyright 2026 SCORE Project.
 * 8-Core Parallel Hello & Barrier Test for PULP Cluster.
 */

#include "pulp_cluster.h"

volatile uint32_t core_results[8] = {0};

int main(int core_id, int num_cores) {
    if (core_id == 0) {
        print_str("\n[PULP CLUSTER] 8-Core Parallel Hello World Starting...\n");
        print_str("[PULP CLUSTER] Running on 8 CV32E40P cores with 128KB TCDM.\n");
    }

    // Mark this core as alive
    core_results[core_id] = 0x1000 + core_id;

    // Synchronize all 8 cores
    cluster_barrier(core_id, num_cores);

    if (core_id == 0) {
        int all_ok = 1;
        for (int i = 0; i < num_cores; i++) {
            print_str("  Core ");
            print_dec(i);
            print_str(": Active, status = ");
            print_hex(core_results[i]);
            print_str("\n");
            if (core_results[i] != (0x1000 + i)) {
                all_ok = 0;
            }
        }

        if (all_ok) {
            print_str("[PULP CLUSTER] All 8 cores passed synchronization barrier successfully!\n");
            return 0;
        } else {
            print_str("[PULP CLUSTER] ERROR: Core verification mismatch!\n");
            return 1;
        }
    }

    return 0;
}
