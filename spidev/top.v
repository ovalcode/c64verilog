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
  input spi_so
    );

//reg clk = 0;
wire clk_out;
wire wire_gnd = 0;
wire wire_vcc = 1;
wire clk_locked;
//wire out_bit;
//wire in_bit;
//wire chip_select;
wire data_clk;
wire reset;
assign spi_hold = 1;
assign spi_wp = 1;
//reg reset = 1;
assign reset = ~clk_locked;

/*initial begin
  #1003000 reset = 0;
end*/

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

   STARTUPE2 #(
      .PROG_USR("FALSE"),  // Activate program event security feature. Requires encrypted bitstreams.
      .SIM_CCLK_FREQ(0.0)  // Set the Configuration Clock Frequency(ns) for simulation.
   )
   STARTUPE2_inst (
      .CFGCLK(CFGCLK),       // 1-bit output: Configuration main clock output
      .CFGMCLK(CFGMCLK),     // 1-bit output: Configuration internal oscillator clock output
      .EOS(EOS),             // 1-bit output: Active high output signal indicating the End Of Startup.
      .PREQ(PREQ),           // 1-bit output: PROGRAM request to fabric output
      .CLK(CLK),             // 1-bit input: User start-up clock input
      .GSR(GSR),             // 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
      .GTS(GTS),             // 1-bit input: Global 3-state input (GTS cannot be used for the port name)
      .KEYCLEARB(KEYCLEARB), // 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
      .PACK(PACK),           // 1-bit input: PROGRAM acknowledge input
      .USRCCLKO(USRCCLKO),   // 1-bit input: User CCLK input
      .USRCCLKTS(USRCCLKTS), // 1-bit input: User CCLK 3-state enable input
      .USRDONEO(USRDONEO),   // 1-bit input: User DONE pin output control
      .USRDONETS(USRDONETS)  // 1-bit input: User DONE 3-state enable output
   );

   // End of STARTUPE2_inst instantiation
				


endmodule
