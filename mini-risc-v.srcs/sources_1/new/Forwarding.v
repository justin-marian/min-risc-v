`timescale 1ns / 1ps

// Forwarding condition for MEM/WB hazard RAW TYPE:
// 1. There is a write (regwrite) in MEM/WB stage.
// 2. The destination register in MEM/WB matches rs1 or rs2.
// 3. EX/MEM stage doesn't already forward this register.

module forwarding #(parameter SIZE_REG = 5) (
    // Source register
    input [SIZE_REG-1:0] rs1,           // Source register 1
    input [SIZE_REG-1:0] rs2,           // Source register 2
    /// Destination register
    input [SIZE_REG-1:0] ex_mem_rd,     // EX/MEM pipeline stage
    input [SIZE_REG-1:0] mem_wb_rd,     // MEM/WB pipeline stage
    /// Write register
    input ex_mem_regwrite,              // EX/MEM stage
    input mem_wb_regwrite,              // MEM/WB stage
    /// Fowrwarding control 
    output reg [1:0] forwardA,          // forwarding rs1
    output reg [1:0] forwardB           // forwarding rs2
);

    always @(*) begin
        // Default no hazard values
        forwardA = 2'b00;
        forwardB = 2'b00;

        // Check for EX hazard for rs1 and rs2
        if (ex_mem_regwrite && (ex_mem_rd != 5'b0)) begin
            if (ex_mem_rd == rs1) forwardA = 2'b10; // EX/MEM hazard for rs1
            if (ex_mem_rd == rs2) forwardB = 2'b10; // EX/MEM hazard for rs2
        end

        // Check for MEM hazard for rs1 and rs2
        if (mem_wb_regwrite && (mem_wb_rd != 5'b0)) begin
            if ((mem_wb_rd == rs1) && !(ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == rs1)))
                forwardA = 2'b01; // MEM/WB hazard for rs1
            if ((mem_wb_rd == rs2) && !(ex_mem_regwrite && (ex_mem_rd != 5'b0) && (ex_mem_rd == rs2)))
                forwardB = 2'b01; // MEM/WB hazard for rs2
        end
    end

endmodule
