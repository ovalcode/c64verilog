`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2017 10:53:00
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
  input sw,
  output [15:0] led
    );
    
//reg clk = 0;    
    reg reset = 1;
    wire [15:0] addr;
    //reg [15:0] addr = 0;
    wire [7:0] DI;
    wire [7:0] DO;
    wire WE;
    wire nc;
    wire clk_8_mhz;
    wire slow_clk;   
    wire master_clk_src;
    reg [7:0] reset_counter = 0;
    
    reg [24:0] clk_div = 0;
    assign slow_clk = clk_div[24];
    assign master_clk_src = sw ? clk_8_mhz : slow_clk;
    assign led = sw ? 0 : addr;  
    //reg WE = 0;
        
        clk_wiz_0 my_clk 
     (
      // Clock out ports
      clk_8_mhz,
      // Status and control signals
      0,
      nc,
     // Clock in ports
      clk
     );
     
     always @(posedge master_clk_src)
     if (reset_counter < 40)
       reset_counter <= reset_counter + 1;
       
     always @(posedge master_clk_src)
     if (reset_counter == 30)
       reset = 0;

        
        cpu mycpu ( master_clk_src, reset, addr, DI, DO, WE, 1'b0, 1'b0, 1'b1 );
        
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
          master_clk_src,
          addr,
          DO, //cpu data out is this modules  data in
          DI,
          WE
        );
        
always @(posedge clk_8_mhz)    
clk_div <= clk_div + 1;        
    
endmodule
