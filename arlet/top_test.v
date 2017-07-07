`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2017 08:06:17
// Design Name: 
// Module Name: top_test
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


module top_test(

    );

reg clk = 0;    
reg reset = 1;
wire [15:0] addr;
wire [7:0] DI;
wire [7:0] DO;
wire WE;
    
    cpu mycpu ( clk, reset, addr, DI, DO, WE, 1'b0, 1'b0, 1'b1 );
    
    /*input clk;              // CPU clock 
    input reset;            // reset signal
    output reg [15:0] AB;   // address bus
    input [7:0] DI;         // data in, read bus
    output [7:0] DO;        // data out, write bus
    output WE;              // write enable
    input IRQ;              // interrupt request
    input NMI;              // non-maskable interrupt request
    input RDY;              // Ready signal. Pauses CPU when RDY=0*/ 


    test_suite_rom rom (
      clk,
      addr,
      DO, //cpu data out is this modules  data in
      DI,
      WE
    );
    
initial begin
  #1000000 reset <= 0; 
end    

always #10 
clk = ~clk;

    
    
    
endmodule
