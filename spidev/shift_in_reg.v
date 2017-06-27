`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 13:06:28
// Design Name: 
// Module Name: shift_reg
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


module shift_in_reg(
clk,
in_bit,
out_data
    );
    
    input clk;
    input in_bit;
    //input load_shift_register;
    output [7:0] out_data;
    reg [7:0] shift_data;
    
    assign out_data = shift_data;
    
    always @(posedge clk)
        shift_data <= {shift_data[6:0], in_bit};
    
endmodule
