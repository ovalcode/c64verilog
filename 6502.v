module _6502(di, do, clk, reset, we, ab);

//source
//dest
//regnum -> state driven choose src/dst/indxy
//index y/x
//registerfile

//new todo: wirre up alu inputs + outputs
//NB!! temp_alu_result has nine bits -> use one for carry
//wire assignment above already done. focus surroundings regsiters

  parameter WIDTH = 8;
  parameter RESET_0 = 8'd0,
            RESET_1 = 8'd1,
            DECODE = 8'd2,
            ABS0 = 8'd3,
            ABS1 = 8'd4,
            ZP0 = 8'd5,
            ZP1 = 8'd6,
            FETCH = 8'd7,
            STORE_TO_MEM = 8'd8,
            ABSX0 = 8'd9,
            ABSX1 = 8'd10,
            ABSX2 = 8'd11;
            //RESET_1 = 8'd1;


  reg [7:0] state;

  reg [7:0] temp_data;
  reg [7:0] alu_in_a;
  reg [7:0] alu_in_b = 0;
  wire [8:0] temp_alu_result;
  reg save_value_to_register;

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
  reg [1:0] src;
  reg [1:0] dst;
  wire [7:0] regfile = AXYS[reg_num];
  wire 	       clk, reset;

//alu register stores as soon as inputs change
//still need to have temp_data to sotre previous
  assign temp_alu_result = alu_in_a + alu_in_b;
  
  always @*
      alu_in_a <= di;

  //always @*
  //todo:change back to always block when additional conditions
  //assign alu_in_b = 0;

 
  always @(posedge clk)
    temp_data <= temp_alu_result;

  always @(posedge clk)
  begin
    pc <= pc_temp + pc_inc;
    //ab <= pc;
    //$display("Hello pc %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", pc, clk, ab, di, do, we, state, temp_data, reg_num, AXYS[0]);
    $display("Data, address:%d, we:%d, state:%d, regnum: %d, src:%d, dst:%d", ab, we, state, reg_num, src, dst);
    //ab we state reg_num, src, dst, 
    $display("Registers A:%d, X:%d, Y:%d", AXYS[0], AXYS[1], AXYS[2]);
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
       ZP0,
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
      ZP0: ab <= {8'd0, di};
      default: ab <= pc;
    endcase

  //write enable generator
  always @(posedge clk)
  begin
  case(state)
    ZP0,
    ABS1: we <= store;
    default: we <= 0;
  endcase
  $display("ssss %d", we);
  end

  //set register
  always @(posedge clk)
  if (state == DECODE)
    casex(di)
      8'b101xxxxx : load <= 1; //LDA, LDX, LDY
      default: load <= 0;
    endcase

  //store
  always @(posedge clk)
  if (state == DECODE)
    casex(di)
      8'b100xxxxx: store <= 1; //STA, STX, STY
      default: store <= 0;
    endcase

  //todo: create lways block for indexy/x

  always @*
  casex(state)
      DECODE: reg_num <= dst; 
      default: reg_num <= src;
    endcase

  always @(posedge clk)
  if (state == DECODE)
    casex(di)
      8'b100xxx01: src <= 0; //accumulator
      8'b100xxx10: src <= 1; //X
      8'b100xxx00: src <= 2; //Y
      default: src <= 0;
    endcase

  always @(posedge clk)
  if (state == DECODE)
    casex(di)
      8'b101xxx01: dst <= 0; //accumulator
      8'b101xxx10: dst <= 1; //X
      8'b101xxx00: dst <= 2; //Y
      default: dst <= 0;
    endcase

  always @*
    case (state)
      DECODE: save_value_to_register = load;
      default: save_value_to_register = 0; 
    endcase
  
  always @(posedge clk)
  if (save_value_to_register)
//  if (load)
    AXYS[reg_num] <= temp_data;

  always @(posedge clk)
  if (store)
    do = regfile;


  //state machine
  always @(posedge clk or posedge reset)
  if (reset)
  begin
      state <= RESET_0;
      //pc <= 0;
  end
  else case (state)
      DECODE: casex (di)
                8'bxxx01001,
                8'bxxx000x0: state <= FETCH;//Next state for immediate mode isntructions
                8'bxxx011xx: state <= ABS0; //Next state for absolute mode isntructions
                8'bxxx001xx: state <= ZP0; //Next state for zero page mode isntructions
                8'bxxx11001: state <= ABSX0;
                8'bxxx111xx: state <= ABSX0;
              endcase
      RESET_0: state <= RESET_1;
      RESET_1: state <= DECODE;
      ABS0: state <= ABS1;
      ABS1: state <= STORE_TO_MEM;
      ABSX0: state <= ABSX1;
      ABSX1: state <= ABSX2;
      //NB!! check absx2 scenario
      STORE_TO_MEM: state <= DECODE;
      ZP0: state <= ZP1;
      ZP1: state <= DECODE;
      FETCH: state <= DECODE;
      //RESET_1: state <= RESET_2;
      //RESET_2: state <= RESET_3;
      //RESET_3: state <= RESET_4;
  endcase

endmodule // counter
