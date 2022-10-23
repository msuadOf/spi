//从机接收i_rx_ch1的数据   在上升沿的时候采样数据
module spi_slave (
    sys_clk,
    sys_rst_n,
    i_sck,
    i_cs,
    i_rx_ch1,
    i_rx_ch2,
    o_getdata
);
  input wire sys_clk;
  input wire sys_rst_n;
  input wire i_sck;
  input wire i_cs;
  input wire i_rx_ch1;
  input wire i_rx_ch2;
  output wire [16-1:0] o_getdata;


  reg [16-1:0] Rec_Data = 16'd0;
  reg [16-1:0] getdata = 16'b0;
  assign o_getdata = getdata;

  reg [5-1:0] Data_State = 5'd0;
  parameter D7_State = 5'd0;
  parameter D6_State = 5'd1;
  parameter D5_State = 5'd2;
  parameter D4_State = 5'd3;
  parameter D3_State = 5'd4;
  parameter D2_State = 5'd5;
  parameter D1_State = 5'd6;
  parameter D0_State = 5'd7;
  always @(posedge i_sck) begin
    if (i_cs == 1)  //i_cs为高，从机不响应
      Rec_Data <= 8'b0000_0000;
    else  //i_cs为低，从机开始接收数据
    begin
      if (i_sck == 1) begin
        case (Data_State)
          D7_State: begin
            Rec_Data[7]  <= i_rx_ch1;
            Rec_Data[15] <= i_rx_ch2;
            Data_State   <= D6_State;
          end
          D6_State: begin
            Rec_Data[6]  <= i_rx_ch1;
            Rec_Data[14] <= i_rx_ch2;
            Data_State   <= D5_State;
          end
          D5_State: begin
            Rec_Data[5]  <= i_rx_ch1;
            Rec_Data[13] <= i_rx_ch2;
            Data_State   <= D4_State;
          end
          D4_State: begin
            Rec_Data[4]  <= i_rx_ch1;
            Rec_Data[12] <= i_rx_ch2;
            Data_State   <= D3_State;
          end
          D3_State: begin
            Rec_Data[3]  <= i_rx_ch1;
            Rec_Data[11] <= i_rx_ch2;
            Data_State   <= D2_State;
          end
          D2_State: begin
            Rec_Data[2]  <= i_rx_ch1;
            Rec_Data[10] <= i_rx_ch2;
            Data_State   <= D1_State;
          end
          D1_State: begin
            Rec_Data[1] <= i_rx_ch1;
            Rec_Data[9] <= i_rx_ch2;
            Data_State  <= D0_State;
          end
          D0_State: begin
            Rec_Data[0] <= i_rx_ch1;
            Rec_Data[8] <= i_rx_ch2;
            Data_State  <= D7_State;
          end
          default: Data_State <= D7_State;
        endcase
      end
    end
  end

  always @(posedge i_cs) begin
    getdata <= Rec_Data;
  end
endmodule
