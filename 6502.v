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
            ABSX2 = 8'd11,
            ZPX0 = 8'd12,
            ZPX1 = 8'd13,
            INDX0 = 8'd14, 
            INDX1 = 8'd15,
            INDX2 = 8'd16,
            INDX3 = 8'd17,
            INDY0 = 8'd18,
            INDY1 = 8'd19,
            INDY2 = 8'd20,
            INDY3 = 8'd21,
            REG = 8'd22;
            //RESET_1 = 8'd1;


  reg [7:0] state;
  reg alu_carry_out;
  reg alu_carry_in;
  reg [7:0] temp_data;
  reg [7:0] alu_in_a;
  reg [7:0] alu_in_b;
  wire [8:0] temp_alu_result;
  reg save_value_to_register;

  reg C = 0;
  reg clc;
  reg sec;

  input [WIDTH-1 : 0] di;
  output reg [15:0] ab;
  reg [7:0] abl;
  reg [7:0] abh;
  input 	       clk, reset;
  output we;
  reg [7:0] AXYS [3:0];
  reg load;
  reg alu_in_a_only;
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
  reg index_y;
  wire [7:0] regfile = AXYS[reg_num];
  wire 	       clk, reset;

//alu register stores as soon as inputs change
//still need to have temp_data to sotre previous
  assign temp_alu_result = alu_in_a + alu_in_b + alu_carry_in;
  
  always @*
     case(state)
       INDX1: alu_in_a <= temp_data;
       default: alu_in_a <= di;
     endcase

  always @*
  begin
    abl <= ab[7:0];
    abh <= ab[15:8];
  end

  always @(posedge clk)
  if (state == DECODE)
  begin
    clc <= (di == 8'h18);
    sec <= (di == 8'h38);
  end

  always @(posedge clk)
  if (state == DECODE)
  begin
    if (clc) C <= 0;
    if (sec) C <= 1;
  end

  always @*
      case(state)
        INDY2,
        ABSX1: alu_carry_in <= alu_carry_out;
        INDY0,
        INDX1: alu_carry_in <= 1;
        STORE_TO_MEM,
        FETCH: alu_carry_in <= alu_in_a_only ? 0 : C;
        default: alu_carry_in <= 0;
      endcase

  always @*
    case(state)
      ZPX0,
      INDX0,
      INDY1,
      ABSX0: alu_in_b = regfile;
      FETCH,
      STORE_TO_MEM: alu_in_b = alu_in_a_only ? 0 : regfile;
  //todo:change back to always block when additional conditions
      default: alu_in_b = 0;
    endcase
 
  always @(posedge clk)
    temp_data <= temp_alu_result;

  always @(posedge clk)
    alu_carry_out <= temp_alu_result[8];


  always @(posedge clk)
  begin
    pc <= pc_temp + pc_inc;
    //ab <= pc;
    //$display("Hello pc %d, %d, %d, %d, %d, %d, %d, %d, %d, %d", pc, clk, ab, di, do, we, state, temp_data, reg_num, AXYS[0]);
    $display("Data, address:%d, abl:%d, abh:%d, we:%d, di:%d, do:%d state:%d, regnum: %d, src:%d, dst:%d, pc_inc:%d", ab, abl, abh, we, di, do, state, reg_num, src, dst, pc_inc);
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
       ABSX1,
       ABSX2,
       ZP0,
       ZPX0,      
       ZPX1,       
       INDX0,
       INDX1,
       INDX2,
       INDX3,
       INDY0,
       INDY1,
       INDY2,
       INDY3,
       RESET_0,
       /*FETCH,*/
       /*RESET_1,*/       
       REG: begin 
                 pc_inc = 0;
               end
       default: pc_inc = 1;
      //everything starts happening at RESET_1 -> should actually be DECODE??
    endcase

  //address generator
  always @*
    case(state)
      ABS1: ab = { di, temp_data };
      ABSX1: ab = {di, temp_data};
      ABSX2: ab = {temp_data, abl};
      ZPX1: ab = {8'd0, temp_data};
      ZP0: ab = {8'd0, di};
      INDX1,
      INDX2: ab = {8'd0, temp_data};
      INDX3: ab = {di, temp_data};
      INDY0: ab = {8'd0, di};
      INDY1: ab = {8'd0, temp_data};
      INDY2: ab = {di, temp_data};
      INDY3: ab = {temp_data, abl};
      REG: ab = {abh, abl};
      default: ab = pc;
    endcase

  //write enable generator
  always @*
  begin
  case(state)
    ZP0,
    ZPX1,
    ABSX2,
    INDX3,
    INDY3,
    ABS1: we = store;
    default: we = 0;
  endcase
  $display("ssss %d", we);
  end

  //set register
  always @(posedge clk)
  if (state == DECODE)
    casex(di)
      //NB!! This is load only. should actually for non-loadonly as well
      //load_only used to block to ALU
      8'b101xxxxx : alu_in_a_only <= 1; //LDA, LDX, LDY
      default: alu_in_a_only <= 0;
    endcase

  always @(posedge clk)
  if (state == DECODE)
    casex(di)
      //NB!! This is load only. should actually for non-loadonly as well
      //load_only used to block to ALU
      8'b011xxx01, //ADC
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

  always @(posedge clk)
  if (state == DECODE)
    casex(di) 
      8'bxxx100xx,
      8'bxxx110xx: index_y = 1;
      default: index_y = 0;
    endcase


  always @*
  casex(state)
      INDX0,
      INDY1,
      ZPX0,
      ABSX0: reg_num = index_y ? 2 : 1;
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

  always @*
  //if (store)
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
                8'b0xx11000: state <= REG;
                8'bxxx011xx: state <= ABS0; //Next state for absolute mode isntructions
                8'bxxx001xx: state <= ZP0; //Next state for zero page mode isntructions
                8'bxxx11001: state <= ABSX0;
                8'bxxx111xx: state <= ABSX0;
                8'bxxx00001: state <= INDX0;
                8'bxxx10001: state <= INDY0;
                8'bxxx101xx: state <= ZPX0;
              endcase
      RESET_0: state <= RESET_1;
      RESET_1: state <= DECODE;
      REG: state <= DECODE;
      ABS0: state <= ABS1;
      ABS1: state <= STORE_TO_MEM;
      ABSX0: state <= ABSX1;
      ABSX1: state <= (alu_carry_out | store) ? ABSX2 : STORE_TO_MEM;
      ABSX2: state <= STORE_TO_MEM;
      //NB!! check absx2 scenario
      STORE_TO_MEM: state <= DECODE;
      ZP0: state <= ZP1;
      ZP1: state <= DECODE;
      ZPX0: state <= ZPX1;
      ZPX1: state <= STORE_TO_MEM;
      INDX0: state <= INDX1;
      INDX1: state <= INDX2;
      INDX2: state <= INDX3;
      INDX3: state <= STORE_TO_MEM;
      INDY0: state <= INDY1;
      INDY1: state <= INDY2;
      INDY2: state <= (alu_carry_out | store) ? INDY3 : STORE_TO_MEM;
      FETCH: state <= DECODE;
      //RESET_1: state <= RESET_2;
      //RESET_2: state <= RESET_3;
      //RESET_3: state <= RESET_4;
  endcase

endmodule // counter
