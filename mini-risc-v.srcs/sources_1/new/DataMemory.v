`timescale 1ns / 1ps

module data_memory #(
    parameter WIDTH = 32,
    parameter LEN_ADDR = 10)
(
    input clk, 
    input mem_read,
    input mem_write,
    input [WIDTH-1:0] address,
    input [WIDTH-1:0] write_data,
    output reg [WIDTH-1:0] read_data
);

    localparam LEN_OP = 2;
    localparam MEM_SIZE = WIDTH * WIDTH;
    // 32-bit data memory with 1024 words
    reg [WIDTH-1:0] DataMemory [0:MEM_SIZE-1];
    integer i;

    // Initialize memory with zeros
    initial begin
        // Set each memory location to 32-bit zero
        for (i = 0; i < MEM_SIZE; i = i + 1) begin 
            DataMemory[i] = 32'b0;
        end
    end 

    // Write to memory on the positive clock edge when mem_write is asserted
    always @(posedge clk) begin
        if (mem_write) begin
            // Write data to the specified address
            DataMemory[address[11:2]] <= write_data;
        end
    end

    // Read from memory whenever mem_read is asserted
    always @(*) begin
        if (mem_read) begin
            // Read data from the specified address
            read_data <= DataMemory[address[11:2]];
        end else begin
            // If not reading, maintain the current value
            read_data <= read_data;
        end
    end

endmodule
