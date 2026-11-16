# Copyright 2026 SCORE Project.
# Makefile for 8-core PULP Cluster baremetal software workloads.

RISCV_PREFIX ?= /home/yongfu/proj/score/tools/ibex-host-tools/riscv/bin/riscv32-unknown-elf-
CC      = $(RISCV_PREFIX)gcc
OBJCOPY = $(RISCV_PREFIX)objcopy
OBJDUMP = $(RISCV_PREFIX)objdump

ARCH    = -march=rv32imc -mabi=ilp32
CFLAGS  = $(ARCH) -O3 -g -Wall -nostdlib -fno-builtin -ffreestanding -I.
LDFLAGS = $(ARCH) -Tlink.ld -nostartfiles -Wl,--gc-sections -lgcc

BINDIR  = bin
SRCS_COMMON = crt0.S

WORKLOADS = hello parallel_matmul parallel_fir

all: $(addprefix $(BINDIR)/, $(addsuffix .hex, $(WORKLOADS)))

$(BINDIR):
	mkdir -p $(BINDIR)

$(BINDIR)/%.elf: %.c $(SRCS_COMMON) link.ld pulp_cluster.h | $(BINDIR)
	$(CC) $(CFLAGS) $(LDFLAGS) crt0.S $< -o $@
	$(OBJDUMP) -d $@ > $(BINDIR)/$*.dump

$(BINDIR)/%.hex: $(BINDIR)/%.elf
	$(OBJCOPY) -O verilog $< $@

clean:
	rm -rf $(BINDIR)

.PHONY: all clean
