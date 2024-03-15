`timescale 1ns / 1ps

module ALU #(
    parameter ALUOP_WIDTH = 4,
    parameter DATA_WIDTH = 32
)(
    input [ALUOP_WIDTH-1:0] ALUop,
    input [DATA_WIDTH-1:0] ina,
    input [DATA_WIDTH-1:0] inb,
    output zero,
    output reg [DATA_WIDTH-1:0] out
);

    localparam ALU_AND = 4'b0000;
    localparam ALU_OR = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_XOR = 4'b0011;
    localparam ALU_SLL = 4'b0100;
    localparam ALU_SRL = 4'b0101;
    localparam ALU_SUB = 4'b0110;
    localparam ALU_SLT = 4'b0111;
    localparam ALU_SLTU = 4'b1000;
    localparam ALU_SRA = 4'b1001;

    always @(*) begin
        case (ALUop)
            ALU_AND: out <= ina & inb; 
            ALU_OR: out <= ina | inb; 
            ALU_ADD: out <= ina + inb;
            ALU_XOR: out <= ina ^ inb;
            ALU_SLL: out <= ina << inb;
            ALU_SRL: out <= ina >> inb;
            ALU_SUB: out <= ina - inb;
            ALU_SLT: out <= (ina < inb) ? {DATA_WIDTH{1'b1}} : {DATA_WIDTH{1'b0}};
            ALU_SLTU: out <= ($unsigned(ina) < $unsigned(inb)) ? {DATA_WIDTH{1'b1}} : {DATA_WIDTH{1'b0}};
            ALU_SRA: out <= ina >>> inb;
            default: out = {DATA_WIDTH{1'b0}};
        endcase
    end

    assign zero = (out == {DATA_WIDTH{1'b0}}) ? 1'b1 : 1'b0;

endmodule
