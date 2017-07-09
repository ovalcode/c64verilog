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
 data_out,
 chip_select,
 data_clk,
 data_ready,
 finished_reading,
 reset
    );

input clk;
input reset;
input finished_reading;
output out_bit;
output [7:0] data_out;
output data_ready;
//input wire in_bit;
wire shift_out_clk;
wire shift_in_clk;
output wire data_clk;
input wire in_bit;
reg load_shift_register;
wire shifting_finished;
wire read_shifting_finished;
wire out_bit;
wire [7:0] shift_out_wire;
(*KEEP = "FALSE"*)  reg [2:0] state = 0;
reg init_counter = 0;
output reg chip_select = 1;
wire vcc_wire;
wire gnd_wire;
wire floating_wire;
reg [7:0] shifted_data;
reg [31:0] in_data = 32'h0300_0000;
(*KEEP = "FALSE"*) reg [4:0] remaining_send;
(*KEEP = "FALSE"*)  reg [2:0] remaining_receive;
//reg [7:0] out_data;

assign data_ready = (state >= 3) & (remaining_receive == 0);

//assign data_out = out_data;//shifted_data;
assign data_out = shift_out_wire;//shifted_data;

assign vcc_wire = 1;
assign gnd_wire = 0;
//NB!!!
//assign shift_out_clk = chip_select ? 0 : ~data_clk;

assign shift_in_clk = (state == 3) ? data_clk : 1;

assign data_clk = chip_select ? 0 : clk;

always @(posedge clk)
  if (!reset)
  case(state)
    0: state <= 1;
    1: state <= 2; // status 2 = start shifting;
    2: state <= (remaining_send == 0) ? 3 : 2;
    //3: state <= 4;
    3: state <= (remaining_receive == 0) ? 4 : 3;
    4: state <= 4;
//    4: state <= ; 
    default: state <= state;
  endcase
  
  
//     always @(negedge clk)
//    data_clock_enabled <= ~chip_select;


//assign data_clock = data_clock_enabled ? clk : 0;
  
always @(negedge clk)
  chip_select <= (state > 0 & !finished_reading) ? 0 : 1;

always @*
if (state == 1)
begin
  init_counter <= 1;
  //in_data <= 32'h9000_0001;
end else
  init_counter <= 0;

always @(posedge clk)
if (state == 1)
  remaining_send <= 31;
else
  remaining_send <= remaining_send - 1;
  
always @(posedge clk)
if (state == 1)
  remaining_receive <= 7;
else if (state >= 3)
  remaining_receive <= remaining_receive - 1;
else
  remaining_receive <= remaining_receive;
  

//always @(negedge clk)
//  if ((state >= 3) & (remaining_receive == 0))
  //out_data <= shift_out_wire;
//always @(posedge clk)
//  init_counter <= (state == 1) ? 1 : 0; 

shift_out_reg send_reg (
  clk,
  in_data,
  init_counter,
  out_bit  
    );

//always @(posedge read_shifting_finished)
//  shifted_data <= {shift_out_wire[7:0]}; 

shift_in_reg recive_reg (
  clk,//??????????
  in_bit,
  shift_out_wire// out data??????
    );

endmodule
