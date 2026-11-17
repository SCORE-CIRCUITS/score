#include "io.h"

int test_alu(void) {
    puts("Testing ALU...");
    volatile int a = 12345;
    volatile int b = -6789;
    if (a + b != (12345 - 6789)) { puts("FAIL: add"); return 1; }
    if (a - b != (12345 + 6789)) { puts("FAIL: sub"); return 1; }
    if ((a < b) != 0) { puts("FAIL: slt"); return 1; }
    if (((unsigned)a < (unsigned)b) != 1) { puts("FAIL: sltu"); return 1; }
    if ((a ^ b) != (12345 ^ -6789)) { puts("FAIL: xor"); return 1; }
    if ((a | b) != (12345 | -6789)) { puts("FAIL: or"); return 1; }
    if ((a & b) != (12345 & -6789)) { puts("FAIL: and"); return 1; }
    if ((a << 4) != (12345 << 4)) { puts("FAIL: sll"); return 1; }
    if ((b >> 4) != (-6789 >> 4)) { puts("FAIL: sra"); return 1; }
    if (((unsigned)b >> 4) != ((unsigned)-6789 >> 4)) { puts("FAIL: srl"); return 1; }
    puts("ALU: PASS");
    return 0;
}

int test_mul(void) {
    puts("Testing MUL...");
    volatile int32_t a = 123456;
    volatile int32_t b = -78901;
    volatile int64_t expected = (int64_t)a * (int64_t)b;
    volatile int32_t low = a * b;
    if (low != (int32_t)expected) {
        puts("FAIL: mul");
        print_hex(low, 8); puts(" vs expected "); print_hex((uint32_t)expected, 8);
        return 1;
    }
    // Test mulh
    int32_t hi;
    __asm__ volatile ("mulh %0, %1, %2" : "=r"(hi) : "r"(a), "r"(b));
    if (hi != (int32_t)(expected >> 32)) {
        puts("FAIL: mulh");
        print_hex(hi, 8); puts(" vs expected "); print_hex((uint32_t)(expected >> 32), 8);
        return 1;
    }
    // Test mulhu
    uint32_t ua = 0x87654321;
    uint32_t ub = 0x12345678;
    uint64_t uexpected = (uint64_t)ua * (uint64_t)ub;
    uint32_t uhi;
    __asm__ volatile ("mulhu %0, %1, %2" : "=r"(uhi) : "r"(ua), "r"(ub));
    if (uhi != (uint32_t)(uexpected >> 32)) {
        puts("FAIL: mulhu");
        return 1;
    }
    puts("MUL: PASS");
    return 0;
}

int test_div(void) {
    puts("Testing DIV...");
    volatile int32_t a = -123456;
    volatile int32_t b = 789;
    if (a / b != (-123456 / 789)) { puts("FAIL: div"); return 1; }
    if (a % b != (-123456 % 789)) { puts("FAIL: rem"); return 1; }
    volatile uint32_t ua = 123456789;
    volatile uint32_t ub = 789;
    if (ua / ub != (123456789u / 789u)) { puts("FAIL: divu"); return 1; }
    if (ua % ub != (123456789u % 789u)) { puts("FAIL: remu"); return 1; }
    puts("DIV: PASS");
    return 0;
}

volatile uint8_t mem_buf[64] __attribute__((aligned(16)));

int test_mem(void) {
    puts("Testing MEM (byte/hword/word)...");
    for (int i = 0; i < 64; ++i) mem_buf[i] = 0;

    // Test byte stores
    for (int i = 0; i < 16; ++i) {
        mem_buf[i] = (uint8_t)(0x10 + i);
    }
    for (int i = 0; i < 16; ++i) {
        if (mem_buf[i] != (uint8_t)(0x10 + i)) {
            puts("FAIL: byte readback at index ");
            print_dec(i);
            puts(" got ");
            print_hex(mem_buf[i], 2);
            puts(" expected ");
            print_hex(0x10 + i, 2);
            return 1;
        }
    }

    // Test halfword stores
    volatile uint16_t *hptr = (volatile uint16_t *)(mem_buf + 16);
    for (int i = 0; i < 8; ++i) {
        hptr[i] = (uint16_t)(0x5500 + i);
    }
    for (int i = 0; i < 8; ++i) {
        if (hptr[i] != (uint16_t)(0x5500 + i)) {
            puts("FAIL: hword readback at index ");
            print_dec(i);
            return 1;
        }
    }

    // Test signed byte loads (lb)
    mem_buf[0] = 0xfe;
    volatile int8_t *sb = (volatile int8_t *)mem_buf;
    int32_t val = sb[0];
    if (val != -2) {
        puts("FAIL: lb sign extension");
        print_hex(val, 8);
        return 1;
    }

    // Test signed halfword loads (lh)
    volatile int16_t *sh = (volatile int16_t *)(mem_buf + 2);
    sh[0] = (int16_t)-1234;
    int32_t hval = sh[0];
    if (hval != -1234) {
        puts("FAIL: lh sign extension");
        return 1;
    }

    puts("MEM: PASS");
    return 0;
}

int main(void) {
    puts("=== RV12 Diagnostic Suite ===");
    if (test_alu()) return 1;
    if (test_mul()) return 2;
    if (test_div()) return 3;
    if (test_mem()) return 4;
    puts("=== All Tests Passed! ===");
    return 0;
}

