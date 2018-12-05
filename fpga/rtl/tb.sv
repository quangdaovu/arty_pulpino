`timescale 1ns/10ps

module tb;


logic clk;
logic reset;
logic fetch_en;


initial begin
    clk = 1'b0;
    reset = 1'b1;
    fetch_en = 1'b0;
    #150
    reset = 1'b0;
    #10000
    fetch_en = 1'b1;
    // sim_uart_load_data;
    
end

always #5 clk = ~clk;

logic uart_tx;
logic uart_rx;
wire pll_locked;

wire [3:0] sw;
wire [3:0] btn;
wire [3:0] led;

assign sw[3] = {fetch_en};
assign sw[2] = 1'b0;
assign sw[1] = 1'b0;
assign sw[0] = 1'b0;

assign btn[3] = {reset};
assign btn[2] = 1'b0;
assign btn[1] = 1'b0;
assign btn[0] = 1'b0;

assign pll_locked = led[3];

wire qspi_clk;
wire       qspi_cs_n;
wire [3:0] qspi_dq;

arty_top u_DUT (
    .xtal_in ( clk     ) ,
    .led     ( led     ) ,
    .sw      ( sw      ) ,
    .btn     ( btn     ) ,
    .qspi_clk( qspi_clk) ,
    .qspi_cs_n( qspi_cs_n) ,
    .qspi_dq( qspi_dq) ,
    .uart_rx ( uart_rx ) ,
    .uart_tx ( uart_tx ) 
);

N25Qxxx #(
    .memory_file ( "../../../../rtl/N25Q128A13E_VG12/sim/helloworld.vmf")
) u_N25Q128A13E (
    .S         ( qspi_cs_n    ) ,
    .C_        ( qspi_clk     ) ,
    .HOLD_DQ3  ( qspi_dq[3] ) ,
    .Vpp_W_DQ2 ( qspi_dq[2] ) ,
    .DQ1       ( qspi_dq[1] ) ,
    .DQ0       ( qspi_dq[0] ) ,
    .Vcc       ( 32'hffffffff ) 
);


 parameter  BAUDRATE      = 1562500; // 19200; //1562500; // 781250; // 1562500
 //parameter  BAUDRATE      = 115200; // 19200; //1562500; // 781250; // 1562500
  // use 8N1
  uart_bus
  #(
    .BAUD_RATE(BAUDRATE),
    .PARITY_EN(0)
  )
  uart
  (
    .rx         ( uart_tx ),
    .tx         ( uart_rx ),
    .rx_en      ( 1'b1    )
  );


`define SPI_STD     2'b00
`define SPI_QUAD_TX 2'b01
`define SPI_QUAD_RX 2'b10

`define SPI_SEMIPERIOD      50ns    //10Mhz SPI CLK

`define DELAY_BETWEEN_SPI   100ns

int                   num_stim,num_exp,num_cycles,num_err = 0;   // counters for statistics

logic                 more_stim = 1;

  logic [31:0]          spi_data;
  logic [31:0]          spi_data_recv;
  logic [31:0]          spi_addr;
  logic [31:0]          spi_addr_old;

  logic [63:0]          stimuli  [10000:0];                // array for the stimulus vectors
  task spi_send_cmd_addr;
    input          use_qspi;
    input    [7:0] command;
    input   [31:0] addr;
    begin
        uart_bus.send_char(command);
        uart_bus.send_char(addr[31:24]);
        uart_bus.send_char(addr[23:16]);
        uart_bus.send_char(addr[15:8]);
        uart_bus.send_char(addr[7:0]);
    end
  endtask

  task spi_send_data;
    input          use_qspi;
    input   [31:0] data;
    begin
            uart_bus.send_char(data[31:24]);
            uart_bus.send_char(data[23:16]);
            uart_bus.send_char(data[15:8]);
            uart_bus.send_char(data[7:0]);
    end
  endtask


    logic use_qspi = 0;
    
  task spi_load;
    begin
      $readmemh("../../../../sw/build/apps/helloworld/slm_files/spi_stim.txt", stimuli);  // read in the stimuli vectors  == address_value
    
      spi_addr        = stimuli[num_stim][63:32]; // assign address
      spi_data        = stimuli[num_stim][31:0];  // assign data

      $display("[SPI] Loading Instruction RAM");
      //#100  spi_send_cmd_addr(use_qspi,8'h2,spi_addr);

      spi_addr_old = spi_addr - 32'h4;

      while (more_stim)                        // loop until we have no more stimuli)
      begin
        spi_addr        = stimuli[num_stim][63:32]; // assign address
        spi_data        = stimuli[num_stim][31:0];  // assign data
        
        if(spi_addr[3:0]==4'd0) begin
            #100  spi_send_cmd_addr(use_qspi,8'h2,spi_addr);
        end

        if (spi_addr != (spi_addr_old + 32'h4))
        begin
          $display("[SPI] Prev address %h current addr %h",spi_addr_old,spi_addr);
          $display("[SPI] Loading Data RAM");
    //      #100 spi_csn  = 1'b1;
    //      #`DELAY_BETWEEN_SPI;
    //      spi_csn  = 1'b0;
          #100  spi_send_cmd_addr(use_qspi,8'h2,spi_addr);
        end
        spi_send_data(use_qspi,spi_data[31:0]);

        num_stim     = num_stim + 1;             // increment stimuli
        spi_addr_old = spi_addr;
        if (num_stim > 9999 | stimuli[num_stim]===64'bx ) // make sure we have more stimuli
          more_stim = 0;                    // if not set variable to 0, will prevent additional stimuli to be applied
      end                                   // end while loop
//      #100 spi_csn  = 1'b1;
      #`DELAY_BETWEEN_SPI;
    end
  endtask


task sim_uart_load_data;
begin
    #100;
    wait(reset==1'b0);
    
    spi_load;
    
    #30000;
    fetch_en = 1'b1;
    
    #1000_000_000;
    $stop;
end
endtask     


endmodule
