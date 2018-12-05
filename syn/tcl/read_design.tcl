
###############################################
# read DESIGN 
###############################################
set DIR_DESIGN "../../"

set RTL_INC_PATH [list ${DIR_DESIGN}/rtl/includes \
    ${DIR_DESIGN}/ips/apb/apb_event_unit/include \
    ${DIR_DESIGN}/ips/axi/axi_node \
    ${DIR_DESIGN}/ips/riscv/include \
    ${DIR_DESIGN}/ips/riscv/include \
    ${DIR_DESIGN}/ips/apb/apb_i2c \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl \	
]
set search_path [concat $search_path $RTL_INC_PATH]

# apb_gpio
set SRC_APB_GPIO " \
    ${DIR_DESIGN}/ips/apb/apb_gpio/apb_gpio.sv \
"

# axi_slice_dc
set SRC_AXI_SLICE_DC " \
    ${DIR_DESIGN}/ips/axi/axi_slice_dc/axi_slice_dc_master.sv \
    ${DIR_DESIGN}/ips/axi/axi_slice_dc/axi_slice_dc_slave.sv \
    ${DIR_DESIGN}/ips/axi/axi_slice_dc/dc_data_buffer.v \
    ${DIR_DESIGN}/ips/axi/axi_slice_dc/dc_full_detector.v \
    ${DIR_DESIGN}/ips/axi/axi_slice_dc/dc_synchronizer.v \
    ${DIR_DESIGN}/ips/axi/axi_slice_dc/dc_token_ring_fifo_din.v \
    ${DIR_DESIGN}/ips/axi/axi_slice_dc/dc_token_ring_fifo_dout.v \
    ${DIR_DESIGN}/ips/axi/axi_slice_dc/dc_token_ring.v \
"

# apb_event_unit
set SRC_APB_EVENT_UNIT " \
    ${DIR_DESIGN}/ips/apb/apb_event_unit/apb_event_unit.sv \
    ${DIR_DESIGN}/ips/apb/apb_event_unit/generic_service_unit.sv \
    ${DIR_DESIGN}/ips/apb/apb_event_unit/sleep_unit.sv \
"

# axi_node
set SRC_AXI_NODE " \
    ${DIR_DESIGN}/ips/axi/axi_node/apb_regs_top.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_address_decoder_AR.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_address_decoder_AW.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_address_decoder_BR.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_address_decoder_BW.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_address_decoder_DW.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_AR_allocator.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_ArbitrationTree.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_AW_allocator.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_BR_allocator.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_BW_allocator.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_DW_allocator.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_FanInPrimitive_Req.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_multiplexer.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_node.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_node_wrap.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_node_wrap_with_slices.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_regs_top.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_request_block.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_response_block.sv \
    ${DIR_DESIGN}/ips/axi/axi_node/axi_RR_Flag_Req.sv \
"
# riscv
set SRC_RISCV " \
    ${DIR_DESIGN}/ips/riscv/include/riscv_defines.sv \
    ${DIR_DESIGN}/ips/riscv/include/riscv_tracer_defines.sv \
    ${DIR_DESIGN}/ips/riscv/include/apu_core_package.sv \
    ${DIR_DESIGN}/ips/riscv/include/apu_macros.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_alu.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_alu_div.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_compressed_decoder.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_controller.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_cs_registers.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_debug_unit.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_decoder.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_int_controller.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_ex_stage.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_hwloop_controller.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_hwloop_regs.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_id_stage.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_if_stage.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_load_store_unit.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_mult.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_prefetch_buffer.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_prefetch_L0_buffer.sv \
    ${DIR_DESIGN}/ips/riscv/riscv_core.sv \
"
# riscv_regfile_fpga
set SRC_RISCV_REGFILE_FPGA " \
    ${DIR_DESIGN}/ips/riscv/riscv_register_file_ff.sv \
"

# apb_pulpino
set SRC_APB_PULPINO " \
    ${DIR_DESIGN}/ips/apb/apb_pulpino/apb_pulpino.sv \
"

# axi_mem_if_DP
set SRC_AXI_MEM_IF_DP " \
    ${DIR_DESIGN}/ips/axi/axi_mem_if_DP/axi_mem_if_MP_Hybrid_multi_bank.sv \
    ${DIR_DESIGN}/ips/axi/axi_mem_if_DP/axi_mem_if_multi_bank.sv \
    ${DIR_DESIGN}/ips/axi/axi_mem_if_DP/axi_mem_if_DP_hybr.sv \
    ${DIR_DESIGN}/ips/axi/axi_mem_if_DP/axi_mem_if_DP.sv \
    ${DIR_DESIGN}/ips/axi/axi_mem_if_DP/axi_mem_if_SP.sv \
    ${DIR_DESIGN}/ips/axi/axi_mem_if_DP/axi_read_only_ctrl.sv \
    ${DIR_DESIGN}/ips/axi/axi_mem_if_DP/axi_write_only_ctrl.sv \
"

# apb_fll_if
set SRC_APB_FLL_IF " \
    ${DIR_DESIGN}/ips/apb/apb_fll_if/apb_fll_if.sv \
"

# axi_slice
set SRC_AXI_SLICE " \
    ${DIR_DESIGN}/ips/axi/axi_slice/axi_ar_buffer.sv \
    ${DIR_DESIGN}/ips/axi/axi_slice/axi_aw_buffer.sv \
    ${DIR_DESIGN}/ips/axi/axi_slice/axi_b_buffer.sv \
    ${DIR_DESIGN}/ips/axi/axi_slice/axi_buffer.sv \
    ${DIR_DESIGN}/ips/axi/axi_slice/axi_r_buffer.sv \
    ${DIR_DESIGN}/ips/axi/axi_slice/axi_slice.sv \
    ${DIR_DESIGN}/ips/axi/axi_slice/axi_w_buffer.sv \
"

# apb_uart
set SRC_APB_UART " \
    ${DIR_DESIGN}/ips/apb/apb_uart/apb_uart.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/slib_clock_div.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/slib_counter.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/slib_edge_detect.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/slib_fifo.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/slib_input_filter.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/slib_input_sync.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/slib_mv_filter.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/uart_baudgen.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/uart_interrupt.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/uart_receiver.vhd \
    ${DIR_DESIGN}/ips/apb/apb_uart/uart_transmitter.vhd \
"

# apb_spi_master
set SRC_APB_SPI_MASTER " \
    ${DIR_DESIGN}/ips/apb/apb_spi_master/apb_spi_master.sv \
    ${DIR_DESIGN}/ips/apb/apb_spi_master/spi_master_apb_if.sv \
    ${DIR_DESIGN}/ips/apb/apb_spi_master/spi_master_clkgen.sv \
    ${DIR_DESIGN}/ips/apb/apb_spi_master/spi_master_controller.sv \
    ${DIR_DESIGN}/ips/apb/apb_spi_master/spi_master_fifo.sv \
    ${DIR_DESIGN}/ips/apb/apb_spi_master/spi_master_rx.sv \
    ${DIR_DESIGN}/ips/apb/apb_spi_master/spi_master_tx.sv \
"

# apb_timer
set SRC_APB_TIMER " \
    ${DIR_DESIGN}/ips/apb/apb_timer/apb_timer.sv \
    ${DIR_DESIGN}/ips/apb/apb_timer/timer.sv \
"

# axi2apb
set SRC_AXI2APB " \
    ${DIR_DESIGN}/ips/axi/axi2apb/AXI_2_APB.sv \
    ${DIR_DESIGN}/ips/axi/axi2apb/AXI_2_APB_32.sv \
    ${DIR_DESIGN}/ips/axi/axi2apb/axi2apb.sv \
    ${DIR_DESIGN}/ips/axi/axi2apb/axi2apb32.sv \
"

# axi_spi_slave
set SRC_AXI_SPI_SLAVE " \
    ${DIR_DESIGN}/ips/axi/axi_spi_slave/axi_spi_slave.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_slave/spi_slave_axi_plug.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_slave/spi_slave_cmd_parser.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_slave/spi_slave_controller.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_slave/spi_slave_dc_fifo.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_slave/spi_slave_regs.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_slave/spi_slave_rx.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_slave/spi_slave_syncro.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_slave/spi_slave_tx.sv \
"

# apb_i2c
set SRC_APB_I2C " \
    ${DIR_DESIGN}/ips/apb/apb_i2c/apb_i2c.sv \
    ${DIR_DESIGN}/ips/apb/apb_i2c/i2c_master_bit_ctrl.sv \
    ${DIR_DESIGN}/ips/apb/apb_i2c/i2c_master_byte_ctrl.sv \
    ${DIR_DESIGN}/ips/apb/apb_i2c/i2c_master_defines.sv \
"

# adv_dbg_if
set SRC_ADV_DBG_IF " \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adbg_axi_biu.sv \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adbg_axi_module.sv \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adbg_crc32.v \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adbg_or1k_biu.sv \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adbg_or1k_module.sv \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adbg_or1k_status_reg.sv \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adbg_top.sv \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/bytefifo.v \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/syncflop.v \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/syncreg.v \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adbg_tap_top.v \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adv_dbg_if.sv \
    ${DIR_DESIGN}/ips/adv_dbg_if/rtl/adbg_axionly_top.sv \
"

# axi_spi_master
set SRC_AXI_SPI_MASTER " \
    ${DIR_DESIGN}/ips/axi/axi_spi_master/axi_spi_master.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_master/spi_master_axi_if.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_master/spi_master_clkgen.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_master/spi_master_controller.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_master/spi_master_fifo.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_master/spi_master_rx.sv \
    ${DIR_DESIGN}/ips/axi/axi_spi_master/spi_master_tx.sv \
"

# core2axi
set SRC_CORE2AXI " \
    ${DIR_DESIGN}/ips/axi/core2axi/core2axi.sv \
"

# apb_node
set SRC_APB_NODE " \
    ${DIR_DESIGN}/ips/apb/apb_node/apb_node.sv \
    ${DIR_DESIGN}/ips/apb/apb_node/apb_node_wrap.sv \
"

# apb2per
set SRC_APB2PER " \
    ${DIR_DESIGN}/ips/apb/apb2per/apb2per.sv \
"

# components
set SRC_COMPONENTS " \
   ${DIR_DESIGN}/rtl/components/cluster_clock_gating.sv \
   ${DIR_DESIGN}/rtl/components/cluster_clock_inverter.sv \
   ${DIR_DESIGN}/rtl/components/cluster_clock_mux2.sv \
   ${DIR_DESIGN}/rtl/components/rstgen.sv \
   ${DIR_DESIGN}/rtl/components/pulp_clock_inverter.sv \
   ${DIR_DESIGN}/rtl/components/pulp_clock_mux2.sv \
   ${DIR_DESIGN}/rtl/components/generic_fifo.sv \
   ${DIR_DESIGN}/rtl/components/sp_ram.sv \
"

# pulpino
set SRC_PULPINO " \
   ${DIR_DESIGN}/rtl/axi2apb_wrap.sv \
   ${DIR_DESIGN}/rtl/periph_bus_wrap.sv \
   ${DIR_DESIGN}/rtl/core2axi_wrap.sv \
   ${DIR_DESIGN}/rtl/axi_node_intf_wrap.sv \
   ${DIR_DESIGN}/rtl/axi_spi_slave_wrap.sv \
   ${DIR_DESIGN}/rtl/axi_slice_wrap.sv \
   ${DIR_DESIGN}/rtl/axi_mem_if_SP_wrap.sv \
   ${DIR_DESIGN}/rtl/core_region.sv \
   ${DIR_DESIGN}/rtl/instr_ram_wrap.sv \
   ${DIR_DESIGN}/rtl/sp_ram_wrap.sv \
   ${DIR_DESIGN}/rtl/boot_code.sv \
   ${DIR_DESIGN}/rtl/boot_rom_wrap.sv \
   ${DIR_DESIGN}/rtl/peripherals.sv \
   ${DIR_DESIGN}/rtl/ram_mux.sv \
   ${DIR_DESIGN}/rtl/pulpino_top.sv \
   ${DIR_DESIGN}/rtl/clk_rst_gen.sv \
   ${DIR_DESIGN}/fpga/rtl/pulpino_wrap.v \
"

analyze -f sverilog $SRC_APB_GPIO
analyze -f sverilog $SRC_AXI_SLICE_DC
analyze -f sverilog $SRC_APB_EVENT_UNIT
analyze -f sverilog $SRC_AXI_NODE
analyze -f sverilog $SRC_RISCV
analyze -f sverilog $SRC_RISCV_REGFILE_FPGA
analyze -f sverilog $SRC_APB_PULPINO
analyze -f sverilog $SRC_AXI_MEM_IF_DP
analyze -f sverilog $SRC_APB_FLL_IF
analyze -f sverilog $SRC_AXI_SLICE
analyze -f vhdl     $SRC_APB_UART
analyze -f sverilog $SRC_APB_SPI_MASTER
analyze -f sverilog $SRC_APB_TIMER
analyze -f sverilog $SRC_AXI2APB
analyze -f sverilog $SRC_AXI_SPI_SLAVE
analyze -f sverilog $SRC_APB_I2C
analyze -f sverilog $SRC_ADV_DBG_IF
analyze -f sverilog $SRC_AXI_SPI_MASTER
analyze -f sverilog $SRC_CORE2AXI
analyze -f sverilog $SRC_APB_NODE
analyze -f sverilog $SRC_APB2PER
analyze -f sverilog $SRC_COMPONENTS
analyze -f sverilog $SRC_PULPINO

