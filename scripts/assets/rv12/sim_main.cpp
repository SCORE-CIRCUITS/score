// Copyright 2026 SCORE Project.
// Verilator C++ testbench harness for RoaLogic RV12

#include <iostream>
#include <fstream>
#include <vector>
#include <cstring>
#include <cstdint>
#include <iomanip>
#include "Vtb_rv12_top.h"
#include "Vtb_rv12_top___024root.h"
#include "verilated.h"

// ELF32 Header Structures
#pragma pack(push, 1)
struct Elf32_Ehdr {
    unsigned char e_ident[16];
    uint16_t      e_type;
    uint16_t      e_machine;
    uint32_t      e_version;
    uint32_t      e_entry;
    uint32_t      e_phoff;
    uint32_t      e_shoff;
    uint32_t      e_flags;
    uint16_t      e_ehsize;
    uint16_t      e_phentsize;
    uint16_t      e_phnum;
    uint16_t      e_shentsize;
    uint16_t      e_shnum;
    uint16_t      e_shstrndx;
};

struct Elf32_Phdr {
    uint32_t p_type;
    uint32_t p_offset;
    uint32_t p_vaddr;
    uint32_t p_paddr;
    uint32_t p_filesz;
    uint32_t p_memsz;
    uint32_t p_flags;
    uint32_t p_align;
};
#pragma pack(pop)

bool load_elf(Vtb_rv12_top* top, const std::string& filename, uint32_t& entry_point) {
    std::ifstream file(filename, std::ios::binary);
    if (!file) {
        std::cerr << "ERROR: Failed to open ELF file: " << filename << std::endl;
        return false;
    }

    Elf32_Ehdr ehdr;
    file.read(reinterpret_cast<char*>(&ehdr), sizeof(ehdr));
    if (!file || memcmp(ehdr.e_ident, "\x7f\x45\x4c\x46", 4) != 0) {
        std::cerr << "ERROR: Invalid ELF magic in: " << filename << std::endl;
        return false;
    }

    entry_point = ehdr.e_entry;

    for (int i = 0; i < ehdr.e_phnum; ++i) {
        file.seekg(ehdr.e_phoff + i * sizeof(Elf32_Phdr));
        Elf32_Phdr phdr;
        file.read(reinterpret_cast<char*>(&phdr), sizeof(phdr));

        if (phdr.p_type == 1 /* PT_LOAD */ && phdr.p_memsz > 0) {
            std::vector<uint8_t> buffer(phdr.p_memsz, 0);
            if (phdr.p_filesz > 0) {
                file.seekg(phdr.p_offset);
                file.read(reinterpret_cast<char*>(buffer.data()), phdr.p_filesz);
            }

            // Write 32-bit words into memory
            for (size_t offset = 0; offset < phdr.p_memsz; offset += 4) {
                uint32_t word = 0;
                for (size_t b = 0; b < 4 && (offset + b) < phdr.p_memsz; ++b) {
                    word |= static_cast<uint32_t>(buffer[offset + b]) << (b * 8);
                }
                uint32_t addr = phdr.p_paddr + offset;
                top->rootp->tb_rv12_top__DOT__unified_memory__DOT__mem_array.at(addr) = word;
            }
        }
    }

    return true;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    std::string elf_file = "";
    uint64_t max_cycles = 50000000; // 50M cycles default

    for (int i = 1; i < argc; ++i) {
        std::string arg = argv[i];
        if (arg == "--elf" && i + 1 < argc) {
            elf_file = argv[++i];
        } else if (arg == "--max-cycles" && i + 1 < argc) {
            max_cycles = std::stoull(argv[++i]);
        } else if (arg[0] != '-') {
            elf_file = arg;
        }
    }

    if (elf_file.empty()) {
        std::cerr << "Usage: " << argv[0] << " [--elf <file.elf>] [--max-cycles <N>]" << std::endl;
        return 1;
    }

    auto top = std::make_unique<Vtb_rv12_top>();

    uint32_t entry_point = 0;
    if (!load_elf(top.get(), elf_file, entry_point)) {
        std::cerr << "Failed to load ELF: " << elf_file << std::endl;
        return 1;
    }

    // Reset sequence
    top->HRESETn = 0;
    top->HCLK = 0;
    for (int i = 0; i < 20; ++i) {
        top->HCLK = !top->HCLK;
        top->eval();
    }
    top->HRESETn = 1;

    uint64_t cycles = 0;
    uint64_t inst_retired = 0;
    int exit_code = 0;
    bool finished = false;

    while (cycles < max_cycles && !Verilated::gotFinish()) {
        // Falling edge
        top->HCLK = 0;
        top->eval();

        // Rising edge
        top->HCLK = 1;
        top->eval();
        cycles++;

        static uint32_t prev_pc = 0;
        if (top->inst_retired_o) {
            inst_retired++;
            if (top->inst_pc_o == 0x80000004) {
                std::cout << "\n[TRAP at cycle " << cycles << " prev_pc=0x" << std::hex << prev_pc << std::dec << "]\n";
            }
            prev_pc = top->inst_pc_o;
        }

        if (top->uart_valid_o) {
            char c = static_cast<char>(top->uart_char_o);
            std::cout << c;
            std::cout.flush();
        }

        if (top->tohost_valid_o) {
            uint32_t tohost = top->tohost_val_o;
            exit_code = tohost >> 1;
            finished = true;
            break;
        }
    }

    std::cout << "\n----------------------------------------\n";
    std::cout << "RoaLogic RV12 Simulation Finished\n";
    std::cout << "Execution Cycles:     " << cycles << "\n";
    std::cout << "Retired Instructions: " << inst_retired << "\n";
    if (cycles > 0) {
        double ipc = static_cast<double>(inst_retired) / static_cast<double>(cycles);
        std::cout << "IPC:                  " << std::fixed << std::setprecision(4) << ipc << "\n";
    }
    std::cout << "Exit Code:            " << exit_code << "\n";
    std::cout << "Result:               " << (exit_code == 0 && finished ? "PASS" : "FAIL") << "\n";
    std::cout << "----------------------------------------\n";

    return (finished && exit_code == 0) ? 0 : 1;
}
