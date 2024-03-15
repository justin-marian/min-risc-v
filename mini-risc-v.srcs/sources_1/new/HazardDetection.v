`timescale 1ns / 1ps

// Responsible for detecting data hazards that would:
//      require the pipeline to be stalled. 
//      ----------------------------------------------------------------------------------
//      it compares the destination register in the execute (EX) stage (rd)
//      with source registers in the instruction fetch/decode (IF/ID) stage (rs1 and rs2).
//      ----------------------------------------------------------------------------------
//      if a match is found and the EX stage instruction is a memory read,
//      it generates signals to stall the pipeline.

module hazard_detection #(parameter SIZE_REG = 5) (
    // Destination register in the EX stage
    input [SIZE_REG-1:0] rd,
    // Source registers in IF/ID stage
    input [SIZE_REG-1:0] rs1,
    input [SIZE_REG-1:0] rs2,
    // EX stage instruction is a memory read
    input MemRead,
    // Control signal for writing
    output reg PCwrite,      // to the PC
    output reg IF_IDwrite,   // to the IF/ID register
    // Control signal (select the source of control signals)
    output reg Control_sel
);

    // Combinational logic to detect hazards and control the pipeline
    always @(*) begin
        // Check for memory read hazard conditions
        if (MemRead && ((rd == rs1) || (rd == rs2))) begin
            // Hazard detected: stall the pipeline
            PCwrite = 1'b0;
            IF_IDwrite = 1'b0;
            Control_sel = 1'b1;
        end else begin
            // No hazard detected: normal pipeline operation
            PCwrite = 1'b1;
            IF_IDwrite = 1'b1;
            Control_sel = 1'b0;
        end
    end

endmodule
