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


module shift_out_reg(
shift_clk,
in_data,
load,
out_bit
    );
    
    input shift_clk;
    input load;
    input [31:0] in_data = 0;
    //input load_shift_register;
    //output reg out_bit = 0;
    output out_bit;
    reg [32:0] ring_counter = 0;
//???????????    
(*DONT_TOUCH = "TRUE"*) reg [31:0] shift_data;
    
    assign out_bit = shift_data[31];
    
    always @(negedge shift_clk)
    begin
       if (load == 1)
          shift_data <= in_data;
       else 
          shift_data <= {shift_data[30:0],1'b0};
    end
    
endmodule
