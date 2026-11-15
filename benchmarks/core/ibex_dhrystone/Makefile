# Makefile to compile Dhrystone for Ibex Simple System
CROSS_PREFIX ?= riscv32-unknown-elf-
RV_ISA ?= rv32im

IBEX_DIR ?= ../../../tools/ibex
SIMPLE_SYS = $(IBEX_DIR)/examples/sw/simple_system/common

CC = $(CROSS_PREFIX)gcc
OBJCOPY = $(CROSS_PREFIX)objcopy
OBJDUMP = $(CROSS_PREFIX)objdump

CFLAGS = -march=$(RV_ISA) -mabi=ilp32 -O3 -funroll-all-loops \
         -nostdlib -nostartfiles -ffreestanding \
         -Wno-implicit-int -Wno-implicit-function-declaration \
         -I. -I$(SIMPLE_SYS) -DUSE_MYSTDLIB -DTIME -DRISCV

SRCS = dhry_1.c dhry_2.c stdlib.c $(SIMPLE_SYS)/simple_system_common.c $(SIMPLE_SYS)/crt0.S

all: dhrystone.elf dhrystone.bin dhrystone.dis

dhrystone.elf: $(SRCS) $(SIMPLE_SYS)/link.ld
	$(CC) $(CFLAGS) -T $(SIMPLE_SYS)/link.ld $(SRCS) -lgcc -o $@

dhrystone.bin: dhrystone.elf
	$(OBJCOPY) -O binary $< $@

dhrystone.dis: dhrystone.elf
	$(OBJDUMP) -d $< > $@

clean:
	rm -f dhrystone.elf dhrystone.bin dhrystone.dis
