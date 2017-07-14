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
//reg [7:0] DI;
wire [7:0] DO;
reg [7:0] DO_combined;
wire WE;
reg [2:0] WE_bank;
wire [7:0] io_port;
wire [7:0] basic_DOUT;
wire [7:0] chargen_DOUT;    
wire [7:0] kernel_DOUT;
wire [7:0] ram_DOUT;
wire [7:0] gpio_bank;
reg [7:0] direction_reg;   
reg periph_6502_address;
reg [7:0] periph_DO;
reg [15:0] addr_delayed;
    /*
      case (addr)
      NB!! multiplex data_out and WE
    */
    
    GPIO gpio_0 (
        clk,      // The standard clock
        WE_bank[1],
        direction_reg[0],  // Direction of io, 1 = set output, 0 = read input
        DO[0], //CPU DO
        gpio_bank[0],   // Result of input pin when direction is 0
        io_port[0]     // The i/o port to send data through
    );
    
     GPIO gpio_1 (
        clk,      // The standard clock
        WE_bank[1],
        direction_reg[1],  // Direction of io, 1 = set output, 0 = read input
        DO[1], //CPU DO
        gpio_bank[1],   // Result of input pin when direction is 0
        io_port[1]     // The i/o port to send data through
    );

    GPIO gpio_2 (
        clk,      // The standard clock
        WE_bank[1],
        direction_reg[2],  // Direction of io, 1 = set output, 0 = read input
        DO[2], //CPU DO
        gpio_bank[2],   // Result of input pin when direction is 0
        io_port[2]     // The i/o port to send data through
    );
    
    GPIO gpio_3 (
        clk,      // The standard clock
        WE_bank[1],
        direction_reg[3],  // Direction of io, 1 = set output, 0 = read input
        DO[3], //CPU DO
        gpio_bank[3],   // Result of input pin when direction is 0
        io_port[3]     // The i/o port to send data through
    );
    
    GPIO gpio_4 (
        clk,      // The standard clock
        WE_bank[1],
        direction_reg[4],  // Direction of io, 1 = set output, 0 = read input
        DO[4], //CPU DO
        gpio_bank[4],   // Result of input pin when direction is 0
        io_port[4]     // The i/o port to send data through
    );
    
    GPIO gpio_5 (
        clk,      // The standard clock
        WE_bank[1],
        direction_reg[5],  // Direction of io, 1 = set output, 0 = read input
        DO[5], //CPU DO
        gpio_bank[5],   // Result of input pin when direction is 0
        io_port[5]     // The i/o port to send data through
    );
    
    GPIO gpio_6 (
        clk,      // The standard clock
        WE_bank[1],
        direction_reg[6],  // Direction of io, 1 = set output, 0 = read input
        DO[6], //CPU DO
        gpio_bank[6],   // Result of input pin when direction is 0
        io_port[6]     // The i/o port to send data through
    );
    
    GPIO gpio_7 (
        clk,      // The standard clock
        WE_bank[1],
        direction_reg[7],  // Direction of io, 1 = set output, 0 = read input
        DO[7], //CPU DO
        gpio_bank[7],   // Result of input pin when direction is 0
        io_port[7]     // The i/o port to send data through
    );

    
    
    
    cpu mycpu ( clk, reset, addr, DO_combined, DO, WE, 1'b0, 1'b0, 1'b1 );
    
    /*input clk;              // CPU clock 
    input reset;            // reset signal
    output reg [15:0] AB;   // address bus
    input [7:0] DI;         // data in, read bus
    output [7:0] DO;        // data out, write bus
    output WE;              // write enable
    input IRQ;              // interrupt request
    input NMI;              // non-maskable interrupt request
    input RDY;              // Ready signal. Pauses CPU when RDY=0*/ 


    test_suite_rom ram (
      clk,
      addr,
      DO, //cpu data out is this modules  data in
      ram_DOUT,
      WE_bank[2]
    );
    
    rom_basic basic(
      clk,
      addr,
      basic_DOUT
        );
        
     rom_chargen chargen(
          clk,
          addr,
          chargen_DOUT
          );
          
      rom_kernal kernal(
            clk,
            addr,
            kernel_DOUT
            );
    
initial begin
  #1000000 reset <= 0; 
end    

always @(posedge clk)
addr_delayed <= addr;

always @*
  casex (addr_delayed)
    16'b0000_0000_0000_000x: DO_combined = periph_DO;
    16'b101x_xxxx_xxxx_xxxx: DO_combined = basic_DOUT;
    16'b111x_xxxx_xxxx_xxxx: DO_combined = kernel_DOUT;
    default: DO_combined = ram_DOUT;
  endcase

always @(posedge clk)
begin
  if (WE_bank[0])
    direction_reg <= DO;
end

always @(posedge clk)
periph_6502_address <= addr[0];

always @*
case (periph_6502_address)
  0: periph_DO = direction_reg;
  1: periph_DO = gpio_bank;    
endcase 

always @*
casex(addr)
  0: WE_bank = WE ? 1 : 0;
  1: WE_bank = WE ? 2 : 0;
  default WE_bank = WE ? 4 : 0;
endcase

always #10 
clk <= ~clk;

    
    
    
endmodule
