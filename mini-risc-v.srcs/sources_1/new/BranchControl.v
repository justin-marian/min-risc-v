`timescale 1ns / 1ps

module branch_control #(parameter F3_WIDTH = 3) (
    input [F3_WIDTH-1:0] funct3,
    input zero,
    input alu_out,
    input Branch,
    output reg PCSrc
);

    localparam BEQ = 3'b000;
    localparam BNE = 3'b001;
    localparam BLT = 3'b100;
    localparam BGE = 3'b101;
    localparam BLTU = 3'b110;
    localparam BGEU = 3'b111;

    always @(*) begin
        // Default value is 0, as per the "în rest" in the table.
        PCSrc = 1'b0;
        // Check if Branch is asserted.
        if (Branch) begin
            case (funct3)
                BEQ: PCSrc = zero;       // beq
                BNE: PCSrc = ~zero;      // bne
                BLT: PCSrc = alu_out;    // blt
                BGE: PCSrc = ~alu_out;   // bge
                BLTU: PCSrc = alu_out;   // bltu
                BGEU: PCSrc = ~alu_out;  // bgeu
                default: PCSrc = 1'b0;
            endcase
        end
    end

endmodule
