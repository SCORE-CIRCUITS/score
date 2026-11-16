#include <stdio.h>
#include <stdlib.h>

#define M 32
#define K 32
#define N 32

static int A[M][K];
static int B[K][N];
static int C[M][N];

int main(void) {
    for (int i = 0; i < M; i++) {
        for (int k = 0; k < K; k++) {
            A[i][k] = (i + k) & 0x1F;
        }
    }
    for (int k = 0; k < K; k++) {
        for (int j = 0; j < N; j++) {
            B[k][j] = (k * 2 + j) & 0x1F;
        }
    }

    int check = 0;
    for (int i = 0; i < M; i++) {
        for (int j = 0; j < N; j++) {
            int acc = 0;
            for (int k = 0; k < K; k++) {
                acc += A[i][k] * B[k][j];
            }
            C[i][j] = acc;
            check += acc;
        }
    }

    printf("MATMUL CHECK: %d\n", check);
    return 0;
}
