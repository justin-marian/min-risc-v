`timescale 1ns / 1ps

module ALUcontrol #(
    parameter ALUOP_WIDTH = 2,
    parameter F7_WIDTH = 7,
    parameter F3_WIDTH = 3,
    parameter ALU_WIDTH = 4
)(
    input [ALUOP_WIDTH-1:0] ALUop,
    input [F7_WIDTH-1:0] funct7,
    input [F3_WIDTH-1:0] funct3,
    output reg [ALU_WIDTH-1:0] ALUinput
);
    // ld, sd
    localparam LD_SD_CASE =     12'b00xxxxxxxxxx;
    // R-type
    localparam ADD_CASE =       12'b100000000000;
    localparam ADDI_CASE =      12'b11xxxxxxx000;
    localparam SUB_CASE =       12'b100100000000;
    localparam AND_CASE =       12'b100000000111;
    localparam OR_CASE =        12'b100000000110;
    localparam ORI_CASE =       12'b11xxxxxxx110;
    localparam XOR_CASE =       12'b100000000100;
    // S-type
    localparam SRL_CASE =       12'b1x000000x101;
    localparam SLL_CASE =       12'b1x000000x001;
    localparam SRA_CASE =       12'b1x010000x101;
    // U-type
    localparam SLTU_CASE =      12'b100000000011;
    localparam SLT_CASE =       12'b100000000010;
    // B-type
    localparam BEQ_BNE_CASE =   12'b01xxxxxxx00x;
    localparam BLT_BGE_CASE =   12'b01xxxxxxx10x;
    localparam BLTU_BGEU_CASE = 12'b01xxxxxxx11x;

    always @(ALUop, funct7, funct3) begin
        casex({ALUop, funct7, funct3})
            // Load and Store operations
            LD_SD_CASE: ALUinput = 4'b0010; // ld, sd
        
            // Register-Register ALU operations
            ADD_CASE: ALUinput = 4'b0010; // add
            SUB_CASE: ALUinput = 4'b0110; // sub
            AND_CASE: ALUinput = 4'b0000; // and
            OR_CASE: ALUinput = 4'b0001; // or
            XOR_CASE: ALUinput = 4'b0011; // xor

            // Immediate ALU operations
            ADDI_CASE: ALUinput = 4'b0010; // addi
            ORI_CASE: ALUinput = 4'b0001; // ori
            SRL_CASE: ALUinput = 4'b0101; // srl, srli
            SLL_CASE: ALUinput = 4'b0100; // sll, slli
            SRA_CASE: ALUinput = 4'b1001; // sra, srai

            // Comparison operations
            SLTU_CASE: ALUinput = 4'b0111; // sltu
            SLT_CASE: ALUinput = 4'b1000; // slt

            // Branch operations
            BEQ_BNE_CASE: ALUinput = 4'b0110; // beq, bne
            BLT_BGE_CASE: ALUinput = 4'b1000; // blt, bge 
            BLTU_BGEU_CASE: ALUinput = 4'b0111; // bltu, bgeu
            default: ALUinput = 4'b0000; // Default operation
        endcase 
    end

endmodule
