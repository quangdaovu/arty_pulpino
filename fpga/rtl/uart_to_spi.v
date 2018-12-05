module uart_to_spi (
    input  clk,
    input  rst_n,
    input  uart_rxd,
    output uart_txd,

    input   spi_din,
    output reg spi_cs,
    output reg spi_dout,
    output reg spi_clk
);
    
wire [7:0] send_data;
wire       send_end;
wire [7:0] receive_data;
wire       receive_data_vld;
wire       rs232_clk8_en;

reg       spi_finish;
wire [31:0]spi_rddata;

assign send_data = spi_rddata[7:0]; // TODO
    
uart #(
    .baud            ( 115200  ),
    .clock_frequency ( 50000000)
) u_uart (
    .clock               ( clk              ) ,
    .reset               ( ~rst_n           ) ,
    .data_stream_in      ( send_data        ) , // TODO
    .data_stream_in_stb  ( spi_finish       ) , // TODO
    .data_stream_in_ack  ( send_end         ) , // TODO
    .data_stream_out     ( receive_data     ) ,
    .data_stream_out_stb ( receive_data_vld ) ,
    .tx                  ( uart_txd         ) ,
    .rx                  ( uart_rxd         ) 
) ;

// byte to spi-slave format
//
parameter TT = 1+4+4*4; // 1(cmd) + 4(addr) + 4(data)*4(words) * 
reg [7:0] byte_cnt;
reg [8*TT-1:0] byte_buf;
reg is_cmd_addr;
reg spi_byte_mode;
reg spi_start ;
reg [8*TT-1:0] spi_wrdata;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        byte_cnt <= 'd0;
        byte_buf <= 'd0;
        is_cmd_addr <= 'b1;
        spi_byte_mode <= 1'b1;
        spi_start <= 1'b0;
        spi_wrdata <= 'd0;
    end
    else if(receive_data_vld) begin
        byte_buf <= {byte_buf[8*(TT-1)-1:0], receive_data};
        byte_cnt <= byte_cnt == (is_cmd_addr ? TT-1 : 'd3) ? 'd0 : byte_cnt + 'd1;
        is_cmd_addr <= byte_cnt==(TT-1) ? 1'b1 : is_cmd_addr;
        if((is_cmd_addr ? (TT-1) : 'd3)==byte_cnt) begin 
            spi_start <= 1'b1;
            spi_byte_mode <= is_cmd_addr;
            spi_wrdata <= {byte_buf[8*(TT-1)-1:0], receive_data};
        end
    end
    else 
        spi_start <= 1'b0;
end


/////////////////////////////////////////////////////////
// simple SPI master interface
//
/////////////////////////////////////////////////////////
parameter   IDLE   = 2'b00,
            TRANS  = 2'b01,
            END    = 2'b10;

reg [1:0]   cur_state;
reg [1:0]   next_state;

reg [7:0]   spi_clk_cnt;
reg         spi_clk_d1;

wire        pos_spi_clk;
wire        neg_spi_clk;
reg [7:0]   spi_cnt;
reg [31:0]  spi_rx_reg;

wire        start_pos;
reg         start_en;
reg         start_en_d1;

always @(posedge clk or negedge rst_n)
    if(!rst_n)
        begin
            spi_clk_cnt <= 8'h0;
            spi_clk <= 1'b1;
        end
    else if(!spi_cs)
        if(spi_clk_cnt == 8'h8)
            begin
                spi_clk_cnt <= 8'h0;
                spi_clk <= !spi_clk;
            end
        else 
            spi_clk_cnt <= spi_clk_cnt + 1'b1;
    else 
        begin
            spi_clk_cnt <= 8'h0;
            spi_clk <= 1'b1;
        end 
        
always @(posedge clk or negedge rst_n)
    if(!rst_n)
        spi_clk_d1 <= 1'b0;
    else
        spi_clk_d1 <= spi_clk;
        
assign pos_spi_clk = spi_clk & (!spi_clk_d1);
assign neg_spi_clk = (!spi_clk) & spi_clk_d1;
            
always @(posedge clk or negedge rst_n)
    if(!rst_n)
        begin
            start_en <= 1'b0;
            start_en_d1 <= 1'b0;
        end
    else 
        begin 
            start_en <= spi_start;
            start_en_d1 <= start_en;
        end
        
assign start_pos = start_en & (!start_en_d1);
            
always @(posedge clk or negedge rst_n)
    if(!rst_n)
        cur_state <= IDLE;
    else 
        cur_state <= next_state;
        
    
always @(*)
    case (cur_state)
        IDLE:
            if (start_pos)
                next_state = TRANS;
            else    
                next_state = IDLE;
        TRANS:
            if (spi_cnt == (spi_byte_mode ? TT*8 : 8'd32))
                next_state = END;
            else
                next_state = TRANS;
        END:
                next_state = IDLE;
        default: next_state = IDLE;
    endcase
    
always @(posedge clk or negedge rst_n)
    if(!rst_n)
        spi_cnt <= 8'h0;
    else if ((cur_state == TRANS) & (pos_spi_clk))
        spi_cnt <= spi_cnt + 1'b1;
    else if (cur_state == IDLE)
        spi_cnt <= 8'h0;
               
always @(posedge clk or negedge rst_n)
    if(!rst_n)
        spi_cs <= 1'b1;
    else 
        spi_cs <= !(cur_state == TRANS);
        
always @(posedge clk or negedge rst_n)
    if(!rst_n)
        spi_dout <= 1'b0;
    else if(cur_state == IDLE) 
        spi_dout <= 1'b1;
    else if((cur_state == TRANS) & (neg_spi_clk))
        spi_dout <= spi_byte_mode ? spi_wrdata[8*TT-1-spi_cnt] : spi_wrdata [31 - spi_cnt];

always @(posedge clk or negedge rst_n)
    if(!rst_n)
        spi_rx_reg <= 32'h0;
    else if((cur_state == TRANS) & (pos_spi_clk))
        spi_rx_reg <= {spi_rx_reg[30:0],spi_din};

always @(posedge clk or negedge rst_n)
    if(!rst_n)    
        spi_finish <= 1'b0;
    else if(cur_state == END)
        spi_finish <= 1'b1;
    else if(cur_state == TRANS)
        spi_finish <= 1'b0;
    
assign spi_rddata = spi_rx_reg[31:0];
      
endmodule 
