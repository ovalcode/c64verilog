module test;
  //iverilog -o my_design  6502_tb.v 6502.v

  /* Make a reset that pulses once. */
  reg reset = 0;
  reg [7:0] ram [0:65535];
  initial begin
     for (i = 0; i < 65536; i = i + 1) begin
       ram[i] = 0;
       //$display("init %d", i);
     end

//----------------------------------------------------------------
//Test Program 1
/*   ram[0] = 8'ha9;
     ram[1] = 8'd39;
     ram[2] = 8'h8d;
     ram[3] = 8'h11;
     ram[4] = 8'd0;
     ram[5] = 8'ha2;
     ram[6] = 8'd33;
     ram[7] = 8'h8e;
     ram[8] = 8'd22;
     ram[9] = 8'h0;
     ram[10] = 8'ha0;
     ram[11] = 8'h47;
     ram[12] = 8'h8c;
     ram[13] = 8'd23;
     ram[14] = 8'd0;
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
     ram[27] = 8'd21;*/


//-----------------------------------------------------------------------
//Test program 2
/*     ram[0] = 8'hae;
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
     ram[16'h400] = 90;*/
     //LDX $400
     //STX $440
     //LDA $30
     //STA $35

//--------------------------------------------------------------------------
//Test Program 3

/*   ram[0] = 8'ha2;
   ram[1] = 8'h05;
   ram[2] = 8'ha0;
   ram[3] = 8'h0b;
   ram[4] = 8'hbd;
   ram[5] = 8'h07;
   ram[6] = 8'h05;
   ram[7] = 8'h99;
   ram[8] = 8'h10;
   ram[9] = 8'h05;
   ram[16'h50c] = 22; */
/*
  LDX $5
  LDY $B
  LDA $507,X
  STA $510,Y
*/

//--------------------------------------------------------------------------
//Test Program 4: ABS,X with carry

/*   ram[0] = 8'ha2;
   ram[1] = 8'h05;
   ram[2] = 8'ha0;
   ram[3] = 8'h0b;
   ram[4] = 8'hbd;
   ram[5] = 8'hfe;
   ram[6] = 8'h05;
   ram[7] = 8'h99;
   ram[8] = 8'hfe;
   ram[9] = 8'h05;
   ram[16'h603] = 22; */
/*
  LDX #$5
  LDY #$B
  LDA $5FE,X
  STA $5FE,Y
*/
//--------------------------------------------------------------------------
//Test Program 5: ZP,X with rollover

/*   ram[0] = 8'ha2;
   ram[1] = 8'h23;
   ram[2] = 8'hb5;
   ram[3] = 8'h40;
   ram[4] = 8'h95;
   ram[5] = 8'he9;

   ram [16'h63] = 8'h43;*/
/*
  LDX #$23
  LDA $40,X -> location $63
  STA $E9,X -> location c
*/
//--------------------------------------------------------------------------
//Test Program 6: (ZP,X)

/*  ram[0] = 8'ha2;
  ram[1] = 8'h20;
  ram[2] = 8'ha1;
  ram[3] = 8'h40;
  ram[4] = 8'h81;
  ram[5] = 8'h60;
  ram[16'h60] = 8'h24;
  ram[16'h61] = 8'h3;

  ram[16'h80] = 8'h24;
  ram[16'h81] = 8'h4;

  ram[16'h324] = 8'h77;*/
  
/*
  LDX #$20
  LDA ($40,x)
  STA ($60,X)
*/
//--------------------------------------------------------------------------
//Test Program 7: (ZP),Y

/*  ram[0] = 8'ha0;
  ram[1] = 8'h33;
  ram[2] = 8'hb1;
  ram[3] = 8'h55;
  ram[4] = 8'h91;
  ram[5] = 8'h66;
  ram[16'h55] = 8'hb5;
  ram[16'h56] = 9;

  ram[16'h66] = 8'he0;
  ram[16'h67] = 8'ha0;

  ram[16'h9e8] = 8'h67; */
/*
  LDY #$33
  LDA ($55),Y
  STA ($66),Y
*/
//--------------------------------------------------------------------------
//Test Program 8: ADC
  ram[0] = 8'h38;
  ram[1] = 8'ha9;
  ram[2] = 8'h23;
  ram[3] = 8'h69;
  ram[4] = 8'h47;
  ram[5] = 8'h18;
  ram[6] = 8'h6d;
  ram[7] = 8'h0;
  ram[8] = 8'h13;
  ram[9] = 8'h38;
  ram[10] = 8'he9;
  ram[11] = 8'h22; 
  ram[12] = 8'h38;
  ram[13] = 8'h38;
  ram[14] = 8'ha2;
  ram[15] = 8'h0;

  ram[16] = 8'he8;
  ram[17] = 8'he8;
  ram[18] = 8'he8;
  ram[19] = 8'he8;

  ram[20] = 8'hca;
  ram[21] = 8'hca;
  ram[22] = 8'hca;
  ram[23] = 8'hca;
  ram[24] = 8'hca;
  ram[25] = 8'hca;
  ram[26] = 8'hca;
  ram[27] = 8'hca;


  //ram[16'h1200] = 8'h47;
  ram[16'h1300] = 8'h69;
/*
  SEC
  LDA #$23
  ADC #$47
  CLC
  ADC $1300
  SEC
  SBC #$22
  LDX #$0
  INX
  INX
  INX
  INX
  DEY
  DEY
  DEY
  DEY
  DEY
  DEY
  DEY
  DEY
*/

//--------------------------------------------------------------------------

     #10 reset = 1;
     #10 reset = 0;
     #600 $stop;

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
  //reg [7:0] temp_ram_out;
  //assign di = ram[ab];

  always @(posedge clk)
    $display("dddd %d", we);


//to insert new mem here
/*  always @(posedge clk)
  begin
  if (we)
    ram[ab] = do;
  $display("hhhh %d %d %d", we, do, ab);
  end*/

	reg [15:0] addr_reg;
	
	always @ (posedge clk)
	begin
	// Write
        $display("ram internals, ab=%d, do=%d, we=%d, addr_reg=%d", ab, do, we, addr_reg);
		if (we)
			ram[ab] <= do;
		
		addr_reg <= ab;
		
	end
		
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign di = ram[addr_reg];


  //always @(posedge clk)
  //if (!we)
  //  temp_ram_out <= ram[ab];

  always @(posedge clk)

//Test Program 1 debug
//$display("mem %d %d %d", ram[17], ram[22], ram[23]);

//Test Program 2 debug
//$display("mem %d %d %d", ram[16'h440], ram[16'h35], ram[23]);

//Test program 3 debug
//$display("mem %d %d", ram[16'h50c], ram[16'h51b]);

//Test program 4 debug
//$display("mem %d %d", ram[16'h603], ram[16'h609]);

//Test program 5 debug
//$display("mem %d %d", ram[16'h63], ram[16'hc]);

//Test program 6 debug
//$display("mem %d %d", ram[16'h324], ram[16'h424]);

//Test program 7 debug
$display("mem %d %d", ram[16'h9e8], ram[16'ha113]);

  //always @(posedge clk)
  //assign di = we ? 8'hzz : ram[ab]/*temp_ram_out*/ ;

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
