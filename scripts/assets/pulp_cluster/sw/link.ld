/* Copyright 2026 SCORE Project.
 * Linker script for 8-core PULP Cluster on Verilator.
 * L2 Memory origin: 0x1C000000 (1MB).
 * L1 TCDM Scratchpad origin: 0x10000000 (128KB).
 */

OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY {
  L2_MEM   (rwx) : ORIGIN = 0x1C000000, LENGTH = 1024K
  L1_TCDM  (rw)  : ORIGIN = 0x10000000, LENGTH = 128K
}

SECTIONS {
  .vectors 0x1C000000 : {
    KEEP(*(.vectors))
  } > L2_MEM

  .text : ALIGN(4) {
    _stext = .;
    *(.text._start)
    *(.text)
    *(.text.*)
    _etext = .;
  } > L2_MEM

  .rodata : ALIGN(4) {
    _srodata = .;
    *(.rodata)
    *(.rodata.*)
    *(.srodata)
    *(.srodata.*)
    _erodata = .;
  } > L2_MEM

  .data : ALIGN(4) {
    _sdata = .;
    __data_begin = .;
    *(.data)
    *(.data.*)
    *(.sdata)
    *(.sdata.*)
    _edata = .;
  } > L2_MEM

  .bss : ALIGN(4) {
    _sbss = .;
    __bss_start = .;
    *(.bss)
    *(.bss.*)
    *(.sbss)
    *(.sbss.*)
    *(COMMON)
    _ebss = .;
    __bss_end = .;
  } > L2_MEM

  . = ALIGN(16);
  _end = .;
  __heap_start = .;

  /* Shared TCDM region for fast inter-core barriers and data buffers */
  .tcdm (NOLOAD) : ALIGN(4) {
    __tcdm_start = .;
    *(.tcdm)
    *(.tcdm.*)
    __tcdm_end = .;
  } > L1_TCDM
}
