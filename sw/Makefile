# Copyright 2019 Clifford Wolf
# Copyright 2019 Robert Balas
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

# Author: Robert Balas (balasr@iis.ee.ethz.ch)
#
# Description: Makefile for running the following examples:
#
#              - 'Hello World' (custom), command line 'make custom-vsim-run'
#              - 'Floating Point example' (custom_fp), command line 'make custom-fp-vsim-run'
#              - 'Interrupt example' (interrupt), command line 'make interrupt-vsim-run'

MAKE			= make

# vsim configuration

VLIB			= vlib
VWORK			= work
VLOG			= vlog
VLOG_FLAGS		= -pedanticerrors -suppress 2577 -suppress 2583 -define CV32E40X_TRACE_EXECUTION -define COREV_ASSERT_OFF -sv
VLOG_LOG        = vloggy
VOPT			= vopt
VOPT_FLAGS		= -debugdb -fsmdebug -pedanticerrors +acc #=mnprft
VSIM			= vsim

VSIM_FLAGS              = # user defined
ALL_VSIM_FLAGS			= $(VSIM_FLAGS)
VSIM_DEBUG_FLAGS		= -debugdb
VSIM_GUI_FLAGS          = -gui -debugdb -dpicpppath /usr/bin/gcc
VSIM_SCRIPT             = tcl/vsim.tcl


# RTL source files
RTLSRC_INCDIR := ../rtl/include

# unused
RTLSRC_PKG    := $(addprefix $(RTLSRC_INCDIR)/,\
				cv32e40x_apu_core_package.sv cv32e40x_defines.sv \
				cv32e40x_tracer_defines.sv)
RTLSRC  := $(filter-out ../rtl/cv32e40x_register_file_latch.sv, \
                $(wildcard ../rtl/*.sv))
# FIXME: temporarily using a local manifest for the core.
#        This is BAD PRACTICE and will be fixed with
#        https://github.com/openhwgroup/CV_CORE/pull/421 is resolved.
export DESIGN_RTL_DIR = ../rtl
CORE_MANIFEST    := ../cv32e40x_manifest.flist

# TB source files for the CV32E core
TBSRC_HOME  := ../tb
TBSRC_TOP   := $(TBSRC_HOME)/tb_top.sv

TBSRC_PKG   := $(TBSRC_HOME)/tb_riscv/include/perturbation_defines.sv
TBSRC       := $(TBSRC_HOME)/tb_top.sv \
               $(TBSRC_HOME)/cv32e40x_tb_wrapper.sv \
               $(TBSRC_HOME)/mm_ram.sv \
               $(TBSRC_HOME)/dp_ram.sv \
               $(TBSRC_HOME)/tb_riscv/riscv_random_stall.sv \
               $(TBSRC_HOME)/tb_riscv/riscv_random_interrupt_generator.sv \
               $(TBSRC_HOME)/tb_riscv/riscv_rvalid_stall.sv \
               $(TBSRC_HOME)/tb_riscv/riscv_gnt_stall.sv


RTLSRC_VLOG_TB_TOP	:= $(basename $(notdir $(TBSRC_TOP)))
RTLSRC_VOPT_TB_TOP	:= $(addsuffix _vopt, $(RTLSRC_VLOG_TB_TOP))

# riscv toolchain install path
RISCV                    ?= ~/.riscv
RISCV_EXE_PREFIX         = $(RISCV)/bin/riscv32-unknown-elf-

# assume vsim if no target chosen
.DEFAULT_GOAL := hello-vsim-run

# GCC configuration
CUSTOM_GCC_FLAGS           =

all: hello-vsim-run

# vsim testbench compilation and optimization
vlib: .lib-rtl

.lib-rtl:
	$(VLIB) $(VWORK)
	touch .lib-rtl

# rebuild if we change some sourcefile
.build-rtl: .lib-rtl $(TBSRC_PKG) $(TBSRC)
	$(VLOG) \
	$(VLOG_FLAGS) \
	-work $(VWORK) \
	-f $(CORE_MANIFEST) \
	$(TBSRC_PKG) $(TBSRC) \

vsim-all: .opt-rtl

.opt-rtl: .build-rtl
	$(VOPT) -work $(VWORK) $(VOPT_FLAGS) $(RTLSRC_VLOG_TB_TOP) -o \
	$(RTLSRC_VOPT_TB_TOP)
	touch .opt-rt

# run tb and exit
.PHONY: vsim-run
vsim-run: ALL_VSIM_FLAGS += -c
vsim-run: vsim-all
	$(VSIM) -work $(VWORK) $(ALL_VSIM_FLAGS) \
	$(RTLSRC_VOPT_TB_TOP) -do 'source $(VSIM_SCRIPT); exit -f'

# run tb and drop into interactive shell
.PHONY: vsim-run-sh
vsim-run-sh: ALL_VSIM_FLAGS += -c
vsim-run-sh: vsim-all
	$(VSIM) -work $(VWORK) $(ALL_VSIM_FLAGS) \
	$(RTLSRC_VOPT_TB_TOP) -do $(VSIM_SCRIPT)

# run tb with simulator gui
.PHONY: vsim-run-gui
vsim-run-gui: ALL_VSIM_FLAGS += $(VSIM_GUI_FLAGS)
vsim-run-gui: vsim-all
	$(VSIM) -work $(VWORK) $(ALL_VSIM_FLAGS) \
	$(RTLSRC_VOPT_TB_TOP) -do $(VSIM_SCRIPT)

.PHONY: tb-clean
tb-clean:
	if [ -d $(VWORK) ]; then rm -r $(VWORK); fi
	rm -f transcript vsim.wlf vsim.dbg trace_core*.log \
	.build-rtl .opt-rtl .lib-rtl *.vcd objdump

# rules to generate hex (loadable by simulators) from elf
%.hex: %.elf
	$(RISCV_EXE_PREFIX)objcopy -O verilog $< $@

%.dis: %.elf
	$(RISCV_EXE_PREFIX)objdump -S $^

# Running hello programs:
# This is an example for running a Hello World in the testbench
# We link with our custom crt0.s and syscalls.c against newlib so that we can
# use the c standard library
hello_world/hello_world.elf: hello_world/hello_world.c
	$(RISCV_EXE_PREFIX)gcc -march=rv32im -o $@ -w -Os -g -nostdlib \
		$(CUSTOM_GCC_FLAGS) \
		-T bsp/link.ld \
		-static \
		bsp/crt0.S \
		$^  bsp/syscalls.c bsp/vectors.S bsp/handlers.S\
		-I $(RISCV)/riscv32-unknown-elf/include \
		-I bsp \
		-L $(RISCV)/riscv32-unknown-elf/lib \
		-lc -lm -lgcc

.PHONY: hello-vsim-run-gui
hello-vsim-run-gui: vsim-all hello_world/hello_world.hex
hello-vsim-run-gui: ALL_VSIM_FLAGS += "+firmware=hello_world/hello_world.hex" 
hello-vsim-run-gui: vsim-run-gui

.PHONY: hello-vsim-run
hello-vsim-run: vsim-all hello_world/hello_world.hex
hello-vsim-run: ALL_VSIM_FLAGS += "+firmware=hello_world/hello_world.hex"
hello-vsim-run: vsim-run

hello-clean:
	rm -rf hello/hello_world.elf hello/hello_world.hex

#######################################
dhrystone/dhrystone.elf:dhrystone/dhrystone.c
	$(RISCV_EXE_PREFIX)gcc -march=rv32im -o $@ -w -Os -g -nostdlib \
		$(CUSTOM_GCC_FLAGS) \
		-T bsp/link.ld \
		-static \
		bsp/crt0.S \
		$^ bsp/syscalls.c bsp/vectors.S bsp/handlers.S \
		-I $(RISCV)/riscv32-unknown-elf/include \
		-I bsp \
		-L $(RISCV)/riscv32-unknown-elf/lib \
		-lc -lm -lgcc

#######################################
.PHONY: bench-vsim-run-gui
bench-vsim-run-gui: vsim-all dhrystone/dhrystone.hex
bench-vsim-run-gui: ALL_VSIM_FLAGS += "+firmware=dhrystone/dhrystone.hex" 
bench-vsim-run-gui: vsim-run-gui

.PHONY: bench-vsim-run
bench-vsim-run: vsim-all dhrystone/dhrystone.hex
bench-vsim-run: ALL_VSIM_FLAGS += "+firmware=dhrystone/dhrystone.hex" 
bench-vsim-run: vsim-run

bench-clean:
	rm -rf dhrystone/dhrystone.elf dhrystone/dhrystone.hex
######################################


# general targets
.PHONY: clean
clean: tb-clean hello-clean
