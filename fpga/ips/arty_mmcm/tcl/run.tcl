
if { ![info exists ::env(XILINX_PART)] } {
  set ::env(XILINX_PART) "xc7z020clg484-1"
}

if { ![info exists ::env(XILINX_BOARD)] } {
  set ::env(XILINX_BOARD) "em.avnet.com:zynq:zed:c"
}

set partNumber $::env(XILINX_PART)
set boardName  $::env(XILINX_BOARD)

set ila_name arty_mmcm

create_project $ila_name . -part $partNumber
set_property board $boardName [current_project]

create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name $ila_name

set_property -dict [list CONFIG.CLKOUT2_USED {false} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.MMCM_DIVCLK_DIVIDE {1} CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} CONFIG.MMCM_CLKOUT1_DIVIDE {1} CONFIG.NUM_OUT_CLKS {1} CONFIG.RESET_PORT {resetn} CONFIG.CLKOUT1_JITTER {151.636} CONFIG.CLKOUT2_JITTER {130.958} CONFIG.CLKOUT2_PHASE_ERROR {98.575}] [get_ips arty_mmcm]

generate_target {instantiation_template} [get_files ./$ila_name.srcs/sources_1/ip/$ila_name/$ila_name.xci]
generate_target all [get_files  ./$ila_name.srcs/sources_1/ip/$ila_name/$ila_name.xci]
create_ip_run [get_files -of_objects [get_fileset sources_1] ./$ila_name.srcs/sources_1/ip/$ila_name/$ila_name.xci]
launch_run -jobs 4 ${ila_name}_synth_1
wait_on_run ${ila_name}_synth_1

