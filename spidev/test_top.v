`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2017 18:50:58
// Design Name: 
// Module Name: test_top
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


module test_top(

    );
   
/*   reg clk = 0;
   reg [31:0] shift_reg = 0;
   reg chip_select = 1;
   reg data_clock_enabled = 0;
   reg tx_bit = 0;
//   reg hard_0 = 1;
//   reg hard_1 = 1;
//   reg temp_hard = 1;
   //reg 
   wire data_clock;
   wire out;
   wire tx_buffer;
   wire vcc_wire;
//   wire temp_1_wire;
//   wire temp_2_wire;
   initial begin
     #1000000 shift_reg = 32'h9000_0000;
     #20 chip_select = 0;
   end
   
   always @(negedge clk)
     data_clock_enabled <= ~chip_select;
   
    always #20
      clk = !clk;
      
   assign data_clock = data_clock_enabled ? clk : 0;

   always @(negedge chip_select or negedge data_clock)
     tx_bit <= shift_reg[31];
     
   always @(posedge data_clock)
     shift_reg <= shift_reg << 1;
     
   assign tx_buffer = chip_select ? 1'bz : tx_bit;
   assign vcc_wire = 1;
*/
     
     
reg clk = 0;
reg reset = 1;     
wire out_bit;
wire chip_select;
wire data_clk;
wire vcc_wire;
wire out;

assign vcc_wire = 1;

     s25fl032p mod_0
     (
         data_clk,
         out_bit,
         chip_select,
         vcc_wire,
         vcc_wire,
         out
     );
     
     /*module spi_block(
 clk,
 out_bit,
 chip_select,
 data_clk,
    );*/

     initial begin
     #1000000 reset = 0;
     end
     
spi_block my_spi (
      clk,
      out_bit,
      out,
      chip_select,
      data_clk,
      reset
         );

    always #20
      clk = !clk;
     

endmodule
