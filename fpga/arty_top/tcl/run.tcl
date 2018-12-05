if { ![info exists ::env(BOARD) ]} {
  set ::env(BOARD) "artyboard"
}

if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7a35ticsg324-1L"
}

if { ![info exists ::env(XILINX_BOARD)] } {
  set ::env(XILINX_BOARD) "digilentinc.com:arty:part0:1.1"
}

if { ![info exists ::env(USE_ZERO_RISCY)] } {
  set ::env(USE_ZERO_RISCY) 0
}
if { ![info exists ::env(RISCY_RV32F)] } {
  set ::env(RISCY_RV32F) 0
}
if { ![info exists ::env(ZERO_RV32M)] } {
  set ::env(ZERO_RV32M) 0
}
if { ![info exists ::env(ZERO_RV32E)] } {
  set ::env(ZERO_RV32E) 0
}


set RTL ../../rtl
set IPS ../../ips
set FPGA_IPS ../ips
set FPGA_RTL ../rtl
set FPGA_PULPINO ../arty_pulpino

# create project
create_project arty_top . -part $::env(XILINX_PART)

if { [info exists ::env(XILINX_BOARD) ] } {
  set_property board $::env(XILINX_BOARD) [current_project]
}


# set up meaningful errors
source ../common/messages.tcl

# add fpga_system_top
#add_files -norecurse ../rtl/uart/source/uart.vhd
#add_files -norecurse ../rtl/uart_to_spi.v
add_files -norecurse ../rtl/arty_top.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add pulpino
if { $::env(USE_ZERO_RISCY)==0 & $::env(RISCY_RV32F)==1 } {
    add_files -norecurse ../arty_pulpino/pulpino.edn \
	../arty_pulpino/pulpino_stub.v  \
	../ips/xilinx_fp_fma/ip/xilinx_fp_fma_stub.vhdl \
	../ips/xilinx_fp_fma/ip/xilinx_fp_fma_stub.v \
	../arty_pulpino/xilinx_fp_fma_floating_point_v7_1_4_viv.edn \
	../arty_pulpino/xilinx_fp_fma_mult_gen_v12_0_12_viv.edn \
	../ips/arty_mmcm/ip/arty_mmcm.dcp
} else {
    add_files -norecurse ../arty_pulpino/pulpino.edn \
  ../arty_pulpino/pulpino_stub.v \
	../ips/arty_mmcm/ip/arty_mmcm.dcp
}

update_compile_order -fileset sources_1
add_files -fileset constrs_1 -norecurse constraints.xdc
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
get_property source_mgmt_mode [current_project]
set_property source_mgmt_mode DisplayOnly [current_project]
get_property source_mgmt_mode [current_project]

# save area
set_property strategy Flow_AreaOptimized_High [get_runs synth_1]

# synthesize
synth_design -rtl -name rtl_1

launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1
write_edif arty_top.edf

# export hardware design for sdk
write_hwdef -force -file ./arty_top.hwdef

# run implementation
source tcl/impl.tcl
