`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2017 17:52:08
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
  input clk,
  output chip_select,
  output spi_hold,
  output spi_wp,
  output spi_si,
  input spi_so,
  output [7:0] led
    );

//reg clk = 0;
wire clk_out;
wire wire_gnd = 0;
wire wire_vcc = 1;
wire clk_locked;
wire [7:0] data_out;
//840,000,000

/*
1 
2
4
8
16
32
64
128
256
512
1024
2048
4096
8192
18384
32768
65536
131072
262144
524288
1048576
2097152
4194304
8388608
16777216
33554432
67108864
134217728
268435456
536870912
*/
//wire out_bit;
//wire in_bit;
//wire chip_select;
wire data_clk;
wire reset;
assign spi_hold = 1;
assign spi_wp = 1;
//reg reset = 1;
//assign reset = ~clk_locked;

reg [31:0] dd = 0;
//reg reachedthres = 0;
assign reset = ~dd[30];
always @(posedge clk_out)
  dd <= dd + 1;
  
//always @(posedge clk_out)
//  reachedthres <= dd > 100000000;

assign led [7:0] = {data_out[7:0]};
/*initial begin
  #1003000 reset = 0;
end*/

ila_0  debugger(
  clk,
  clk_out,
  spi_si,  
  chip_select,
  data_clk
);


clk_wiz_0 clkfeed
 (
  // Clock out ports
  clk_out,
  // Status and control signals
  wire_gnd, //reset
  clk_locked,
 // Clock in ports
  clk
 );
    
spi_block spi_com(
  clk_out, //use clock from clock-gen
  spi_si,
  spi_so,
  data_out,
  chip_select,
  data_clk,
  reset
     );
     
     /*s25fl032p flash_rom
     (
         data_clk      ,
         out_bit       ,
         chip_select    ,
         wire_vcc  ,
         wire_vcc    ,
         in_bit
     );*/



//always #5
//      clk = !clk;

   // STARTUPE2: STARTUP Block
   //            Artix-7
   // Xilinx HDL Language Template, version 2017.1

wire CFGCLK_open;
wire CFGMCLK_open;
wire EOS_open;
wire PREQ_open;
wire CLK_open;
wire USRDONEO_open;
wire USRDONETS_open;

   STARTUPE2 #(
      .PROG_USR("FALSE"),  // Activate program event security feature. Requires encrypted bitstreams.
      .SIM_CCLK_FREQ(0.0)  // Set the Configuration Clock Frequency(ns) for simulation.
   )
   STARTUPE2_inst (
      .CFGCLK(CFGCLK_open),       // 1-bit output: Configuration main clock output
      .CFGMCLK(CFGMCLK_open),     // 1-bit output: Configuration internal oscillator clock output
      .EOS(EOS_open),             // 1-bit output: Active high output signal indicating the End Of Startup.
      .PREQ(PREQ_open),           // 1-bit output: PROGRAM request to fabric output
      .CLK(CLK_open),             // 1-bit input: User start-up clock input
      .GSR(wire_gnd),             // 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
      .GTS(wire_gnd),             // 1-bit input: Global 3-state input (GTS cannot be used for the port name)
      .KEYCLEARB(wire_gnd), // 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
      .PACK(wire_gnd),           // 1-bit input: PROGRAM acknowledge input
      .USRCCLKO(data_clk),   // 1-bit input: User CCLK input
      .USRCCLKTS(wire_gnd), // 1-bit input: User CCLK 3-state enable input
      .USRDONEO(USRDONEO_open),   // 1-bit input: User DONE pin output control
      .USRDONETS(USRDONETS_open)  // 1-bit input: User DONE 3-state enable output
   );

   // End of STARTUPE2_inst instantiation
				


endmodule
