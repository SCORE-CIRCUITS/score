/* Copyright 2026 SCORE Project.
 * Linker script for RoaLogic RV12 on Verilator.
 * Origin at 0x80000000 (512KB SRAM).
 */

OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY {
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 512K
}

SECTIONS {
  .text 0x80000000 : {
    _stext = .;
    KEEP(*(.text._start))
    *(.text)
    *(.text.*)
    _etext = .;
  } > RAM

  .rodata : ALIGN(4) {
    _srodata = .;
    *(.rodata)
    *(.rodata.*)
    *(.srodata)
    *(.srodata.*)
    _erodata = .;
  } > RAM

  .data : ALIGN(4) {
    _sdata = .;
    __data_begin = .;
    *(.data)
    *(.data.*)
    *(.sdata)
    *(.sdata.*)
    PROVIDE(__global_pointer$ = . + 0x800);
    _edata = .;
  } > RAM

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
  } > RAM

  . = ALIGN(16);
  _end = .;
  __heap_start = .;
  __heap_end = ORIGIN(RAM) + LENGTH(RAM) - 0x10000;
  __stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
