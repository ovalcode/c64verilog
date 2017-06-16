`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2017 19:44:03
// Design Name: 
// Module Name: spi_block
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


module spi_block(
 clk,
 out_bit,
 in_bit,
 chip_select,
 data_clk,
 reset
    );

input clk;
input reset;
output out_bit;
//input wire in_bit;
wire shift_out_clk;
wire shift_in_clk;
output wire data_clk;
input wire in_bit;
reg [31:0] in_data;
reg load_shift_register;
wire shifting_finished;
wire read_shifting_finished;
wire out_bit;
wire [31:0] shift_out_wire;
reg [3:0] state = 0;
reg init_counter = 0;
reg enable_shifting = 0;
output reg chip_select = 1;
wire vcc_wire;
wire gnd_wire;
wire floating_wire;
reg [7:0] shifted_data;

assign vcc_wire = 1;
assign gnd_wire = 0;
//NB!!!
assign shift_out_clk = chip_select ? 0 : ~data_clk;

assign shift_in_clk = (state == 3) ? data_clk : 1;

assign data_clk = enable_shifting ? clk : 0;

always @(posedge clk)
  if (!reset)
  case(state)
    0: state <= 1;
    1: state <= 2; // status 2 = start shifting;
    2: state <= shifting_finished ? 3 : 2;
  endcase
  
//?????
always @(negedge clk)
  enable_shifting <= ~chip_select;//(state == 2) ? 1 : 0;
  
//     always @(negedge clk)
//    data_clock_enabled <= ~chip_select;


//assign data_clock = data_clock_enabled ? clk : 0;
  
always @(state)
  chip_select <= (state > 1) ? 0 : 1;

always @*
if (state == 1)
begin
  init_counter <= 1;
  in_data <= 32'h90000000;
end

always @(posedge clk)
  init_counter <= (state == 1) ? 1 : 0; 

shift_reg send_reg (
  shift_out_clk,
  floating_wire,
  in_data,
  floating_wire,
  init_counter,
  shifting_finished,
  out_bit,
  gnd_wire
    );

always @(posedge read_shifting_finished)
  shifted_data <= {shift_out_wire[7:0]}; 

shift_reg recive_reg (
  shift_in_clk,//??????????
  in_bit,
  floating_wire,
  shift_out_wire,// out data??????
  init_counter,
  read_shifting_finished,
  floating_wire,//out_bit,
  vcc_wire
    );

/*
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

*/

endmodule
