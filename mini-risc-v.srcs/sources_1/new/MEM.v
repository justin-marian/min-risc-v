`timescale 1ns / 1ps

module MEM #(
    parameter WIDTH = 32,
    parameter LEN_ADDR = 10,
    parameter F3_LEN = 3
)(
    input clk,
    input MemRead_MEM,
    input MemWrite_MEM,
    input [WIDTH-1:0] ALU_OUT_MEM,
    input [WIDTH-1:0] REG_DATA2_MEM,
    input [F3_LEN-1:0] funct3_MEM,
    input Zero_MEM,
    input Branch_MEM,
    output PCSrc,
    output [WIDTH-1:0] DATA_MEMORY_MEM
);

    // Data Memory
    data_memory #(
        .WIDTH(WIDTH),
        .LEN_ADDR(LEN_ADDR)
    ) DATA_MEMORY_MODULE (
        .clk(clk),       
        .mem_read(MemRead_MEM),
        .mem_write(MemWrite_MEM),
        .address(ALU_OUT_MEM),
        .write_data(REG_DATA2_MEM),
        .read_data(DATA_MEMORY_MEM)
    );    

    // Branch Control
    branch_control #(.F3_WIDTH(3))
    BRANCH_CONTROL_MODULE (
        .funct3(funct3_MEM),
        .zero(Zero_MEM),
        // LSB is used for branch decision
        .alu_out(ALU_OUT_MEM[0]),
        .Branch(Branch_MEM),
        .PCSrc(PCSrc)
    );

endmodule
