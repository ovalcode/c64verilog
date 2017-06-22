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
shift_clk,
in_bit,
out_data,
init_counter,
shifting_finished
    );
    
    input shift_clk;
    input init_counter;
    input in_bit;
    //input load_shift_register;
    output [7:0] out_data;
    output shifting_finished;
    reg [8:0] ring_counter = 0;
    reg [7:0] shift_data;
    
    assign out_data = shift_data;
    
    always @(posedge shift_clk)
        shift_data <= {shift_data[6:0], in_bit};

    always @(posedge shift_clk or posedge init_counter)
    if (init_counter == 1)
      ring_counter <= 9'h1;
    else
      ring_counter <= ring_counter << 1;
    
   
    assign shifting_finished = ring_counter[8]; 
    
endmodule
