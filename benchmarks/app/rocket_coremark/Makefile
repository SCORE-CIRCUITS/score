# Makefile for Rocket Chip RV64GC CoreMark
RISCV_PREFIX ?= /home/yongfu/proj/score/datasets/gemmini/workshop/chipyard/.conda-env/riscv-tools/bin/riscv64-unknown-elf-
CC := $(RISCV_PREFIX)gcc
PROJECT_ROOT ?= ../../..

COREMARK_SRC := $(PROJECT_ROOT)/tools/cva6/verif/tests/custom/coremark
SATURN_BENCH := $(PROJECT_ROOT)/datasets/gemmini/workshop/chipyard/generators/saturn/benchmarks

CFLAGS := -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -nostartfiles -lgcc \
          -O3 -fno-builtin-memset -fno-builtin-memcpy -fno-tree-loop-distribute-patterns \
          -DCOMPILER_FLAGS="\"-O3\"" -DITERATIONS=1 -DPERFORMANCE_RUN=1 -DSKIP_TIME_CHECK=1 \
          -I. \
          -I$(COREMARK_SRC) \
          -I$(SATURN_BENCH)/common \
          -I$(SATURN_BENCH)/env

SRCS := $(SATURN_BENCH)/common/crt.S \
        $(SATURN_BENCH)/common/syscalls.c \
        $(COREMARK_SRC)/core_list_join.c \
        $(COREMARK_SRC)/core_matrix.c \
        core_portme_rocket.c \
        $(COREMARK_SRC)/core_state.c \
        $(COREMARK_SRC)/core_util.c \
        uart_stub.c \
        $(COREMARK_SRC)/coremark_main.c

LDFLAGS := -T $(SATURN_BENCH)/common/test.ld

all: coremark.riscv

coremark.riscv: $(SRCS) core_portme.h
	$(CC) $(CFLAGS) $(LDFLAGS) $(SRCS) -o $@

clean:
	rm -f coremark.riscv
