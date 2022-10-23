`timescale 1 ns / 1 ps

module spi_tb ();
  //master
  reg           sys_clk;
  reg           sys_rst_n;
  wire          o_sck;
  wire          o_cs;
  wire          o_tx_ch1;
  wire          o_tx_ch2;
  reg  [  15:0] i_send_data;

  //slave
  /*   wire          sys_clk;
  wire          sys_rst_n; */
  wire          i_sck;
  wire          i_cs;
  wire          i_rx_ch1;
  wire          i_rx_ch2;
  wire [16-1:0] o_getdata;

  //=================
  // connect master and slave
  //=================
  assign i_sck    = o_sck;
  assign i_cs     = o_cs;
  assign i_rx_ch1 = o_tx_ch1;
  assign i_rx_ch2 = o_tx_ch2;
  //==============================================================
  // initial  value
  //==============================================================
  initial begin

    sys_clk   = 1'b0;
    sys_rst_n = 1;
    #5 sys_rst_n = 0;
    #5 sys_rst_n = 1;
    i_send_data = 16'b1000_0000_0000_0001;
    #200 i_send_data = 16'b1010_0000_0100_0001;
  end

  always #5 sys_clk = ~sys_clk;
  //  always #400   SPI_MISO = ~SPI_MISO  ; 

  spi_master u1 (
      sys_clk,
      sys_rst_n,
      o_sck,
      o_cs,
      o_tx_ch1,
      o_tx_ch2,
      i_send_data
  );
  spi_slave u2 (
      sys_clk,
      sys_rst_n,
      i_sck,
      i_cs,
      i_rx_ch1,
      i_rx_ch2,
      o_getdata
  );
endmodule
