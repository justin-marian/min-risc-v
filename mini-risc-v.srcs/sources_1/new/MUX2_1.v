`timescale 1ns / 1ps

module mux2_1 #(parameter WIDTH = 32) (
    input [WIDTH-1:0] ina,
    input [WIDTH-1:0] inb,
    input sel,
    output reg [WIDTH-1:0] out
);

    // Select between ina & inb based on sel
    always @(ina, inb, sel) begin
        if (sel == 0) begin
            out = ina;
        end else begin
            out = inb;
        end
    end

endmodule
