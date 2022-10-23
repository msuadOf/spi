//采用SPI模式0：上升沿采样数据，下降沿切换数据
module spi_master (
    sys_clk,
    sys_rst_n,
    o_sck,
    o_cs,
    o_tx_ch1,
    o_tx_ch2,
    i_send_data
);
  input sys_clk;
  input sys_rst_n;
  output reg o_sck;
  output reg o_cs;
  output reg o_tx_ch1;
  output reg o_tx_ch2;
  input wire [8*2-1:0] i_send_data;

  reg [8*2-1:0] Send_Data;  //所要发送的数据

  /*input buffer*/
  always @(i_send_data) begin
    Send_Data = i_send_data;
  end

  /*构造状态机*/
  reg [5-1:0] Data_State = 5'd0;
  parameter D7_State = 5'd0;  //发送最高位数据-状态
  parameter D6_State = 5'd2;
  parameter D5_State = 5'd4;
  parameter D4_State = 5'd6;
  parameter D3_State = 5'd8;
  parameter D2_State = 5'd10;
  parameter D1_State = 5'd12;
  parameter D0_State = 5'd14;  //发送最低位数据-状态
  parameter CS_State = 5'd16;  //CS change high
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if(sys_rst_n == 0)//复位
    begin
      o_sck    <= 1'b0;  //o_sck初始电平为低
      o_cs     <= 1'b1;  //o_cs初始电平为高
      o_tx_ch1 <= 1'b0;  //o_tx_ch1初始电平为低
      o_tx_ch2 <= 1'b0;  //o_tx_ch2初始电平为低
    end else  //产生SPI时序
    begin
      o_cs <= 0;  //o_cs拉低准备数据传输
      case (Data_State)
        5'd1,5'd3,5'd5,5'd7,5'd9,5'd11,5'd13,5'd15://每次放置数据完毕后 在此拉高时钟线，便于下次的下降沿产生
       begin
          o_sck      <= 1'b1;  //准备在下降沿放置数据，提前将o_sck拉高
          Data_State <= Data_State + 5'd1;  //切换为数据放置状态(每发完1bit数据进入此一次，将时钟线拉高)
        end
        D7_State://第7位数据发送状态
        begin
          o_tx_ch1   <= Send_Data[8-1];  //D7数据
          o_tx_ch2   <= Send_Data[16-1];  //D15数据
          o_sck      <= 1'b0;  //在下降沿放置数据
          Data_State <= Data_State + 5'd1;  //切换状态
        end
        D6_State://第6位数据发送状态
        begin
          o_tx_ch1   <= Send_Data[7-1];  //D6数据
          o_tx_ch2   <= Send_Data[15-1];  //D14数据
          o_sck      <= 1'b0;  //在下降沿放置数据
          Data_State <= Data_State + 5'd1;  //切换状态
        end
        D5_State://第5位数据发送状态
        begin
          o_tx_ch1   <= Send_Data[6-1];  //D5数据
          o_tx_ch2   <= Send_Data[14-1];  //D13数据
          o_sck      <= 1'b0;  //在下降沿放置数据
          Data_State <= Data_State + 5'd1;  //切换状态
        end
        D4_State://第4位数据发送状态
        begin
          o_tx_ch1   <= Send_Data[5-1];  //D4数据
          o_tx_ch2   <= Send_Data[13-1];  //D12数据
          o_sck      <= 1'b0;  //在下降沿放置数据
          Data_State <= Data_State + 5'd1;  //切换状态
        end
        D3_State://第3位数据发送状态
        begin
          o_tx_ch1   <= Send_Data[4-1];  //D3数据
          o_tx_ch2   <= Send_Data[12-1];  //D11数据
          o_sck      <= 1'b0;  //在下降沿放置数据
          Data_State <= Data_State + 5'd1;  //切换状态
        end
        D2_State://第2位数据发送状态
        begin
          o_tx_ch1   <= Send_Data[3-1];  //D2数据
          o_tx_ch2   <= Send_Data[11-1];  //D10数据
          o_sck      <= 1'b0;  //在下降沿放置数据
          Data_State <= Data_State + 5'd1;  //切换状态
        end
        D1_State://第1位数据发送状态
        begin
          o_tx_ch1   <= Send_Data[2-1];  //D1数据
          o_tx_ch2   <= Send_Data[10-1];  //D9数据
          o_sck      <= 1'b0;  //在下降沿放置数据
          Data_State <= Data_State + 5'd1;  //切换状态
        end
        D0_State://第0位数据发送状态
        begin
          o_tx_ch1   <= Send_Data[1-1];  //D0数据
          o_tx_ch2   <= Send_Data[9-1];  //D8数据
          o_sck      <= 1'b0;  //在下降沿放置数据
          Data_State <= Data_State + 5'd1;  //切换状态
        end
        CS_State://CS
        begin
          o_sck      <= 1'b0;  //o_sck初始电平为低
          o_cs       <= 1'b1;  //o_cs初始电平为高
          o_tx_ch1   <= 1'b0;  //o_tx_ch1初始电平为低
          o_tx_ch2   <= 1'b0;  //o_tx_ch2初始电平为低
          Data_State <= Data_State + 5'd1;  //切换状态
        end
        // CS_State+1://CS+1
        // begin
        //   o_sck    <= 1'b0;  //o_sck初始电平为低
        //   o_cs     <= 1'b1;  //o_cs初始电平为高
        //   o_tx_ch1 <= 1'b0;  //o_tx_ch1初始电平为低
        //   o_tx_ch2 <= 1'b0;  //o_tx_ch2初始电平为低
        //   Data_State <= 0;
        // end
        default: begin
          o_sck      <= 1'b0;  //o_sck初始电平为低
          o_cs       <= 1'b1;  //o_cs初始电平为高
          o_tx_ch1   <= 1'b0;  //o_tx_ch1初始电平为低
          o_tx_ch2   <= 1'b0;  //o_tx_ch2初始电平为低
          Data_State <= D7_State;
        end
      endcase
    end
  end

endmodule
