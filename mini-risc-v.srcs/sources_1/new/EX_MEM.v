`timescale 1ns / 1ps

/// THIRD STAGE OF THE PIPELINE EX->MEM

module STAGE_3_EX_MEM #(
    parameter WIDTH = 32,
    parameter LEN_REG = 5,
    parameter LEN_OP = 2)
(
    input clk,
    input reset,
    input write, // Write enable signal == 1

    // Inputs from EX Stage
    input ZERO_EX,
    input [WIDTH-1:0] ALU_OUT_EX,
    input [WIDTH-1:0] PC_Branch_EX,
    input [WIDTH-1:0] REG_DATA2_EX_FINAL,
    input [LEN_REG-1:0] RD_EX,

    // Control signals from EX stage
    input RegWrite_EX,
    input MemtoReg_EX,
    input MemRead_EX,
    input MemWrite_EX,
    input [LEN_OP-1:0] ALUop_EX,
    input ALUSrc_EX,
    input Branch_EX,

    // Outputs to MEM Stage
    output reg ZERO_MEM,
    output reg [WIDTH-1:0] ALU_OUT_MEM,
    output reg [WIDTH-1:0] PC_Branch_MEM,
    output reg [WIDTH-1:0] REG_DATA2_MEM_FINAL,
    output reg [LEN_REG-1:0] RD_MEM,

    // Control signals to MEM stage
    output reg RegWrite_MEM,
    output reg MemtoReg_MEM,
    output reg MemRead_MEM,
    output reg MemWrite_MEM,
    output reg [LEN_OP-1:0] ALUop_MEM,
    output reg ALUSrc_MEM,
    output reg Branch_MEM
);

    always @(posedge clk) begin
        if (reset) begin
            // On reset, all outputs are set to default values
            ZERO_MEM <= 1'b0;
            ALU_OUT_MEM <= 32'b0;
            PC_Branch_MEM <= 32'b0;
            REG_DATA2_MEM_FINAL <= 32'b0;
            RD_MEM <= 5'b00000;

            // Reset control signals
            RegWrite_MEM <= 1'b0;
            MemtoReg_MEM <= 1'b0;
            MemRead_MEM <= 1'b0;
            MemWrite_MEM <= 1'b0;
            ALUop_MEM <= 2'b00;
            ALUSrc_MEM <= 1'b0;
            Branch_MEM <= 1'b0;
        end else if (write) begin
            // Transfer signals from EX to MEM stage
            ZERO_MEM <= ZERO_EX;
            ALU_OUT_MEM <= ALU_OUT_EX;
            PC_Branch_MEM <= PC_Branch_EX;
            REG_DATA2_MEM_FINAL <= REG_DATA2_EX_FINAL;
            RD_MEM <= RD_EX;

            // Transfer control signals
            RegWrite_MEM <= RegWrite_EX;
            MemtoReg_MEM <= MemtoReg_EX;
            MemRead_MEM <= MemRead_EX;
            MemWrite_MEM <= MemWrite_EX;
            ALUop_MEM <= ALUop_EX;
            ALUSrc_MEM <= ALUSrc_EX;
            Branch_MEM <= Branch_EX;
        end
    end

endmodule
