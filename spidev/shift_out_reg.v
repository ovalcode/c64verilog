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
init_counter,
shifting_finished,
out_bit
    );
    
    input shift_clk;
    input init_counter;
    input [31:0] in_data;
    //input load_shift_register;
    output reg out_bit = 0;
    output shifting_finished;
    reg [32:0] ring_counter = 0;
//???????????    
(*DONT_TOUCH = "TRUE"*) reg [31:0] shift_data;
    
    always @(posedge init_counter)
    begin
        shift_data <= in_data;
      //ring_counter <= 32'h1;
    end   
    
    always @(negedge shift_clk)    
      shift_data <= shift_data << 1;
    
    
    always @(posedge shift_clk)
        out_bit <= shift_data[31];
      //shift_data <= shift_data << 1;


    always @(posedge shift_clk or posedge init_counter)
    if (init_counter == 1)
      ring_counter <= 33'h1;
    else
      ring_counter <= ring_counter << 1;
    
   
    assign shifting_finished = ring_counter[32]; 
    
endmodule
