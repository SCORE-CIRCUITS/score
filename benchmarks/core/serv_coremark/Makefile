COREMARK_DIST ?= ../../../tools/hazard3/test/sim/coremark/dist
TOOLCHAIN_PREFIX ?= riscv32-unknown-elf-
ITERATIONS ?= 1

CC = $(TOOLCHAIN_PREFIX)gcc
OBJCOPY = $(TOOLCHAIN_PREFIX)objcopy

CFLAGS = -march=rv32i_zicsr -mabi=ilp32 -O3 -ffreestanding -nostdlib
CFLAGS += -DPERFORMANCE_RUN=1 -DITERATIONS=$(ITERATIONS) -DMULTITHREAD=1
CFLAGS += -I. -I$(COREMARK_DIST) -Wno-implicit-function-declaration

COREMARK_SRCS = $(COREMARK_DIST)/core_list_join.c \
                $(COREMARK_DIST)/core_main.c \
                $(COREMARK_DIST)/core_matrix.c \
                $(COREMARK_DIST)/core_state.c \
                $(COREMARK_DIST)/core_util.c

PORT_SRCS = core_portme.c ee_printf.c
ASM_SRCS = start.S

OBJS = $(ASM_SRCS:.S=.o) $(PORT_SRCS:.c=.o) $(notdir $(COREMARK_SRCS:.c=.o))

VPATH = $(COREMARK_DIST)

.PHONY: all hex clean

all: hex

hex: coremark.hex

coremark.hex: coremark.bin
	python3 makehex.py $< > $@

coremark.bin: coremark.elf
	$(OBJCOPY) -O binary $< $@

coremark.elf: $(OBJS) sections.lds
	$(CC) $(CFLAGS) -Wl,-Bstatic,-T,sections.lds,-Map,coremark.map,--strip-debug -o $@ $(OBJS) -lgcc

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf *.o *.d coremark.elf coremark.bin coremark.hex coremark.map

