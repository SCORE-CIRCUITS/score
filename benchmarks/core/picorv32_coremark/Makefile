COREMARK_DIST ?= ../../../tools/hazard3/test/sim/coremark/dist
PICO_RTL ?= ../../../tools/picorv32/picorv32.v
TOOLCHAIN_PREFIX ?= riscv32-unknown-elf-
ITERATIONS ?= 1

CC = $(TOOLCHAIN_PREFIX)gcc
OBJCOPY = $(TOOLCHAIN_PREFIX)objcopy

CFLAGS = -march=rv32im -mabi=ilp32 -O3 -ffreestanding -nostdlib
CFLAGS += -DPERFORMANCE_RUN=1 -DITERATIONS=$(ITERATIONS) -DMULTITHREAD=1
CFLAGS += -I. -I$(COREMARK_DIST) -I$(COREMARK_DIST)/barebones -Wno-implicit-function-declaration

COREMARK_SRCS = $(COREMARK_DIST)/core_list_join.c \
                $(COREMARK_DIST)/core_main.c \
                $(COREMARK_DIST)/core_matrix.c \
                $(COREMARK_DIST)/core_state.c \
                $(COREMARK_DIST)/core_util.c \
                $(COREMARK_DIST)/barebones/ee_printf.c

PORT_SRCS = core_portme.c
ASM_SRCS = start.S

OBJS = $(ASM_SRCS:.S=.o) $(PORT_SRCS:.c=.o) $(notdir $(COREMARK_SRCS:.c=.o))

VPATH = $(COREMARK_DIST) $(COREMARK_DIST)/barebones

.PHONY: all hex sim clean

all: hex

hex: coremark.hex

coremark.hex: coremark.elf
	$(OBJCOPY) -O verilog $< $@

coremark.elf: $(OBJS) sections.lds
	$(CC) $(CFLAGS) -Wl,-Bstatic,-T,sections.lds,-Map,coremark.map,--strip-debug -o $@ $(OBJS) -lgcc

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

sim: testbench.vvp coremark.hex
	vvp -N testbench.vvp

testbench.vvp: testbench.v $(PICO_RTL)
	iverilog -o $@ $^

clean:
	rm -rf *.o *.d coremark.elf coremark.hex coremark.map testbench.vvp testbench.vcd
