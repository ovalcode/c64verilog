module _6502(di, clk, reset, we, ab);

  parameter WIDTH = 8;
  parameter RESET_0 = 8'd0,
            //RESET_1 = 8'd1;
            DECODE = 8'd1;

  reg [7:0] state;

  input [WIDTH-1 : 0] di;
  output reg [15:0] ab;
  input 	       clk, reset;
  output we;
  reg [7:0] acc;
  reg load_acc;

//  reg [WIDTH-1 : 0]   out;
  reg we;
  reg [15:0] pc;
  reg [15:0] pc_temp;
  reg [15:0] pc_inc;
  wire 	       clk, reset;

  //state 0 -> reset everything pc, ab to 0
  // everything except state 0 -> increment pc by one

  always @(posedge clk)
  begin
    pc <= pc_temp + pc_inc;
    //ab <= pc;
    $display("Hello pc %d, %d", pc, clk);
    $display("Hello2 di %d, %d", di, clk);
    $display("Hello3 acc %d, %d", acc, clk);
  end

  //change pc_temp and pc_inc
  always @*
    case(state)
      RESET_0: begin 
                 pc_temp = 0;
                 pc_inc = 0;
               end
       default: pc_inc = 1;
      //everything starts happening at RESET_1 -> should actually be DECODE??
    endcase

  //address generator
  always @*
    case(state)
      default: ab = pc;
    endcase

  //set register
  always @(posedge clk)
  if (state == DECODE)
    case(di)
      8'ha9: load_acc <= 1;
      default: load_acc <= 0;
    endcase
  
  always @(posedge clk)
  if (load_acc)
    acc <= di;

   //write block parsing instruction codes
  always @*
    case(state)
      DECODE: case(di)
                8'ha9: state <= DECODE;//what must be done with LDA#imm?;
                //for decode increment PC
                //this should form part of state machine
              endcase
    endcase

  //state machine
  always @(posedge clk or posedge reset)
  if (reset)
  begin
      state <= RESET_0;
      //pc <= 0;
  end
  else case (state)
      DECODE: case (di)
                8'ha9: state <= DECODE;//do something//set next state
              endcase
      RESET_0: state <= DECODE;
      //RESET_1: state <= RESET_2;
      //RESET_2: state <= RESET_3;
      //RESET_3: state <= RESET_4;
  endcase

endmodule // counter
