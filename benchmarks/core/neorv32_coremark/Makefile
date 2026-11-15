# NEORV32 CoreMark Makefile
COREMARK_DIST ?= ../../../tools/hazard3/test/sim/coremark/dist
NEORV32_HOME ?= ../../../tools/neorv32
ITERATIONS ?= 1

# Match testbench ISA
MARCH ?= rv32imc

EFFORT = -O3

USER_FLAGS += -Wl,--defsym,__neorv32_rom_size=32k
USER_FLAGS += -Wl,--defsym,__neorv32_ram_size=8k
USER_FLAGS += -DPERFORMANCE_RUN=1 -DITERATIONS=$(ITERATIONS) -DMULTITHREAD=1
USER_FLAGS += -DUART0_SIM_MODE
USER_FLAGS += -Wno-implicit-function-declaration

APP_SRC += core_portme.c ee_printf.c cvt.c
APP_SRC += $(COREMARK_DIST)/core_list_join.c
APP_SRC += $(COREMARK_DIST)/core_main.c
APP_SRC += $(COREMARK_DIST)/core_matrix.c
APP_SRC += $(COREMARK_DIST)/core_state.c
APP_SRC += $(COREMARK_DIST)/core_util.c

APP_INC += -I . -I $(COREMARK_DIST)

include $(NEORV32_HOME)/sw/common/common.mk
