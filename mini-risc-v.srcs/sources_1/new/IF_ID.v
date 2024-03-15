`timescale 1ns / 1ps

/// FIRST STAGE OF THE PIPELINE IF->ID

module STAGE_1_IF_ID #(parameter WIDTH = 32) (
    input clk,
    input res,
    input write,
    // Program Counter & Instruction - Fetch Phase
    input [WIDTH-1:0] PC_in,
    input [WIDTH-1:0] Instruction_in,
    // Program Counter & Instruction - Decode Phase
    output reg [WIDTH-1:0] PC_out,
    output reg [WIDTH-1:0] Instruction_out
);

    // Updating pipeline registers
    always @(posedge clk) begin
        // Reset the register values
        if (res) begin
            PC_out <= 0;
            Instruction_out <= 0;
        // Update the registers on a positive clock edge
        end else if (write) begin
            PC_out <= PC_in;
            Instruction_out <= Instruction_in;
        end
    end

endmodule
