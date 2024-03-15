module RISC_V (
    input clk,   // Global clock signal
    input reset, // Global reset signal
    
    // Outputs from various pipeline stages
    // EX STAGE
    output [31:0] PC_EX_out,
    output [31:0] ALU_OUT_EX_out,
    // MEM STAGE
    output [31:0] PC_MEM_out,
    // BRANCH CONTROL
    output PCSrc_out,
    // PIPELINE MEM->WB
    output [31:0] DATA_MEMORY_MEM_out,
    output [31:0] ALU_DATA_WB_out,
    // FORWARD + HAZARD DETECTION
    output [1:0] forwardA_out, forwardB_out,
    output pipeline_stall_out
);

// ---------------------------------
// IF (Instruction Fetch) Stage Wires
// ---------------------------------
wire [31:0] PC_IF;             // Current Program Counter
wire [31:0] INSTRUCTION_IF;    // Fetched instruction

// ---------------------------------
// ID (Instruction Decode) Stage Wires
// ---------------------------------
wire [31:0] PC_ID;             // Program Counter in ID stage
wire [31:0] INSTRUCTION_ID;    // Current instruction in ID stage
wire [31:0] IMM_ID;            // Immediate value
wire [31:0] REG_DATA1_ID;      // Value of the first source register
wire [31:0] REG_DATA2_ID;      // Value of the second source register
wire [2:0] FUNCT3_ID;          // funct3 field from instruction
wire [6:0] FUNCT7_ID;          // funct7 field from instruction
wire [6:0] OPCODE_ID;          // Opcode of the instruction
wire [4:0] RD_ID;              // Destination register
wire [4:0] RS1_ID;             // First source register
wire [4:0] RS2_ID;             // Second source register

// ---------------------------------
// EX (Execute) Stage Wires
// ---------------------------------
wire [31:0] IMM_EX;            // Immediate value for EX stage
wire [31:0] REG_DATA1_EX;      // Source register 1 value
wire [31:0] REG_DATA2_EX;      // Source register 2 value
wire [2:0] FUNCT3_EX;          // funct3 field for EX stage
wire [6:0] FUNCT7_EX;          // funct7 field for EX stage
wire [6:0] OPCODE_EX;          // Opcode for EX stage
wire [4:0] RD_EX;              // Destination register for EX stage
wire [4:0] RS1_EX;             // First source register for EX stage
wire [4:0] RS2_EX;             // Second source register for EX stage

// Control signals
wire RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX;
wire [1:0] ALUop_EX;            // ALU operation code
wire ALUSrc_EX;                 // ALU source signal
wire Branch_EX;                 // Branch signal

wire ZERO_EX;                   // Zero flag from ALU
wire [31:0] PC_Branch_EX;       // Branch target address
wire [31:0] REG_DATA2_EX_FINAL; // Final value of second source register

// ---------------------------------
// MEM (Memory Access) Stage Wires
// ---------------------------------
wire ZERO_MEM;                 // Zero flag in MEM stage
wire [31:0] ALU_OUT_MEM;       // ALU result in MEM stage
wire [31:0] PC_Branch_MEM;     // Branch target in MEM stage
wire [31:0] REG_DATA2_MEM_FINAL; // Source register value in MEM stage
wire [4:0] RD_MEM;             // Destination register in MEM stage

// Control signals
wire RegWrite_MEM, MemtoReg_MEM, MemRead_MEM, MemWrite_MEM;
wire [1:0] ALUop_MEM;          // ALU operation code in MEM stage
wire ALUSrc_MEM;               // ALU source in MEM stage
wire Branch_MEM;               // Branch signal in MEM stage

wire [31:0] DATA_MEMORY_MEM; // Data read from memory

// ---------------------------------
// WB (Write Back) Stage Wires
// ---------------------------------
wire [31:0] read_data_WB;      // Data to be written back
wire [31:0] address_WB;        // Address for write back
wire [4:0] RD_WB;              // Destination register in WB stage
wire RegWrite_WB, MemtoReg_WB; // Control signals for WB stage

// ---------------------------------
// Control and Hazard Detection Wires
// ---------------------------------
wire RegWrite_ID, MemtoReg_ID, MemRead_ID, MemWrite_ID; // Control signals for ID stage
wire [1:0] ALUop_ID;           // ALU operation code for ID stage
wire ALUSrc_ID;                // ALU source signal for ID stage
wire Branch_ID;                // Branch signal for ID stage
wire PC_write, control_sel, IF_ID_write; // Control signals for pipeline control

// ---------------------------------
// EX Stage Wires
// ---------------------------------
wire [31:0] PC_EX;             // Program Counter for EX stage
wire [31:0] ALU_OUT_EX;        // ALU result in EX stage

// ---------------------------------
// MEM Stage Wires
// ---------------------------------
wire [31:0] PC_MEM;            // Program Counter for MEM stage
wire PCSrc;                    // Program Counter source signal

// ---------------------------------
// Write Back Stage Wires
// ---------------------------------
wire [31:0] ALU_DATA_WB;       // Data from ALU to be written back

// ---------------------------------
// Forwarding and Hazard Detection Wires
// ---------------------------------
wire [1:0] forwardA, forwardB; // Forwarding control signals
wire pipeline_stall;           // Pipeline stall signal
 
IF
INSTRUCTION_FETCH_MODULE (
    .clk(clk),
    .reset(reset),
    .PC_Src(PCSrc),
    .PC_Write(PC_write),
    .PC_Branch(PC_Branch_MEM),
    .PC_IF(PC_IF),
    .Instruction_IF(INSTRUCTION_IF)
);

STAGE_1_IF_ID
PIPE1_IF_ID (
    .clk(clk),
    .res(reset),
    .write(IF_ID_write),
    .PC_in(PC_IF),
    .Instruction_in(INSTRUCTION_IF),
    .PC_out(PC_ID),
    .Instruction_out(INSTRUCTION_ID)
);

ID
INSTRUCTION_DECODE_MODULE (
    .clk(clk),
    .PC_ID(PC_ID),
    .INSTRUCTION_ID(INSTRUCTION_ID),
    .RegWrite_WB(RegWrite_WB),
    .ALU_DATA_WB(ALU_DATA_WB),
    .RD_WB(RD_WB),
    .IMM_ID(IMM_ID),
    .REG_DATA1_ID(REG_DATA1_ID),
    .REG_DATA2_ID(REG_DATA2_ID),
    .FUNCT3_ID(FUNCT3_ID),
    .FUNCT7_ID(FUNCT7_ID),
    .OPCODE_ID(OPCODE_ID),
    .RD_ID(RD_ID),
    .RS1_ID(RS1_ID),
    .RS2_ID(RS2_ID)
);

control_path
CONTROL_PATH_MODULE (
    .opcode(OPCODE_ID),
    .control_sel(control_sel),
    .ALUSrc(ALUSrc_ID),
    .MemtoReg(MemtoReg_ID),
    .RegWrite(RegWrite_ID),
    .MemRead(MemRead_ID),
    .MemWrite(MemWrite_ID),
    .Branch(Branch_ID),
    .ALUop(ALUop_ID)
);
  
hazard_detection
HAZARD_DETECTION_MODULE (
    .rd(RD_EX),
    .rs1(RS1_ID),
    .rs2(RS2_ID),
    .MemRead(MemRead_EX),
    .PCwrite(PC_write),
    .IF_IDwrite(IF_ID_write),
    .Control_sel(control_sel)
);
         
STAGE_2_ID_EX
PIPE2_ID_EX (
    .clk(clk),
    .reset(reset),
    .write(1'b1),
    .IMM_IF(IMM_ID),
    .REG_DATA1_IF(REG_DATA1_ID),
    .REG_DATA2_IF(REG_DATA2_ID),
    .PC_IF(PC_ID),
    .FUNCT3_IF(FUNCT3_ID),
    .FUNCT7_IF(FUNCT7_ID),
    .OPCODE_IF(OPCODE_ID),
    .RD_IF(RD_ID),
    .RS1_IF(RS1_ID),
    .RS2_IF(RS2_ID),
    .RegWrite_IF(RegWrite_ID),
    .MemtoReg_IF(MemtoReg_ID),
    .MemRead_IF(MemRead_ID),
    .MemWrite_IF(MemWrite_ID),
    .ALUop_IF(ALUop_ID),
    .ALUSrc_IF(ALUSrc_ID),
    .Branch_IF(Branch_ID),
    .IMM_EX(IMM_EX),
    .REG_DATA1_EX(REG_DATA1_EX),
    .REG_DATA2_EX(REG_DATA2_EX),
    .PC_EX(PC_EX),
    .FUNCT3_EX(FUNCT3_EX),
    .FUNCT7_EX(FUNCT7_EX),
    .OPCODE_EX(OPCODE_EX),
    .RD_EX(RD_EX),
    .RS1_EX(RS1_EX),
    .RS2_EX(RS2_EX),
    .RegWrite_EX(RegWrite_EX),
    .MemtoReg_EX(MemtoReg_EX),
    .MemRead_EX(MemRead_EX),
    .MemWrite_EX(MemWrite_EX),
    .ALUop_EX(ALUop_EX),
    .ALUSrc_EX(ALUSrc_EX),
    .Branch_EX(Branch_EX)
);

EX
EXECUTE_MODULE (
    .IMM_EX(IMM_EX),         
    .REG_DATA1_EX(REG_DATA1_EX),
    .REG_DATA2_EX(REG_DATA2_EX),
    .PC_EX(PC_EX),
    .FUNCT3_EX(FUNCT3_EX),
    .FUNCT7_EX(FUNCT7_EX),
    .RD_EX(RD_EX),
    .RS1_EX(RS1_EX),
    .RS2_EX(RS2_EX),
    .RegWrite_EX(RegWrite_EX),
    .MemtoReg_EX(MemtoReg_EX),
    .MemRead_EX(MemRead_EX),
    .MemWrite_EX(MemWrite_EX),
    .ALUop_EX(ALUop_EX),
    .ALUSrc_EX(ALUSrc_EX),
    .Branch_EX(Branch_EX),
    .forwardA(forwardA),
    .forwardB(forwardB),
    .ALU_DATA_WB(ALU_DATA_WB),
    .ALU_OUT_MEM(ALU_OUT_MEM),
    .ZERO_EX(ZERO_EX),
    .ALU_OUT_EX(ALU_OUT_EX),
    .PC_Branch_EX(PC_Branch_EX),
    .REG_DATA2_EX_FINAL(REG_DATA2_EX_FINAL)
);

STAGE_3_EX_MEM
PIPE3_EX_MEM (
    .clk(clk),
    .reset(reset),
    .write(1'b1),
    .ZERO_EX(ZERO_EX),
    .ALU_OUT_EX(ALU_OUT_EX),
    .PC_Branch_EX(PC_Branch_EX),
    .REG_DATA2_EX_FINAL(REG_DATA2_EX_FINAL),
    .RD_EX(RD_EX),
    .RegWrite_EX(RegWrite_EX),
    .MemtoReg_EX(MemtoReg_EX),
    .MemRead_EX(MemRead_EX),
    .MemWrite_EX(MemWrite_EX),
    .ALUop_EX(ALUop_EX),
    .ALUSrc_EX(ALUSrc_EX),
    .Branch_EX(Branch_EX),
    .ZERO_MEM(ZERO_MEM),
    .ALU_OUT_MEM(ALU_OUT_MEM),
    .PC_Branch_MEM(PC_Branch_MEM),
    .REG_DATA2_MEM_FINAL(REG_DATA2_MEM_FINAL),
    .RD_MEM(RD_MEM),
    .RegWrite_MEM(RegWrite_MEM),
    .MemtoReg_MEM(MemtoReg_MEM),
    .MemRead_MEM(MemRead_MEM),
    .MemWrite_MEM(MemWrite_MEM),
    .ALUop_MEM(ALUop_MEM),
    .ALUSrc_MEM(ALUSrc_MEM),
    .Branch_MEM(Branch_MEM)
);

forwarding
FORWARDING_MODULE (
    .rs1(RS1_EX),
    .rs2(RS2_EX),
    .ex_mem_rd(RD_MEM),
    .mem_wb_rd(RD_WB),
    .ex_mem_regwrite(RegWrite_MEM),
    .mem_wb_regwrite(RegWrite_WB),
    .forwardA(forwardA),
    .forwardB(forwardB)
);      
                      
MEM
MEMORY_MODULE (
    .clk(clk),
    .MemRead_MEM(MemRead_MEM),
    .MemWrite_MEM(MemWrite_MEM),
    .ALU_OUT_MEM(ALU_OUT_MEM),
    .REG_DATA2_MEM(REG_DATA2_MEM_FINAL),
    .funct3_MEM(funct3_MEM),
    .Zero_MEM(ZERO_MEM),
    .Branch_MEM(Branch_MEM),
    .PCSrc(PCSrc),
    .DATA_MEMORY_MEM(DATA_MEMORY_MEM)
);

STAGE_4_MEM_WB
PIPE4_MEM_WB (
    .clk(clk),
    .reset(reset),
    .write(1'b1), // write enable always high
    .read_data_MEM(DATA_MEMORY_MEM),
    .address_MEM(ALU_OUT_MEM),
    .RD_MEM(RD_MEM),
    .RegWrite_MEM(RegWrite_MEM),
    .MemtoReg_MEM(MemtoReg_MEM),
    .read_data_WB(read_data_WB),
    .address_WB(address_WB),
    .RD_WB(RD_WB),
    .RegWrite_WB(RegWrite_WB),
    .MemtoReg_WB(MemtoReg_WB)
);

mux2_1
WRITE_BACK_MODULE (
    .ina(address_WB),
    .inb(read_data_WB),
    .sel(MemtoReg_WB),
    .out(ALU_DATA_WB)
); 
  
assign PC_EX_out = PC_EX;          
assign ALU_OUT_EX_out = ALU_OUT_EX;
assign PC_MEM_out = PC_Branch_MEM;

assign PCSrc_out = PCSrc;

assign DATA_MEMORY_MEM_out = DATA_MEMORY_MEM;
assign ALU_DATA_WB_out = ALU_DATA_WB;

assign forwardA_out = forwardA; 
assign forwardB_out = forwardB;
assign pipeline_stall_out = control_sel;        

endmodule
