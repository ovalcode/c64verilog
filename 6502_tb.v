module test;
  //iverilog -o my_design  6502_tb.v 6502.v

  /* Make a reset that pulses once. */
  reg reset = 0;
  reg [7:0] ram [0:27];
  initial begin
     ram[0] = 8'ha9;
     ram[1] = 8'd20;
     ram[2] = 8'h8d;
     ram[3] = 8'h14;
     ram[4] = 8'd0;
     ram[5] = 8'd3;
     ram[6] = 8'd3;
     ram[7] = 8'd3;
     ram[8] = 8'd3;
     ram[9] = 8'd3;
     ram[10] = 8'd3;
     ram[11] = 8'd3;
     ram[12] = 8'd3;
     ram[13] = 8'd3;
     ram[14] = 8'd3;
     ram[15] = 8'd3;
     ram[16] = 8'd9;
     ram[17] = 8'd9;
     ram[18] = 8'd9;
//$display("Hello daar");
     ram[19] = 8'd9;
     ram[20] = 8'd9;
     ram[21] = 8'd9;
     ram[22] = 8'd9;
     ram[23] = 8'd17;
     ram[24] = 8'd18;
     ram[25] = 8'd19;
     ram[26] = 8'd20;
     ram[27] = 8'd21;

     #10 reset = 1;
     #10 reset = 0;
     #100 $stop;

     //# 17 reset = 1;
     //# 11 reset = 0;
     //# 29 reset = 1;
     //# 11 reset = 0;
     //# 100 $stop;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #1 clk = !clk;

  //wire [7:0] value;
  //reg di = 0;
  wire [7:0] di;
  wire [7:0] do;
  wire [15:0] ab;
  wire we;
  //assign di = ram[ab];


  always @(posedge clk)
  if (we)
    ram[ab] = do;

  //always @(posedge clk)
  assign di = we ? 8'hzz : ram[ab] ;

  _6502 c1 (di, do, clk, reset, we, ab);


  //always @(posedge clk)
  //begin
  //  pc <= pc + 1;
  //  $display("Hello %d, %d", pc, clk);
  //end


  initial
     $monitor("At time %t, value = %h (%0d)",
              $time, clk, clk);
endmodule // test
