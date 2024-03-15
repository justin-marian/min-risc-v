`timescale 1ns / 1ps

module EX #(
    parameter WIDTH = 32,
    parameter FUNCT3_WIDTH = 3,
    parameter FUNCT7_WIDTH = 7,
    parameter ALUOP_WIDTH = 2
)(
    input [WIDTH-1:0] IMM_EX,
    input [WIDTH-1:0] REG_DATA1_EX,
    input [WIDTH-1:0] REG_DATA2_EX,
    input [WIDTH-1:0] PC_EX,
    input [FUNCT3_WIDTH-1:0] FUNCT3_EX,
    input [FUNCT7_WIDTH-1:0] FUNCT7_EX,
    input [WIDTH-1:0] RD_EX,
    input [WIDTH-1:0] RS1_EX,
    input [WIDTH-1:0] RS2_EX,
    
    input RegWrite_EX,
    input MemtoReg_EX,
    input MemRead_EX,
    input MemWrite_EX,
    input [ALUOP_WIDTH-1:0] ALUop_EX,
    input ALUSrc_EX,
    input Branch_EX,
    
    input [1:0] forwardA,
    input [1:0] forwardB,
    
    input [WIDTH-1:0] ALU_DATA_WB,
    input [WIDTH-1:0] ALU_OUT_MEM,
    output ZERO_EX,
    output [WIDTH-1:0] ALU_OUT_EX,
    output [WIDTH-1:0] PC_Branch_EX,
    output [WIDTH-1:0] REG_DATA2_EX_FINAL
);

    wire [WIDTH-1:0] OUT_MUX_FA, OUT_MUX_FB, OUT_ALU_Src2;
    wire [ALUOP_WIDTH-1:0] ALU_cont;

    // MUX for forwardA
    mux4_1 #(.WIDTH(WIDTH), .SEL_LINE(2))
    MUX4_1_EX_MODULE_FA (
        .in1(REG_DATA1_EX),
        .in2(ALU_DATA_WB),
        .in3(ALU_OUT_MEM),
        .in4(32'h0),
        .sel(forwardA),
        .out(OUT_MUX_FA)
    );

    // MUX for forwardB
    mux4_1 #(.WIDTH(WIDTH), .SEL_LINE(2))
    MUX4_1_EX_MODULE_FB (
        .in1(REG_DATA2_EX),
        .in2(ALU_DATA_WB),
        .in3(ALU_OUT_MEM),
        .in4(32'h0),
        .sel(forwardB),
        .out(OUT_MUX_FB)
    );

    // MUX for ALUSrc
    mux2_1 #(.WIDTH(WIDTH))
    MUX2_1_EX_MODULE_ALUSRC ( 
        .ina(OUT_MUX_FB),
        .inb(IMM_EX),
        .sel(ALUSrc_EX),
        .out(OUT_ALU_Src2)
    );
    
    // ALU Control
    ALUcontrol #(
        .ALUOP_WIDTH(ALUOP_WIDTH),
        .F7_WIDTH(FUNCT7_WIDTH),
        .F3_WIDTH(FUNCT3_WIDTH),
        .ALU_WIDTH(4)
    )
    ALUCONTROL_MODULE (
        .ALUop(ALUop_EX),
        .funct7(FUNCT7_EX),
        .funct3(FUNCT3_EX),
        .ALUinput(ALU_cont)
    );
    
    // ALU operation
    ALU #(.ALUOP_WIDTH(ALUOP_WIDTH), .DATA_WIDTH(WIDTH))
    ALU_MODULE (
        .ALUop(ALU_cont),
        .ina(OUT_MUX_FA),
        .inb(OUT_ALU_Src2),
        .zero(ZERO_EX),
        .out(ALU_OUT_EX)
    );

    // Branch Address Calculation
    adder #(.WIDTH(WIDTH))
    ADDER_EX_MODULE (
        .ina(PC_EX),
        .inb(IMM_EX),
        .out(PC_Branch_EX)
    );

    /// Send to PIPE EX_MEM 3 STAGE
    assign REG_DATA2_EX_FINAL = OUT_MUX_FB;

endmodule
