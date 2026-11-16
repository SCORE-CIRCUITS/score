/* Copyright 2026 SCORE Project.
 * Linker script for Safety Island SoC on Verilator.
 * Origin at 0x00000000 (128KB SRAM).
 */

OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY {
  SRAM (rwx) : ORIGIN = 0x00000000, LENGTH = 128K
}

SECTIONS {
  .vectors 0x00000000 : {
    KEEP(*(.vectors))
  } > SRAM

  .text : ALIGN(4) {
    _stext = .;
    *(.text._start)
    *(.text)
    *(.text.*)
    _etext = .;
  } > SRAM

  .rodata : ALIGN(4) {
    _srodata = .;
    *(.rodata)
    *(.rodata.*)
    *(.srodata)
    *(.srodata.*)
    _erodata = .;
  } > SRAM

  .data : ALIGN(4) {
    _sdata = .;
    __data_begin = .;
    *(.data)
    *(.data.*)
    *(.sdata)
    *(.sdata.*)
    _edata = .;
  } > SRAM

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
  } > SRAM

  . = ALIGN(16);
  _end = .;
  __heap_start = .;

  __stack_top = ORIGIN(SRAM) + LENGTH(SRAM) - 16;
}
