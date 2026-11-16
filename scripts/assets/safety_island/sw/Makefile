# Copyright 2026 SCORE Project.
# Makefile for Safety Island baremetal software tests and CoreMark.

RISCV_PREFIX ?= /home/yongfu/proj/score/tools/ibex-host-tools/riscv/bin/riscv32-unknown-elf-
CC      = $(RISCV_PREFIX)gcc
OBJCOPY = $(RISCV_PREFIX)objcopy
OBJDUMP = $(RISCV_PREFIX)objdump

ARCH    = -march=rv32imc -mabi=ilp32
CFLAGS  = $(ARCH) -O3 -g -Wall -nostdlib -fno-builtin -ffreestanding -I.
LDFLAGS = $(ARCH) -Tlink.ld -nostartfiles -Wl,--gc-sections -lgcc

BINDIR  = bin
SRCS_COMMON = crt0.S io.c

COREMARK_SRCS = \
	crt0.S \
	coremark/core_main.c \
	coremark/core_list_join.c \
	coremark/core_matrix.c \
	coremark/core_state.c \
	coremark/core_util.c \
	coremark/ee_printf.c \
	coremark/core_portme.c

COREMARK_CFLAGS = $(CFLAGS) -Icoremark -DITERATIONS=2 -DPERFORMANCE_RUN=1 -DFLAGS_STR="\"-O3\""

all: $(BINDIR)/hello.hex $(BINDIR)/coremark.hex

$(BINDIR):
	mkdir -p $(BINDIR)

$(BINDIR)/hello.elf: hello.c $(SRCS_COMMON) link.ld | $(BINDIR)
	$(CC) $(CFLAGS) $(LDFLAGS) crt0.S hello.c io.c -o $@
	$(OBJDUMP) -d $@ > $(BINDIR)/hello.dump

$(BINDIR)/coremark.elf: $(COREMARK_SRCS) link.ld | $(BINDIR)
	$(CC) $(COREMARK_CFLAGS) $(LDFLAGS) $(COREMARK_SRCS) -o $@
	$(OBJDUMP) -d $@ > $(BINDIR)/coremark.dump

$(BINDIR)/%.hex: $(BINDIR)/%.elf
	$(OBJCOPY) -O verilog $< $@

clean:
	rm -rf $(BINDIR)

.PHONY: all clean
