`timescale 1ns / 1ps

module registers #(
    parameter WIDTH = 32,
    parameter LEN_REG = 5)
(
    input clk,
    input reg_write,                    // Control signal to write to the register file
    // Source register to read
    input [LEN_REG-1:0] read_reg1,      
    input [LEN_REG-1:0] read_reg2, 
    // Write flags
    input [LEN_REG-1:0] write_reg,      // Address of the destination register to write
    input [WIDTH-1:0] write_data,       // Data to be written to the destination register
    // Destination register to read
    output reg [WIDTH-1:0] read_data1,  // Output data from the 1st source register
    output reg [WIDTH-1:0] read_data2   // Output data from the 2nd source register
);
   
    localparam REGS = 32;
    reg [WIDTH-1:0] Registers [0:REGS-1];

    integer i;
    // Initialize the registers in an initial block
    initial begin 
        for (i = 0; i < REGS; i = i + 1) begin
            Registers[i] = i;
        end
    end
 
    // Write operation (synchronous with the positive edge of the clock)
    always @(posedge clk) begin
        if (reg_write && write_reg != 0) begin
            Registers[write_reg] <= write_data;
        end 
    end
  
    // Read operation for read_reg1
    always @(*) begin
        if (read_reg1 == 0) begin
            read_data1 = 32'b0;
        end else if (reg_write && read_reg1 == write_reg) begin
            read_data1 = write_data;
        end else begin
            read_data1 = Registers[read_reg1];
        end
    end

    // Read operation for read_reg2
    always @(*) begin
        if (read_reg2 == 0) begin
            read_data2 = 32'b0;
        end else if (reg_write && read_reg2 == write_reg) begin
            read_data2 = write_data;
        end else begin
            read_data2 = Registers[read_reg2];
        end
    end

endmodule
