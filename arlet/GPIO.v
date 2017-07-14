`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2017 13:23:37
// Design Name: 
// Module Name: GPIO
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


module GPIO(
    input  clk,      // The standard clock
    input  we,
    input  direction,  // Direction of io, 1 = set output, 0 = read input
    input  data_in,    // Data to send out when direction is 1
    output data_out,   // Result of input pin when direction is 0
    inout  io_port     // The i/o port to send data through
);

reg a, b;    

assign io_port  = direction ? a : 1'bz;
assign data_out = b;

always @ (posedge clk)
begin
   b <= io_port;
   if(we)
     a <= data_in;
end

endmodule