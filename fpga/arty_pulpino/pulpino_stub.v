// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Thu Jan 25 15:51:26 2018
// Host        : QUANGDAO-PC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub pulpino_stub.v
// Design      : pulpino
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module pulpino(clk, rst_n, fetch_enable_i, spi_clk_i, spi_cs_i, 
  spi_mode_o, spi_sdo0_o, spi_sdo1_o, spi_sdo2_o, spi_sdo3_o, spi_sdi0_i, spi_sdi1_i, spi_sdi2_i, 
  spi_sdi3_i, spi_master_clk_o, spi_master_oen_o, spi_master_csn0_o, spi_master_csn1_o, 
  spi_master_csn2_o, spi_master_csn3_o, spi_master_mode_o, spi_master_sdo0_o, 
  spi_master_sdo1_o, spi_master_sdo2_o, spi_master_sdo3_o, spi_master_sdi0_i, 
  spi_master_sdi1_i, spi_master_sdi2_i, spi_master_sdi3_i, uart_tx, uart_rx, uart_rts, 
  uart_dtr, uart_cts, uart_dsr, scl_i, scl_o, scl_oen_o, sda_i, sda_o, sda_oen_o, gpio_in, gpio_out, 
  gpio_dir, tck_i, trstn_i, tms_i, tdi_i, tdo_o)
/* synthesis syn_black_box black_box_pad_pin="clk,rst_n,fetch_enable_i,spi_clk_i,spi_cs_i,spi_mode_o[1:0],spi_sdo0_o,spi_sdo1_o,spi_sdo2_o,spi_sdo3_o,spi_sdi0_i,spi_sdi1_i,spi_sdi2_i,spi_sdi3_i,spi_master_clk_o,spi_master_oen_o[3:0],spi_master_csn0_o,spi_master_csn1_o,spi_master_csn2_o,spi_master_csn3_o,spi_master_mode_o[1:0],spi_master_sdo0_o,spi_master_sdo1_o,spi_master_sdo2_o,spi_master_sdo3_o,spi_master_sdi0_i,spi_master_sdi1_i,spi_master_sdi2_i,spi_master_sdi3_i,uart_tx,uart_rx,uart_rts,uart_dtr,uart_cts,uart_dsr,scl_i,scl_o,scl_oen_o,sda_i,sda_o,sda_oen_o,gpio_in[31:0],gpio_out[31:0],gpio_dir[31:0],tck_i,trstn_i,tms_i,tdi_i,tdo_o" */;
  input clk;
  input rst_n;
  input fetch_enable_i;
  input spi_clk_i;
  input spi_cs_i;
  output [1:0]spi_mode_o;
  output spi_sdo0_o;
  output spi_sdo1_o;
  output spi_sdo2_o;
  output spi_sdo3_o;
  input spi_sdi0_i;
  input spi_sdi1_i;
  input spi_sdi2_i;
  input spi_sdi3_i;
  output spi_master_clk_o;
  output [3:0]spi_master_oen_o;
  output spi_master_csn0_o;
  output spi_master_csn1_o;
  output spi_master_csn2_o;
  output spi_master_csn3_o;
  output [1:0]spi_master_mode_o;
  output spi_master_sdo0_o;
  output spi_master_sdo1_o;
  output spi_master_sdo2_o;
  output spi_master_sdo3_o;
  input spi_master_sdi0_i;
  input spi_master_sdi1_i;
  input spi_master_sdi2_i;
  input spi_master_sdi3_i;
  output uart_tx;
  input uart_rx;
  output uart_rts;
  output uart_dtr;
  input uart_cts;
  input uart_dsr;
  input scl_i;
  output scl_o;
  output scl_oen_o;
  input sda_i;
  output sda_o;
  output sda_oen_o;
  input [31:0]gpio_in;
  output [31:0]gpio_out;
  output [31:0]gpio_dir;
  input tck_i;
  input trstn_i;
  input tms_i;
  input tdi_i;
  output tdo_o;
endmodule
