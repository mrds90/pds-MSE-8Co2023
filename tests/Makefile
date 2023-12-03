
TOPLEVEL_LANG = vhdl

PWD=$(shell pwd)

SOURCEDIR := $(PWD)/../PDS_Test.srcs/sources_1/new

VHDL_SOURCES := $(shell find $(SOURCEDIR) -name '*.vhd')

TOPLEVEL := filtro_fir_cadena #name of entity top
MODULE   := test_my_design
SIM := GHDL

$(shell mkdir -p ./waveforms)
SIM_ARGS+=--vcd=./waveforms/cont_dig.vcd #name of the file gtkwave

include $(shell cocotb-config --makefiles)/Makefile.sim

