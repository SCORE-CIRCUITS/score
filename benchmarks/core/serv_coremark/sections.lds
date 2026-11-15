OUTPUT_ARCH( "riscv" )
ENTRY(_start)

SECTIONS
{
  . = 0x00000000;
  .text : {
    start*(.text)
    *(.text*)
    *(.rodata*)
    *(.srodata*)
  }
  .data : {
    *(.data*)
    *(.sdata*)
  }
  .bss : {
    __bss_start = .;
    *(.sbss*)
    *(.bss*)
    *(COMMON)
    __bss_end = .;
  }
  _end = .;
  end = .;
}

