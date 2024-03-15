`timescale 1ns / 1ps

module control_path #(
    parameter LEN_OPCODE = 7,
    parameter LEN_OP = 2)
(
    input [LEN_OPCODE-1:0] opcode,    // Opcode from the ISA
    input control_sel,                // Control select signal
    // Control signals
    output reg ALUSrc,                // Signal to select the ALU source
    output reg MemtoReg,              // move data from memory to register
    output reg RegWrite,               // Signal for register write operation
    output reg MemRead,               // memory read operation
    output reg MemWrite,              // Signal for memory write operation
    output reg Branch,                // branching
    // ALU operation code
    output reg [LEN_OP-1:0] ALUop
);

    //                          OPCODES
    localparam OPCODE_NOP = 7'b0000000;            // No operation
    localparam OPCODE_LW = 7'b0000011;             // Load word
    localparam OPCODE_SW = 7'b0100011;             // Store word
    localparam OPCODE_R32 = 7'b0110011;            // R32-format instructions
    localparam OPCODE_R32I = 7'b0010011;           // R32-Immediate format instructions
    localparam OPCODE_BRANCH = 7'b1100011;         // Branch instructions
    localparam OPCODE_CONTROL_HIGH = 1'b1;         // Control signal high

    //                      CONTROL SIGNALS
    localparam CONTROL_NOP = 8'b00000000;            // No operation
    localparam CONTROL_LW = 8'b11110000;             // Load word
    localparam CONTROL_SW = 8'b10001000;             // Store word
    localparam CONTROL_R32 = 8'b00100010;            // R32-format instructions
    localparam CONTROL_R32I = 8'b10100011;           // R32-Immediate format instructions
    localparam CONTROL_BRANCH = 8'b00000101;         // Branch instructions

    always @(opcode, control_sel) begin
        casex ({control_sel, opcode})
            // When control_sel is high, disable all controls
            {OPCODE_CONTROL_HIGH, 7'bxxxxxxx}: 
                {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= CONTROL_NOP;
            // No operation (NOP) from ISA
            {1'b0, OPCODE_NOP}: 
                {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= CONTROL_NOP;
            // Load word (LW)
            {1'b0, OPCODE_LW}: 
                {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= CONTROL_LW;
            // Store word (SW)
            {1'b0, OPCODE_SW}: 
                {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= CONTROL_SW;
            // R32-format instructions
            {1'b0, OPCODE_R32}: 
                {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= CONTROL_R32;
            // R32-Immediate format instructions
            {1'b0, OPCODE_R32I}: 
                {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= CONTROL_R32I;
            // Branch instructions
            {1'b0, OPCODE_BRANCH}: 
                {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= CONTROL_BRANCH;
            // Default case for unrecognized opcodes
            default:     
                {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= CONTROL_NOP;
        endcase
    end

endmodule
