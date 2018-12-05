## clocks
#create_clock -period 25.000 -name clk      [get_nets {pulpino_wrap_i/clk}]
#create_clock -period 40.000 -name spi_sck  [get_nets {pulpino_wrap_i/spi_clk_i}]
#create_clock -period 40.000 -name tck      [get_nets {pulpino_wrap_i/tck_i}]
#
## define false paths between all clocks
#set_clock_groups -asynchronous \
#                 -group { clk } \
#                 -group { spi_sck } \
#                 -group { tck }
#
#
## ----------------------------------------------------------------------------
## System Clock - RSTn
## ----------------------------------------------------------------------------
#set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports {clk_i}];
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk_i}];
#
#set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { rst_n }]; #rst_n
#
## ----------------------------------------------------------------------------
## User LEDs
## ----------------------------------------------------------------------------
#set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { LD0_o[0] }]; #LD0_o[0]
#set_property -dict { PACKAGE_PIN F6    IOSTANDARD LVCMOS33 } [get_ports { LD0_o[1] }]; #LD0_o[1]
#set_property -dict { PACKAGE_PIN G6    IOSTANDARD LVCMOS33 } [get_ports { LD0_o[2] }]; #LD0_o[2]
#set_property -dict { PACKAGE_PIN G4    IOSTANDARD LVCMOS33 } [get_ports { LD1_o[0] }]; #LD1_o[0]
#set_property -dict { PACKAGE_PIN J4    IOSTANDARD LVCMOS33 } [get_ports { LD1_o[1] }]; #LD1_o[1]
#set_property -dict { PACKAGE_PIN G3    IOSTANDARD LVCMOS33 } [get_ports { LD1_o[2] }]; #LD1_o[2]
#set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { LD2_o[0] }]; #LD2_o[0]
#set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports { LD2_o[1] }]; #LD2_o[1]
#set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports { LD2_o[2] }]; #LD2_o[2]
#set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { LD3_o[0] }]; #LD3_o[0]
#set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { LD3_o[1] }]; #LD3_o[1]
#set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { LD3_o[2] }]; #LD3_o[2]
#
#set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { LD_o[0] }]; #LD_o[0]
#set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { LD_o[1] }]; #LD_o[1]
#set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { LD_o[2] }]; #LD_o[2]
#set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { LD_o[3] }]; #LD_o[3]
#
## ----------------------------------------------------------------------------
## User Push Buttons
## ----------------------------------------------------------------------------
#set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { btn_i[0] }]; #btn_i[0]
#set_property -dict { PACKAGE_PIN C9    IOSTANDARD LVCMOS33 } [get_ports { btn_i[1] }]; #btn_i[1]
#set_property -dict { PACKAGE_PIN B9    IOSTANDARD LVCMOS33 } [get_ports { btn_i[2] }]; #btn_i[2]
#set_property -dict { PACKAGE_PIN B8    IOSTANDARD LVCMOS33 } [get_ports { btn_i[3] }]; #btn_i[3]
#
## ----------------------------------------------------------------------------
## User DIP Switches
## ----------------------------------------------------------------------------
#set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { sw_i[0] }]; # "SW0"
#set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVCMOS33 } [get_ports { sw_i[1] }]; # "SW1"
#set_property -dict { PACKAGE_PIN C10   IOSTANDARD LVCMOS33 } [get_ports { sw_i[2] }]; # "SW2"
#set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVCMOS33 } [get_ports { sw_i[3] }]; # "SW3"
#
## ----------------------------------------------------------------------------
## USB-UART
## ----------------------------------------------------------------------------
#set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_tx }]; #uart_tx
#set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_rx }]; #uart_rx
#
## ----------------------------------------------------------------------------
## QSPI
## ----------------------------------------------------------------------------
#set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports qspi_cs_o];
#set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports {qspi_dq[0]}];
#set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {qspi_dq[1]}];
#set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {qspi_dq[2]}];
#set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {qspi_dq[3]}];
#
## physical constraints
## source tcl/floorplan.xdc
#
#save_constraints

# set for RuntimeOptimized implementation
# set_property "steps.opt_design.args.directive" "RuntimeOptimized"   [get_runs impl_1]
# set_property "steps.place_design.args.directive" "RuntimeOptimized" [get_runs impl_1]
# set_property "steps.route_design.args.directive" "RuntimeOptimized" [get_runs impl_1]
set_property strategy Area_Explore [get_runs impl_1]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

launch_runs impl_1
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

# report area utilization
report_utilization -hierarchical -hierarchical_depth 1 -file arty_top.txt
report_utilization -hierarchical -hierarchical_depth 2 -cells u_pulpino -file pulpino.txt

report_timing_summary -file arty_top_timing_summary.txt
report_timing         -file arty_top_timing.txt         -max_paths 10

# output Verilog netlist + SDC for timing simulation
write_verilog -force -mode timesim -cell u_pulpino ../simu/pulpino_impl.v
write_sdf     -force -cell u_pulpino ../simu/pulpino_impl.sdf

if { [info exists ::env(PROBES)] } {
   # create new design run for probes
   create_run impl_2 -parent_run synth_1 -flow {Vivado Implementation 2014}
   current_run [get_runs impl_2]
   set_property incremental_checkpoint arty_top.runs/impl_1/arty_top_top_routed.dcp [get_runs impl_2]
   set_property strategy Flow_RuntimeOptimized [get_runs impl_2]
   open_run synth_1
   #link_design -name netlist_1
   source tcl/probes.tcl
   save_constraints
   reset_run impl_2

   # set for RuntimeOptimized implementation
   set_property "steps.opt_design.args.directive" "RuntimeOptimized" [get_runs impl_2]
   set_property "steps.place_design.args.directive" "RuntimeOptimized" [get_runs impl_2]
   set_property "steps.route_design.args.directive" "RuntimeOptimized" [get_runs impl_2]

   launch_runs impl_2 -to_step write_bitstream
   wait_on_run impl_2
}

