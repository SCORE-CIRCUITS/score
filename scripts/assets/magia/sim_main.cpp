// Copyright 2024 ETH Zurich and University of Bologna.
// SPDX-License-Identifier: Apache-2.0
//
// C++ Driver for MAGIA Verilator Simulation

#include <iostream>
#include <memory>
#include "Vtb_magia_verilator.h"
#include "verilated.h"

int main(int argc, char** argv) {
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtb_magia_verilator> top{new Vtb_magia_verilator{contextp.get()}};

    while (!contextp->gotFinish()) {
        top->eval();
        if (!top->eventsPending()) {
            break;
        }
        contextp->time(top->nextTimeSlot());
    }

    top->final();
    return 0;
}
