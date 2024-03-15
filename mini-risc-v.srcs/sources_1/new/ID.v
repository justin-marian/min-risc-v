`timescale 1ns / 1ps

module ID #(
    parameter WIDTH = 32,
    parameter F7_LEN = 7,
    parameter F3_LEN = 3,
    parameter LEN_REG = 5)
(
    input clk,
    input [WIDTH-1:0] PC_ID,
    input [WIDTH-1:0] INSTRUCTION_ID,
    input RegWrite_WB,
    input [WIDTH-1:0] ALU_DATA_WB,
    input [LEN_REG-1:0] RD_WB,
    output [WIDTH-1:0] IMM_ID,
    output [WIDTH-1:0] REG_DATA1_ID,
    output [WIDTH-1:0] REG_DATA2_ID,
    output [F3_LEN-1:0] FUNCT3_ID,
    output [F7_LEN-1:0] FUNCT7_ID,
    output [WIDTH-1:0] OPCODE_ID,
    output [LEN_REG-1:0] RD_ID,
    output [LEN_REG-1:0] RS1_ID,
    output [LEN_REG-1:0] RS2_ID
);

    /// Send to PIPE ID_EX 2 STAGE
    assign FUNCT7_ID = INSTRUCTION_ID[31:25];
    assign RS2_ID = INSTRUCTION_ID[24:20];
    assign RS1_ID = INSTRUCTION_ID[19:15];
    assign FUNCT3_ID = INSTRUCTION_ID[14:12];
    assign RD_ID = INSTRUCTION_ID[11:7];
    assign OPCODE_ID = INSTRUCTION_ID[6:0];

    registers #(.WIDTH(WIDTH), .LEN_REG(LEN_REG)) 
    REGISTERS_MODULE (
        .clk(clk),
        .reg_write(RegWrite_WB),
        .read_reg1(RS1_ID),
        .read_reg2(RS2_ID),
        .write_reg(RD_WB),
        .write_data(ALU_DATA_WB),
        .read_data1(REG_DATA1_ID),
        .read_data2(REG_DATA2_ID)
    );

    imm_gen #(.WIDTH(WIDTH), .LEN_OPCODE(F7_LEN))
    IMM_GEN_MODULE (
        .in(INSTRUCTION_ID),
        .out(IMM_ID)
    );

endmodule
