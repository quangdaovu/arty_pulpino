create_clock -period  4.700 -name clk      [get_port {clk}]
create_clock -period 40.000 -name spi_sck  [get_port {spi_clk_i}]
create_clock -period 40.000 -name tck      [get_port {tck_i}]

# define false paths between all clocks
set_clock_groups -asynchronous \
                 -group { clk } \
                 -group { spi_sck } \
                 -group { tck }

set_ideal_network [get_ports {clk spi_clk_i tck_i rst_n}]
set_dont_touch_network [get_ports {clk spi_clk_i tck_i rst_n}]

#set_input_delay -max 2.0 -clock clk [get_ports {}]
#set_input_delay -min 1.0 -clock clk [get_ports {}]
#set_output_delay -max 2.0 -clock clk [get_ports {}]
#set_output_delay -min 1.0 -clock clk [get_ports {}]

#group_path -name INPUT_PATH -from [remove_from_collection [all_inputs] [get_ports {clk spi_clk_i tck_i rst_n}]]

#group_path -name OUTPUT_PATH -to [all_outputs]

set_wire_load_mode top
set_wire_load_model -name ZeroWireload

#set_driving_cell
#set_load []
