`timescale 1ns / 1ps

module PC #(parameter WIDTH = 32) (
    input clk,
    input res,
    input write,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

    // Program Counter: Reset or Update based on clk edge
    always @(posedge clk) begin
        // Reset the counter to 0 on reset signal
        if (res) begin
            out <= 0;
        // Update counter with input when write is enabled
        end else if (write) begin
            out <= in;
        end
    end

endmodule
