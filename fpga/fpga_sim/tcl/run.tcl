
# create project
create_project arty_top . -part $::env(XILINX_PART) -force
set_property board $::env(XILINX_BOARD) [current_project]

source ../arty_pulpino/tcl/ips_inc_dirs.tcl

# set up meaningful errors
source ../common/messages.tcl

source ../arty_pulpino/tcl/ips_src_files.tcl
source ../arty_pulpino/tcl/src_files.tcl

# add memory cuts
add_files -norecurse $FPGA_IPS/arty_mem_8192x32/ip/xilinx_mem_8192x32.dcp
add_files -norecurse $FPGA_IPS/arty_dmem_8192x32/ip/xilinx_dmem_8192x32.dcp

source ../arty_pulpino/tcl/ips_add_files.tcl

# add components
add_files -norecurse $SRC_COMPONENTS

# add pulpino
add_files -norecurse $SRC_PULPINO


# add FPGA top
add_files -norecurse ../rtl/uart/source/uart.vhd
add_files -norecurse ../rtl/uart_to_spi.v
add_files -norecurse ../rtl/arty_top.v

set_property top arty_top [current_fileset]

# needed only if used in batch mode
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

add_files -fileset sim_1 -norecurse -scan_for_includes { \
/home/fdi/halley/mysoc/fpga/rtl/tb.sv \
/home/fdi/halley/mysoc/tb/uart.sv \
/home/fdi/halley/mysoc/fpga/ips/arty_mmcm/arty_mmcm.srcs/sources_1/ip/arty_mmcm/arty_mmcm.v \
/home/fdi/halley/mysoc/fpga/ips/arty_mmcm/arty_mmcm.srcs/sources_1/ip/arty_mmcm/arty_mmcm_clk_wiz.v \
/home/fdi/halley/mysoc/fpga/ips/arty_dmem_8192x32/xilinx_dmem_8192x32.srcs/sources_1/ip/xilinx_dmem_8192x32/xilinx_dmem_8192x32_sim_netlist.v  \
/home/fdi/halley/mysoc/fpga/ips/arty_mem_8192x32/xilinx_mem_8192x32.srcs/sources_1/ip/xilinx_mem_8192x32/xilinx_mem_8192x32_sim_netlist.v \
/home/fdi/halley/mysoc/fpga/ips/arty_dmem_8192x32/xilinx_dmem_8192x32.srcs/sources_1/ip/xilinx_dmem_8192x32/xilinx_dmem_8192x32_sim_netlist.v \
}

add_files -fileset sim_1 -norecurse -scan_for_includes { \
    /home/fdi/halley/mysoc/fpga/rtl/N25Q128A13E_VG12/code/N25Qxxx.v \
}

set_property include_dirs {
    ../.././rtl/includes \
    ../.././ips/apb/apb_event_unit/./include/ \
    ../.././ips/axi/axi_node/. \
    ../.././ips/riscv/include \
    ../.././ips/riscv/include \
    ../.././ips/apb/apb_i2c/. \
    ../.././ips/adv_dbg_if/rtl \
    ../rtl/N25Q128A13E_VG12/ \
    ../rtl/N25Q128A13E_VG12/sim \
} [get_filesets sim_1] 

set_property verilog_define {
    PULP_FPGA_EMUL=1  \
    RISCV=1 \
    N25Q128A13E=1 \
} [get_filesets sim_1] 

set_property top tb [get_filesets sim_1]

# stdout/uart required by uart_bus.sv 
file mkdir stdout
#exec touch stdout/uart

launch_simulation 
open_wave_config {tb_behav.wcfg}

