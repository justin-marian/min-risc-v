`timescale 1ns / 1ps

module mux4_1 #(
    parameter WIDTH = 32,
    parameter SEL_LINE = 2)
(
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    input [WIDTH-1:0] in3,
    input [WIDTH-1:0] in4,
    input [SEL_LINE-1:0] sel,
    output reg [WIDTH-1:0] out
);

    always@(in1, in2, in3, in4, sel) begin
        case(sel)
        2'b00: out = in1;
        2'b01: out = in2;
        2'b10: out = in3;
        2'b11: out = in4;
        endcase
    end

endmodule
