module test;
  //iverilog -o my_design  6502_tb.v 6502.v

  /* Make a reset that pulses once. */
  reg reset = 0;
  reg [7:0] ram [0:65535];
  initial begin
     for (i = 0; i < 65536; i = i + 1) begin
       ram[i] = 0;
       $display("init %d", i);
     end
     ram[0] = 8'hae;
     ram[1] = 0;
     ram[2] = 4;
     ram[3] = 8'h8e;
     ram[4] = 8'h40;
     ram[5] = 4;
     ram[6] = 8'ha5;
     ram[7] = 8'h30;
     ram[8] = 8'h85;
     ram[9] = 8'h35;

     ram[16'h30] = 71;
     ram[16'h400] = 90;
     //LDX $400
     //STX $440
     //LDA $30
     //STA $35

     #10 reset = 1;
     #10 reset = 0;
     #200 $stop;

     //# 17 reset = 1;
     //# 11 reset = 0;
     //# 29 reset = 1;
     //# 11 reset = 0;
     //# 100 $stop;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #5 clk = !clk;

  //wire [7:0] value;
  //reg di = 0;
  wire [7:0] di;
  wire [7:0] do;
  wire [15:0] ab;
  reg  [16:0] i;
  wire we;
  reg [7:0] temp_ram_out;
  //assign di = ram[ab];

  always @(posedge clk)
    $display("dddd %d", we);


  always @(posedge clk)
  begin
  if (we)
    ram[ab] = do;
  $display("hhhh %d %d %d", we, do, ab);
  end

  //always @(posedge clk)
  //if (!we)
  //  temp_ram_out <= ram[ab];

  always @(posedge clk)
    $display("mem %d %d %d", ram[16'h440], ram[16'h35], ram[23]);

  //always @(posedge clk)
  assign di = we ? 8'hzz : ram[ab]/*temp_ram_out*/ ;

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
