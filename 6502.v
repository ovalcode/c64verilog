module _6502(di, do, clk, reset, we, ab);

  parameter WIDTH = 8;
  parameter RESET_0 = 8'd0,
            ABS0 = 8'd1,
            ABS1 = 8'd2,
            ABS2 = 8'd3,            

            //RESET_1 = 8'd1;
            DECODE = 8'd4;

  reg [7:0] state;

  reg [7:0] temp_data;

  input [WIDTH-1 : 0] di;
  output reg [15:0] ab;
  input 	       clk, reset;
  output we;
  reg [7:0] AXYS [3:0];
  reg load;
  reg store;
  output reg [7:0] do;

//  reg [WIDTH-1 : 0]   out;
  reg we;
  reg [15:0] pc;
  reg [15:0] pc_temp;
  reg [15:0] pc_inc;
  reg [1:0] reg_num;
  wire 	       clk, reset;

  //state 0 -> reset everything pc, ab to 0
  // everything except state 0 -> increment pc by one

  always @(posedge clk)
  temp_data <= di;

  always @(posedge clk)
  begin
    pc <= pc_temp + pc_inc;
    //ab <= pc;
    $display("Hello pc %d, %d, %d, %d, %d, %d, %d, %d", pc, clk, ab, di, do, we, state, temp_data);
    //$display("Hello2 di %d, %d", di, clk);
    //$display("Hello3 acc %d, %d", acc, clk);
  end

  //update pctemp
  always @*
    case(state)
      RESET_0: begin 
                 pc_temp = 0;
                 $display("setting");
               end
       default: pc_temp = pc;
    endcase

  //change pc_inc
  always @*
    case(state)
       ABS1,
       RESET_0: begin 
                 pc_inc = 0;
               end
       default: pc_inc = 1;
      //everything starts happening at RESET_1 -> should actually be DECODE??
    endcase

  //address generator
  always @(posedge clk)
    case(state)
      ABS1: ab <= { di, temp_data };
      default: ab <= pc;
    endcase

  //write enable generator
  always @(posedge clk)
  begin
  case(state)
    ABS1: we <= 1;
    default: we <= 0;
  endcase
  $display("ssss %d", we);
  end

  //set register
  always @(posedge clk)
  if (state == DECODE)
    case(di)
      8'b101xxxxx : load <= 1; //LDA, LDX, LDY
      default: load <= 0;
    endcase

  //store
  always @(posedge clk)
  if (state == DECODE)
    case(di)
      8'b100xxxxx: store <= 1; //STA, STX, STY
      default: store <= 0;
    endcase

  always @(posedge clk)
  if (state == DECODE)
    case(di)
      8'bxxxxxx01: reg_num <= 0; //accumulator
      8'bxxxxxx10: reg_num <= 1; //X
      8'bxxxxxx00: reg_num <= 2; //Y
      default: reg_num <= 0;
    endcase
  
  always @(posedge clk)
  if (load)
    AXYS[reg_num] <= di;

  always @(posedge clk)
  if (store)
    do = AXYS[reg_num];


  //state machine
  always @(posedge clk or posedge reset)
  if (reset)
  begin
      state <= RESET_0;
      //pc <= 0;
  end
  else case (state)
      DECODE: case (di)
                8'bxxx010xx: state <= DECODE;//Next state for immediate mode isntructions
                8'bxxx011xx: state <= ABS0; //Next state for immediate mode isntructions
              endcase
      RESET_0: state <= DECODE;
      ABS0: state <= ABS1;
      ABS1: state <= ABS2;
      ABS2: state <= DECODE;
      //RESET_1: state <= RESET_2;
      //RESET_2: state <= RESET_3;
      //RESET_3: state <= RESET_4;
  endcase

endmodule // counter
