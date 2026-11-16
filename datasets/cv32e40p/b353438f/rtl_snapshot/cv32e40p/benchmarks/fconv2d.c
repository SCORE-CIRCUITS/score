#include <stdio.h>
#include <stdlib.h>

#define WIDTH 32
#define HEIGHT 32

static int in[HEIGHT][WIDTH];
static int out[HEIGHT - 2][WIDTH - 2];
static const int k[3][3] = {
    {1, 2, 1},
    {0, 0, 0},
    {-1, -2, -1}
};

int main(void) {
    for (int r = 0; r < HEIGHT; r++) {
        for (int c = 0; c < WIDTH; c++) {
            in[r][c] = (r + c) & 0x3F;
        }
    }

    int total = 0;
    for (int r = 0; r < HEIGHT - 2; r++) {
        for (int c = 0; c < WIDTH - 2; c++) {
            int acc = 0;
            for (int kr = 0; kr < 3; kr++) {
                for (int kc = 0; kc < 3; kc++) {
                    acc += in[r + kr][c + kc] * k[kr][kc];
                }
            }
            out[r][c] = acc;
            total += acc;
        }
    }

    printf("CONV2D TOTAL: %d\n", total);
    return 0;
}
