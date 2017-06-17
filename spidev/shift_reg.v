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


module shift_reg(
shift_clk,
in_bit,
in_data,
out_data,
init_counter,
shifting_finished,
out_bit,
shift_in_out //in=1, out =0
    );
    
    input shift_clk;
    input init_counter;
    input in_bit;
    input shift_in_out;
    input [31:0] in_data;
    //input load_shift_register;
    output reg out_bit = 0;
    output [31:0] out_data;
    output shifting_finished;
    reg [32:0] ring_counter;
    reg [31:0] shift_data;
    
    assign out_data = shift_data;
    
    always @(posedge init_counter)
    begin
      if (!shift_in_out)      
        shift_data <= in_data;
      ring_counter <= 1;
    end   
    
    always @(negedge shift_clk)    
    if (!shift_in_out)
      shift_data <= shift_data << 1;
    
    
    always @(posedge shift_clk)
      if (!shift_in_out)
        out_bit <= shift_data[31];
      //shift_data <= shift_data << 1;

    always @(posedge shift_clk)
      if (shift_in_out)
        shift_data <= {shift_data[6:0], in_bit};
      //shift_data <= shift_data << 1;

    always @(posedge shift_clk)
    if (init_counter == 0)
      ring_counter <= ring_counter << 1;
    
   
    assign shifting_finished = shift_in_out ? ring_counter[8] :ring_counter[32]; 
    
endmodule
