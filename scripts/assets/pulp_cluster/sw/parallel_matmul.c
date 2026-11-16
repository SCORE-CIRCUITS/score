/* Copyright 2026 SCORE Project.
 * 8-Core Parallel Matrix Multiplication (16x16) for PULP Cluster.
 */

#include "pulp_cluster.h"

#define MAT_N 16

int32_t mat_a[MAT_N][MAT_N];
int32_t mat_b[MAT_N][MAT_N];
int32_t mat_c[MAT_N][MAT_N];

int main(int core_id, int num_cores) {
    if (core_id == 0) {
        print_str("\n[PULP CLUSTER] 8-Core Parallel 16x16 MatMul Starting...\n");
        // Initialize matrices
        for (int i = 0; i < MAT_N; i++) {
            for (int j = 0; j < MAT_N; j++) {
                mat_a[i][j] = (i + j) & 0x7;
                mat_b[i][j] = (i == j) ? 2 : 1;
                mat_c[i][j] = 0;
            }
        }
    }

    // Barrier before computation
    cluster_barrier(core_id, num_cores);

    // Each core computes (MAT_N / num_cores) = 2 rows
    int rows_per_core = MAT_N / num_cores;
    int start_row = core_id * rows_per_core;
    int end_row = start_row + rows_per_core;

    for (int i = start_row; i < end_row; i++) {
        for (int j = 0; j < MAT_N; j++) {
            int32_t sum = 0;
            for (int k = 0; k < MAT_N; k++) {
                sum += mat_a[i][k] * mat_b[k][j];
            }
            mat_c[i][j] = sum;
        }
    }

    // Barrier after computation
    cluster_barrier(core_id, num_cores);

    if (core_id == 0) {
        int errors = 0;
        for (int i = 0; i < MAT_N; i++) {
            for (int j = 0; j < MAT_N; j++) {
                int32_t expected = 0;
                for (int k = 0; k < MAT_N; k++) {
                    expected += mat_a[i][k] * mat_b[k][j];
                }
                if (mat_c[i][j] != expected) {
                    errors++;
                }
            }
        }

        print_str("[PULP CLUSTER] MatMul Verification: ");
        if (errors == 0) {
            print_str("PASSED! (All 256 matrix elements match reference)\n");
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
