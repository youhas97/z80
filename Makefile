# Makefile for hardware implementation on Xilinx FPGAs and ASICs
# Author: Andreas Ehliar <ehliar@isy.liu.se>
# 
# T is the testbench file for this project
# S is the synthesizable sources for this project
# U is the UCF file
# PART is the part

# Important makefile targets:
# make lab.sim		GUI simulation
# make lab.simc		batch simulation
# make lab.synth	Synthesize
# make lab.route	Route the design
# make lab.bitgen	Generate bit file
# make lab.timing	Generate timing report
# make lab.clean	Use whenever you change settings in the Makefile!
# make lab.prog		Downloads the bitfile to the FPGA. NOTE: Does not
#                       rebuild bitfile if source files have changed!
# make clean            Removes all generated files for all projects. Also
#                       backup files (*~) are removed.
# 
# VIKTIG NOTERING: 	Om du ändrar vilka filer som finns med i projektet så måste du köra
#                  	make lab.clean
#
# Syntesrapporten ligger i lab-synthdir/xst/synth/design.syr
# Maprapporten (bra att kolla i för arearapportens skull) ligger i lab-synthdir/layoutdefault/design_map.mrp
# Timingrapporten (skapas av make lab.timing) ligger i lab-synthdir/layoutdefault/design.trw

# (Or proj2.simc, proj2.sim, etc, depending on the name of the
# project)

XILINX_INIT = source /sw/xilinx/ise_12.4i/ISE_DS/settings64.sh;
PART=xc6slx16-3-csg324

ti83p.%: S=src/comp.vhd \
	src/dbg/monitor.vhd src/dbg/segment.vhd \
	src/prm/counters.vhd src/prm/registers.vhd \
	src/ext/mem_if.vhd src/ext/vga_motor.vhd \
	src/ext/kbd_enc.vhd \
	src/ti/ti83p/ti.vhd src/ti/ti83p/asic.vhd \
	src/ti/ti83p/mem_ctrl.vhd src/ti/ti83p/status.vhd \
	src/ti/ti83p/interrupts.vhd \
	src/ti/pict_mem.vhd src/ti/lcd_ctrl.vhd src/ti/kbd_ctrl.vhd \
	src/ti/hw_timers.vhd \
	src/z80/z80.vhd src/z80/state_machine.vhd src/z80/op_decoder.vhd \
	src/z80/alu.vhd src/z80/regfile.vhd \
	src/prm/bram.vhd src/prm/registers.vhd src/prm/counters.vhd \
	src/pkg/cmp_comm.vhd src/ti/ti83p/ti_comm.vhd src/pkg/z80_comm.vhd \
	src/pkg/util.vhd
ti83p.%: T=tests/comp_tb.vhd tests/ext/m45w8mw16.vhd
ti83p.%: U=build/ucf/ti83p.ucf

mem.%: S=tests/mem_ext_fb.vhd src/dbg/segment.vhd src/ext/mem_if.vhd \
	src/prm/registers.vhd
mem.%: T=tests/mem_ext_ftb.vhd tests/ext/m45w8mw16.vhd
mem.%: U=build/ucf/mem.ucf

vga.%: S=tests/vga_fb.vhd src/ext/vga_motor.vhd src/ti/pict_mem.vhd 
vga.%: T=tests/vga_fb_tb.vhd
vga.%: U=build/ucf/vga.ucf

key.%: S=tests/key_fb.vhd src/ext/kbd_enc.vhd src/dbg/segment.vhd src/ti/ti83p/ti_comm.vhd
#key.%: T= 
key.%: U=build/ucf/kbd.ucf

# Det här är ett exempel på hur man kan skriva en testbänk som är
# relevant, även om man kör en simulering i batchläge (make batchlab.simc)
#batchlab.%: S=lab.vhd leddriver.vhd
#batchlab.%: T=batchlab_tb.vhd tb_print7seg.vhd
#batchlab.%: U=lab.ucf


# Misc functions that are good to have
include build/util.mk
# Setup simulation environment
include build/vsim.mk
# Setup synthesis environment
include build/xst.mk
# Setup backend flow environment
include build/xilinx-par.mk
# Setup tools for programming the FPGA
include build/digilentprog.mk



# Alternative synthesis methods
# The following is for ASIC synthesis
#include design_compiler.mk
# The following is for synthesis to a Xilinx target using Precision.
#include precision-xilinx.mk



