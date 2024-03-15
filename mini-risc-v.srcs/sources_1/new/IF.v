`timescale 1ns / 1ps

module IF #(parameter WIDTH = 32) (
    input clk, 
    input reset,
    // Control signals to SEL the SRC of the next PC value.
    input PC_Src,                     // to SEL the SRC of the next PC value.
    input PC_Write,                   // to WE to the PC.
    // Branch address, used when PC_SRC is active.
    input  [WIDTH-1:0] PC_Branch,
    // Current PC value, sent to the next pipeline stage.
    output [WIDTH-1:0] PC_IF,
    // Fetched instruction corresponding to the current PC value.
    output [WIDTH-1:0] Instruction_IF
);

    // ADDER STAGE PC_IF -> PC_IF_4
    localparam [WIDTH-1:0] PC_INCREMENT = 32'h4;
    // INTRUCTION MEMORY STAGE PC_IF[11:2]
    localparam END_PC_ADDR = 11, START_PC_ADDR = 2;
    /// MUX STAGE
    wire [WIDTH-1:0] PC_IF_;             // Current PC value
    wire [WIDTH-1:0] PC_IF_4;            // PC value after increment
    wire [WIDTH-1:0] PC_mux;             // Output of the mux2
    // INSTRUCTION MEMORY STAGE
    wire [WIDTH-1:0] Instruction_IF_;   // Fetched current instruction

    // PC selection multiplexer
    mux2_1 #(.WIDTH(WIDTH))
    MUX2_1_IF_MODULE (
        .ina(PC_IF_4), 
        .inb(PC_Branch), 
        .sel(PC_Src), 
        .out(PC_mux)
    );

    // Program Counter
    PC #(.WIDTH(WIDTH))
    PC_MOUDLE (
        .clk(clk), 
        .res(reset), 
        .write(PC_Write), 
        .in(PC_mux), 
        .out(PC_IF_)
    );

    // PC incrementer
    adder #(.WIDTH(WIDTH))
    ADDER_IF_MODULE (
        .ina(PC_IF_), 
        .inb(PC_INCREMENT), 
        .out(PC_IF_4)
    );

    // Instruction Memory
    instruction_memory #(.WIDTH(WIDTH), .LEN_ADDR(END_PC_ADDR-START_PC_ADDR+1))
    INSTRUCTION_MEMORY_MODULE (
        .address(PC_IF_[END_PC_ADDR:START_PC_ADDR]), 
        .instruction_IF(Instruction_IF_)
    );

    /// Send to PIPE IF_ID 1 STAGE
    assign PC_IF = PC_IF_;
    assign Instruction_IF = Instruction_IF_;

endmodule
