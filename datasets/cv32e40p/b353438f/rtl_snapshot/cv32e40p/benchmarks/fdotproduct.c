#include <stdio.h>
#include <stdlib.h>

#define N 1024
static int a[N];
static int b[N];

int main(void) {
    for (int i = 0; i < N; i++) {
        a[i] = (i & 0x7F) - 64;
        b[i] = ((i * 3) & 0x7F) - 64;
    }

    int sum = 0;
    for (int i = 0; i < N; i++) {
        sum += a[i] * b[i];
    }

    printf("DOTPRODUCT SUM: %d\n", sum);
    return 0;
}
