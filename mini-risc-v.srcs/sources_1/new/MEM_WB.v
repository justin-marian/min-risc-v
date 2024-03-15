`timescale 1ns / 1ps

/// FOURTH STAGE OF THE PIPELINE MEM->WB

module STAGE_4_MEM_WB #(
    parameter WIDTH = 32,
    parameter LEN_REG = 5,
    parameter LEN_OP = 2
)(
    input clk,
    input reset,
    input write, // Write enable signal == 1

    // Inputs from MEM Stage
    input [WIDTH-1:0] read_data_MEM,
    input [WIDTH-1:0] address_MEM,
    input [LEN_REG-1:0] RD_MEM,
    input RegWrite_MEM,
    input MemtoReg_MEM,

    // Outputs to WB Stage
    output reg [WIDTH-1:0] read_data_WB,
    output reg [WIDTH-1:0] address_WB,
    output reg [LEN_REG-1:0] RD_WB,
    output reg RegWrite_WB,
    output reg MemtoReg_WB
);

    always @(posedge clk) begin
        if (reset) begin
            // On reset, all outputs are set to default values
            read_data_WB <= 32'b0;
            address_WB <= 32'b0;
            RD_WB <= 5'b00000;
            RegWrite_WB <= 1'b0;
            MemtoReg_WB <= 1'b0;
        end else if (write) begin
            // Transfer signals from MEM to WB stage
            read_data_WB <= read_data_MEM;
            address_WB <= address_MEM;
            RD_WB <= RD_MEM;

            // Transfer control signals
            RegWrite_WB <= RegWrite_MEM;
            MemtoReg_WB <= MemtoReg_MEM;
        end
    end

endmodule
