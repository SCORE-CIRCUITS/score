/* Linker script for PicoRV32 CoreMark */
SECTIONS {
    . = 0x10000;
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

