// Cycle-accurate Verilator simulation harness for Google XLS HLS/DSLX pipelines
// Benchmarks:
// 1. Pipelined Reduction Tree (32-bit, 3-stage, II=1)
// 2. Pipelined Multiplier (8-bit, 2-stage, II=1)
// 3. Valid/Ready Multiplexer (2-stage, backpressure & valid propagation)
// 4. Repeat Byte Word Expansion (combinational)
// 5. Streaming UART Loopback Coprocessor (baud-accurate 16 cycles/baud)

#include <iostream>
#include <iomanip>
#include <vector>
#include <deque>
#include <cstdint>
#include <cstdlib>
#include <chrono>
#include "Vtb_xls_top.h"
#include "verilated.h"

struct TreeVector {
    uint32_t a, b, c, d, e;
    uint32_t expected;
};

struct MulVector {
    uint8_t x, y;
    uint8_t expected;
};

struct ValVector {
    bool valid;
    uint8_t s;
    uint8_t x, y, z, a;
    uint8_t expected;
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    auto* top = new Vtb_xls_top;

    top->clk = 0;
    top->rst_n = 0;
    top->uart_rx = 1; // Idle high

    const uint64_t NUM_VECTORS = 500000;
    std::deque<TreeVector> tree_fifo;
    std::deque<MulVector> mul_fifo;
    std::deque<ValVector> val_fifo;

    uint64_t tree_passed = 0;
    uint64_t mul_passed = 0;
    uint64_t val_passed = 0;
    uint64_t rep_passed = 0;
    uint64_t errors = 0;

    // Reset sequence
    for (int i = 0; i < 10; ++i) {
        top->clk = !top->clk;
        top->eval();
    }
    top->rst_n = 1;

    auto start_time = std::chrono::high_resolution_clock::now();

    uint64_t cycles = 0;
    uint32_t lfsr = 0x12345678;

    auto rand32 = [&]() -> uint32_t {
        lfsr = (lfsr >> 1) ^ (-(lfsr & 1u) & 0xD0000001u);
        return lfsr;
    };

    std::cout << "==================================================" << std::endl;
    std::cout << " Google XLS Pipelined Datapath Benchmark (SCORE)" << std::endl;
    std::cout << "==================================================" << std::endl;
    std::cout << "Test vectors: " << NUM_VECTORS << " per datapath" << std::endl;

    for (uint64_t i = 0; i < NUM_VECTORS + 10; ++i) {
        // Prepare inputs for cycle i
        if (i < NUM_VECTORS) {
            // Tree of adds
            uint32_t ta = rand32(), tb = rand32(), tc = rand32(), td = rand32(), te = rand32();
            top->tree_a = ta;
            top->tree_b = tb;
            top->tree_c = tc;
            top->tree_d = td;
            top->tree_e = te;
            TreeVector tv = {ta, tb, tc, td, te, ta + tb + tc + td + te};
            tree_fifo.push_back(tv);

            // Multiplier
            uint8_t mx = (uint8_t)(rand32() & 0xFF);
            uint8_t my = (uint8_t)(rand32() & 0xFF);
            top->mul_x = mx;
            top->mul_y = my;
            MulVector mv = {mx, my, (uint8_t)(mx * my)};
            mul_fifo.push_back(mv);

            // Valid signal
            bool vval = (rand32() % 100) < 80; // 80% valid density
            uint8_t vs = (uint8_t)(rand32() & 0x3);
            uint8_t vx = (uint8_t)rand32(), vy = (uint8_t)rand32(), vz = (uint8_t)rand32(), va = (uint8_t)rand32();
            top->val_in_valid = vval ? 1 : 0;
            top->val_s = vs;
            top->val_x = vx;
            top->val_y = vy;
            top->val_z = vz;
            top->val_a = va;
            uint8_t exp_v = (vs == 0) ? vx : (vs == 1) ? vy : (vs == 2) ? vz : va;
            ValVector vv = {vval, vs, vx, vy, vz, va, exp_v};
            val_fifo.push_back(vv);

            // Repeat byte
            uint8_t rx = (uint8_t)rand32();
            top->rep_x = rx;
            top->eval();
            uint32_t exp_rep = (((uint32_t)(uint8_t)(rx + 1) << 24) |
                                ((uint32_t)(uint8_t)(rx + 2) << 16) |
                                ((uint32_t)(uint8_t)(rx + 3) << 8)  |
                                ((uint32_t)(uint8_t)(rx + 4)));
            if (top->rep_out != exp_rep) {
                std::cerr << "RepByte mismatch at cycle " << cycles << ": got " 
                          << std::hex << top->rep_out << " exp " << exp_rep << std::dec << std::endl;
                errors++;
            } else {
                rep_passed++;
            }
        } else {
            top->val_in_valid = 0;
        }

        // Clock low -> high
        top->clk = 0;
        top->eval();
        top->clk = 1;
        top->eval();
        cycles++;

        // Check Tree (latency = 3 cycles)
        if (cycles >= 3 && !tree_fifo.empty()) {
            TreeVector expected_tv = tree_fifo.front();
            tree_fifo.pop_front();
            if (top->tree_out != expected_tv.expected) {
                std::cerr << "Tree mismatch at cycle " << cycles << ": got 0x" 
                          << std::hex << top->tree_out << " exp 0x" << expected_tv.expected << std::dec << std::endl;
                errors++;
            } else {
                tree_passed++;
            }
        }

        // Check Multiplier (latency = 2 cycles)
        if (cycles >= 2 && !mul_fifo.empty()) {
            MulVector expected_mv = mul_fifo.front();
            mul_fifo.pop_front();
            if (top->mul_out != expected_mv.expected) {
                std::cerr << "Mul mismatch at cycle " << cycles << ": got " 
                          << (int)top->mul_out << " exp " << (int)expected_mv.expected << std::endl;
                errors++;
            } else {
                mul_passed++;
            }
        }

        // Check ValidSignal (latency = 2 cycles)
        if (cycles >= 2 && !val_fifo.empty()) {
            ValVector expected_vv = val_fifo.front();
            val_fifo.pop_front();
            if (top->val_out_valid != (expected_vv.valid ? 1 : 0)) {
                std::cerr << "Val valid mismatch at cycle " << cycles << std::endl;
                errors++;
            } else if (expected_vv.valid && top->val_out != expected_vv.expected) {
                std::cerr << "Val data mismatch at cycle " << cycles << ": got " 
                          << (int)top->val_out << " exp " << (int)expected_vv.expected << std::endl;
                errors++;
            } else {
                val_passed++;
            }
        }
    }

    // Now test Streaming UART Accelerator
    std::cout << "Testing Streaming UART Accelerator..." << std::endl;
    const int BAUD_CLKS = 16;
    const std::vector<uint8_t> test_bytes = {0x55, 0xAA, 0xDE, 0xAD, 0xBE, 0xEF, 0x42, 0x13, 0x37, 0x7E};
    uint64_t uart_passed = 0;

    for (uint8_t tx_b : test_bytes) {
        // Transmit start bit (0)
        top->uart_rx = 0;
        for (int b = 0; b < BAUD_CLKS; ++b) {
            top->clk = !top->clk; top->eval(); top->clk = !top->clk; top->eval(); cycles++;
        }
        // Transmit 8 data bits LSB first
        for (int bit = 0; bit < 8; ++bit) {
            top->uart_rx = (tx_b >> bit) & 1;
            for (int b = 0; b < BAUD_CLKS; ++b) {
                top->clk = !top->clk; top->eval(); top->clk = !top->clk; top->eval(); cycles++;
            }
        }
        // Transmit stop bit (1) and concurrently monitor for TX start edge
        int start_cycle = -1;
        int prev_tx = top->uart_tx;

        auto tick = [&]() {
            top->clk = 0; top->eval();
            top->clk = 1; top->eval();
            cycles++;
            int curr_tx = top->uart_tx;
            if (start_cycle == -1 && prev_tx == 1 && curr_tx == 0) {
                start_cycle = 0;
            } else if (start_cycle >= 0) {
                start_cycle++;
            }
            prev_tx = curr_tx;
        };

        // Transmit stop bit
        top->uart_rx = 1;
        for (int b = 0; b < BAUD_CLKS; ++b) {
            tick();
        }

        // Wait if start bit hasn't arrived yet
        int wait_limit = 500;
        while (start_cycle == -1 && --wait_limit > 0) {
            tick();
        }

        if (start_cycle == -1) {
            std::cerr << "UART timeout waiting for TX start edge" << std::endl;
            errors++;
            continue;
        }

        // Sample 8 data bits at their centers: BAUD_CLKS + BAUD_CLKS/2 + bit*BAUD_CLKS
        uint8_t rx_data = 0;
        for (int bit = 0; bit < 8; ++bit) {
            int target_sample = (BAUD_CLKS) + (BAUD_CLKS / 2) + bit * BAUD_CLKS;
            while (start_cycle < target_sample) {
                tick();
            }
            if (top->uart_tx) {
                rx_data |= (1 << bit);
            }
        }

        // Advance past stop bit
        int stop_target = (BAUD_CLKS * 10);
        while (start_cycle < stop_target) {
            tick();
        }


        if (rx_data != tx_b) {
            std::cerr << "UART mismatch: sent 0x" << std::hex << (int)tx_b 
                      << " received 0x" << (int)rx_data << std::dec << std::endl;
            errors++;
        } else {
            uart_passed++;
        }

        // Guard time between frames
        for (int b = 0; b < BAUD_CLKS * 4; ++b) {
            top->clk = !top->clk; top->eval(); top->clk = !top->clk; top->eval(); cycles++;
        }
    }

    auto end_time = std::chrono::high_resolution_clock::now();
    double elapsed_ms = std::chrono::duration<double, std::milli>(end_time - start_time).count();
    double sim_mhz = (cycles / (elapsed_ms / 1000.0)) / 1e6;

    std::cout << "\n================ Benchmark Summary ================" << std::endl;
    std::cout << "Total simulated cycles:     " << cycles << std::endl;
    std::cout << "Tree reduction operations:  " << tree_passed << " (latency: 3 cyc, II: 1)" << std::endl;
    std::cout << "Multiplier operations:      " << mul_passed  << " (latency: 2 cyc, II: 1)" << std::endl;
    std::cout << "ValidSignal multiplexes:    " << val_passed  << " (latency: 2 cyc, II: 1)" << std::endl;
    std::cout << "Repeat byte expansions:     " << rep_passed  << " (combinational)" << std::endl;
    std::cout << "Streaming UART loopbacks:   " << uart_passed << " / " << test_bytes.size() << std::endl;
    std::cout << "Total verification errors:  " << errors << std::endl;
    std::cout << "Execution time:             " << std::fixed << std::setprecision(2) << elapsed_ms << " ms" << std::endl;
    std::cout << "Simulation speed:           " << std::fixed << std::setprecision(2) << sim_mhz << " MHz" << std::endl;
    std::cout << "Overall result:             " << (errors == 0 ? "PASSED (100% Correct)" : "FAILED") << std::endl;
    std::cout << "===================================================" << std::endl;

    delete top;
    return (errors == 0) ? 0 : 1;
}
