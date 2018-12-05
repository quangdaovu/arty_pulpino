define_design_lib work -path ./work

source -e -v ../tcl/library_setup.tcl

set_svf ../output/syn_mapped.svf

set TOP_DESIGN  pulpino

source -e -v ../tcl/read_design.tcl

elaborate ${TOP_DESIGN}
current_design ${TOP_DESIGN}
uniquify
link

source -e -v ../tcl/top.sdc

check_design    > ../report/check_design.rpt
check_timing    > ../report/check_timing.rpt

compile_ultra -gate_clock

report_qor                       > ../report/qor.rpt
report_timing                    > ../report/timing.rpt
report_constraint -all_vio       > ../report/vio.rpt
report_reference -hierachy -nosp > ../report/reference.rpt 

change_names -rules verilog -hierachy
write -format verilog -hier -output ../output/${TOP_DESIGN}_netlist.v ${TOP_DESIGN}
write -format ddc     -hier -output ../output/${TOP_DESIGN}_netlist.ddc ${TOP_DESIGN}


