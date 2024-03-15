`timescale 1ns / 1ps

/// SECOND STAGE OF THE PIPELINE ID->EX

module STAGE_2_ID_EX #(
    parameter WIDTH = 32,
    parameter LEN_REG = 5,
    parameter LEN_OP = 2
)(
    input clk,
    input reset,
    input write, // Write enable signal == 1

    // Inputs from IF stage
    input [WIDTH-1:0] IMM_IF,
    input [WIDTH-1:0] REG_DATA1_IF,
    input [WIDTH-1:0] REG_DATA2_IF,
    input [WIDTH-1:0] PC_IF,
    input [2:0] FUNCT3_IF,
    input [6:0] FUNCT7_IF,
    input [6:0] OPCODE_IF,
    input [LEN_REG-1:0] RD_IF,
    input [LEN_REG-1:0] RS1_IF,
    input [LEN_REG-1:0] RS2_IF,

    // Control signals from IF stage
    input RegWrite_IF,
    input MemtoReg_IF,
    input MemRead_IF,
    input MemWrite_IF,
    input [1:0] ALUop_IF,
    input ALUSrc_IF,
    input Branch_IF,

    // Outputs to EX stage
    output reg [WIDTH-1:0] IMM_EX,
    output reg [WIDTH-1:0] REG_DATA1_EX,
    output reg [WIDTH-1:0] REG_DATA2_EX,
    output reg [WIDTH-1:0] PC_EX,
    output reg [2:0] FUNCT3_EX,
    output reg [6:0] FUNCT7_EX,
    output reg [6:0] OPCODE_EX,
    output reg [LEN_REG-1:0] RD_EX,
    output reg [LEN_REG-1:0] RS1_EX,
    output reg [LEN_REG-1:0] RS2_EX,

    // Control signals to EX stage
    output reg RegWrite_EX,
    output reg MemtoReg_EX,
    output reg MemRead_EX,
    output reg MemWrite_EX,
    output reg [1:0] ALUop_EX,
    output reg ALUSrc_EX,
    output reg Branch_EX
);

    always @(posedge clk) begin
        if (reset) begin
            // On reset, all outputs are set to default values
            IMM_EX <= 32'b0;
            REG_DATA1_EX <= 32'b0;
            REG_DATA2_EX <= 32'b0;
            PC_EX <= 32'b0;
            FUNCT3_EX <= 3'b000;
            FUNCT7_EX <= 7'b0000000;
            OPCODE_EX <= 7'b0000000;
            RD_EX <= 5'b00000;
            RS1_EX <= 5'b00000;
            RS2_EX <= 5'b00000;

            // Reset control signals
            RegWrite_EX <= 1'b0;
            MemtoReg_EX <= 1'b0;
            MemRead_EX <= 1'b0;
            MemWrite_EX <= 1'b0;
            ALUop_EX <= 2'b00;
            ALUSrc_EX <= 1'b0;
            Branch_EX <= 1'b0;
        end else if (write) begin
            // Transfer signals from IF to EX stage
            IMM_EX <= IMM_IF;
            REG_DATA1_EX <= REG_DATA1_IF;
            REG_DATA2_EX <= REG_DATA2_IF;
            PC_EX <= PC_IF;
            FUNCT3_EX <= FUNCT3_IF;
            FUNCT7_EX <= FUNCT7_IF;
            OPCODE_EX <= OPCODE_IF;
            RD_EX <= RD_IF;
            RS1_EX <= RS1_IF;
            RS2_EX <= RS2_IF;

            // Transfer control signals
            RegWrite_EX <= RegWrite_IF;
            MemtoReg_EX <= MemtoReg_IF;
            MemRead_EX <= MemRead_IF;
            MemWrite_EX <= MemWrite_IF;
            ALUop_EX <= ALUop_IF;
            ALUSrc_EX <= ALUSrc_IF;
            Branch_EX <= Branch_IF;
        end
    end

endmodule
