`timescale 1ns / 1ps

module instruction_memory #(
    parameter WIDTH = 32,
    parameter LEN_ADDR = 10)
(
    input [LEN_ADDR-1:0]   address,
    output reg [WIDTH-1:0] instruction_IF
);

    // Calculate memory size based on address length
    localparam MEM_SIZE = 2**LEN_ADDR;
    reg [WIDTH-1:0] codeMemory [0:MEM_SIZE-1];

    initial begin
        $readmemh("code.mem", codeMemory);
    end

    // Memory read
    always @(address) begin
        // Check if the address is within the bounds of the memory
        if (address < MEM_SIZE) begin
            instruction_IF = codeMemory[address];
        // Return undefined value for out-of-range addresses
        end else begin
            instruction_IF = {WIDTH{1'bX}};
        end
    end

endmodule

