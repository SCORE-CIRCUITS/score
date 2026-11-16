#!/usr/bin/env python3
"""
Convert RISC-V ELF binary to 32-bit word hex file for MAGIA Verilator simulation.
L2 base address: 0xCC00_0000.
"""

import sys
from elftools.elf.elffile import ELFFile

def convert_elf_to_hex(elf_path, hex_path):
    L2_BASE = 0xCC000000
    L2_SIZE = 16 * 1024 * 1024 # 16 MB
    L2_WORDS = L2_SIZE // 4

    words = {}

    with open(elf_path, 'rb') as f:
        elf = ELFFile(f)
        for segment in elf.iter_segments():
            if segment['p_type'] != 'PT_LOAD':
                continue
            vaddr = segment['p_paddr']
            data = segment.data()
            if not data:
                continue

            for offset in range(0, len(data), 4):
                addr = vaddr + offset
                if L2_BASE <= addr < (L2_BASE + L2_SIZE):
                    chunk = data[offset:offset+4]
                    if len(chunk) < 4:
                        chunk = chunk.ljust(4, b'\x00')
                    val = int.from_bytes(chunk, byteorder='little')
                    word_idx = (addr - L2_BASE) >> 2
                    words[word_idx] = val

    # Write sorted words with @word_idx
    with open(hex_path, 'w') as out:
        current_idx = None
        for idx in sorted(words.keys()):
            if current_idx is None or idx != current_idx:
                out.write(f"@{idx:08x}\n")
            out.write(f"{words[idx]:08x}\n")
            current_idx = idx + 1

    print(f"Converted {elf_path} -> {hex_path} ({len(words)} 32-bit words loaded)")

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: elf2hex.py <input.elf> <output.hex>")
        sys.exit(1)
    convert_elf_to_hex(sys.argv[1], sys.argv[2])

