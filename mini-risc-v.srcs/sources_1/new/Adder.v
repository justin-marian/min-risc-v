`timescale 1ns / 1ps

module adder #(parameter WIDTH = 32) (
    input [WIDTH-1:0] ina,
    input [WIDTH-1:0] inb,
    output reg [WIDTH-1:0] out
);

    // Add two 32-bit numbers
    always @(ina, inb) begin
         out = ina + inb;
    end

endmodule
