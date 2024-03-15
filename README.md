# [Tiny-RISC-V](./documents/draw_riscv.pdf)

## Description

The `Tiny RISC-V processor` is a **minimalist implementation** based on the [RISC-V Instruction Set Architecture (ISA)](./documents/tinyrv-isa.txt). The processor is implemented more from a logical perspective of how it works.

The implementation of the RV32I extension. This **32-bit processor** is capable of executing integer arithmetic and logical instructions without support for **floating-point operations or multiplication/division**.

## Key Features

- `RV32I Extension`: Supports the RV32I instruction set, focusing on integer arithmetic and logical operations.
- Implements a classic **five-stage pipeline architecture** for instruction execution, including `Fetch`, `Decode`, `Execute`, `Memory`, and `Write-back` stages.
- Incorporates **hazard detection** mechanisms to handle **data hazards** and **control hazards** within the pipeline.
- Utilizes **forwarding techniques** to resolve data hazards by forwarding data from the execution stage to *dependent stages*.
- Implements a **control path** for managing instruction *flow* and handling *control* hazards.
- Includes **error detection** mechanisms at *each stage of the pipeline* to ensure reliable operation.

## Processor Pipeline

**Each stage** in the RISC-V processor pipeline plays a **crucial role** in instruction execution, contributing to higher performance through parallelism and pipelining while reducing instruction latency. Here's a brief overview of the pipeline stages:

- Each pipeline stage has its own set of control signals and data paths.
- Pipeline registers are used to store data and control signals between stages.
- Control signals determine the flow of data and execution of operations in each stage.
- Hazards, such as data hazards and control hazards, are detected and resolved using forwarding logic and branch prediction techniques.

These stages work together to facilitate efficient instruction execution within the RISC-V processor pipeline, demonstrating the effectiveness of parallelism and pipelining in achieving optimal performance.

### Instruction Fetch (IF)

<p align="center">
  <img src="images/IF.png" width="75%" alt="IF">
</p>

**IF (Instruction Fetch):** Initiates the instruction fetching process by accessing the instruction memory and retrieving the current instruction based on the program counter (PC). It ensures a smooth flow of instructions into the pipeline and handles branching or jumping operations.

- **Signals:**
  - **PC:** holds the address of the next instruction to be fetched. It is updated based on the control signals and branch outcomes.
  - **Instruction Memory:** provides the instruction located at the address specified by the PC. The fetched instruction is then transferred to the subsequent pipeline stages.
  - **PC Write:** determines whether the PC should be updated. It is controlled by branch or jump instructions, indicating whether the PC should be modified to redirect the instruction flow.
  - **IF/ID Pipeline Register:** The IF/ID pipeline register serves as a buffer between the IF and ID stages, transferring the fetched instruction to the ID stage for further processing.

- **Operations:**
  - Increment PC: The PC is incremented to point to the address of the next instruction in memory, ensuring sequential instruction fetching.
  - Fetch Instruction: The instruction memory is accessed using the current value of the PC, retrieving the instruction stored at that address.
  - Control Signal Determination: Control signals for branching and jumping are determined based on the fetched instruction. However, the execution of branching or jumping instructions is deferred until the ID stage, where the decision is made whether to update the PC.

### Instruction Decode (ID)

<p align="center">
  <img src="images/ID.png" width="75%" alt="ID">
</p>

**ID (Instruction Decode):** The ID stage decodes the fetched instruction, determines its operation and operands, and reads register values from the register file. Additionally, it sets up data paths for subsequent stages and identifies register sources and destinations for efficient data handling.

- **Signals:**
  - **Instruction:** Contains the decoded instruction, providing information about the operation to be performed.
  - **Registers:** Provides register values for the instruction's operands, ensuring that necessary data is available for execution.
  - **Control Signals:** Control signals specify various operations, such as ALU operation selection and register write enable, ensuring correct instruction execution.
  - **Immediate Generation:** Generates immediate values for certain instructions, facilitating efficient execution of arithmetic or logical operations.
  - **Forwarding Signals:** Indicate whether data forwarding is needed to resolve hazards, ensuring smooth execution without stalls.
  - **Branch Control Signals:** Determine branch conditions and control branching within the pipeline, managing instruction flow effectively.
  - **ID/EX Pipeline Register:** Transfers decoded instruction and relevant control signals to the EX stage, enabling seamless execution of instructions.

- **Operations:**
  - Decode the instruction and extract relevant fields, such as the opcode, source/destination registers, and immediate value, preparing it for execution.
  - Read register values from the register file, ensuring that necessary data is available for instruction execution.
  - Generate control signals based on the instruction type, orchestrating various operations within the pipeline for correct execution.
  - Prepare data forwarding and branch control signals for the next stage, facilitating efficient execution and handling of hazards.

### Execute (EX)

<p align="center">
  <img src="images/EX.png" width="75%" alt="EX">
</p>

**EX (Execute):** The EX stage performs the actual execution of instructions, including arithmetic and logical operations using the ALU, calculation of branch targets, and management of data forwarding to resolve hazards. It also makes decisions on branching based on control instructions.

- **Signals:**
  - **ALU Inputs:** Receive operands from the ID stage or forwarded values, providing necessary data for ALU operations.
  - **Control Signals:** Specify the ALU operation and other execution details, ensuring correct operation execution.
  - **Branch Target Address:** Calculated for branch instructions, determining the target address for branching.
  - **EX/MEM Pipeline Register:** Transfers operation results and necessary data to the MEM stage, facilitating data flow within the pipeline.

- **Operations:**
  - Perform arithmetic, logic, or shift operation using the ALU, providing necessary computation for instruction execution.
  - Calculate branch target addresses, deciding whether to take a branch based on control instructions, managing instruction flow within the pipeline.
  - Forward data if necessary to resolve hazards, ensuring smooth execution without stalls.
  - Prepare data for the next stage based on the operation type, facilitating efficient execution and data flow within the pipeline.

### Memory (MEM) $-$ Write Back (WB)

<p align="center">
  <img src="images/MEM_WB.png" width="75%" alt="MEM_WB">
</p>

**MEM (Memory):** The MEM stage handles memory access operations for load and store instructions, ensuring seamless interaction with the data memory. It reads data from memory for load operations, writes data to memory for store operations, and manages memory-related hazards such as cache misses or contention.

- **Signals:**
  - **Data Memory:** Reads/writes data from/to memory, facilitating interaction with the data memory.
  - **Data Address:** Specifies the memory address for data access, determining the location of data in memory.
  - **Write Data:** Data to be written to memory for store instructions, ensuring proper data storage.
  - **MEM/WB Pipeline Register:** Transfers data read from memory or other operation results to the WB stage, enabling seamless data flow within the pipeline.

- **Operations:**
  - Access data memory for load/store instructions, ensuring proper interaction with the data memory.
  - Read data from memory for load instructions, retrieving necessary data for instruction execution.
  - Write data to memory for store instructions, ensuring proper data storage and management.
  - Manage memory-related hazards such as cache misses or contention, ensuring proper synchronization and operation within the pipeline.

**WB (Write Back):** The WB stage completes the instruction execution cycle by writing the final results back to the register file. It updates register values based on the instruction's execution, ensuring subsequent instructions have access to the updated data.

- **Signals:**
  - **Register Write Data:** Result of the operation to be written back to the register file, updating register values for subsequent instructions.
  - **Write Register:** Specifies the destination register for the write operation, determining where the operation result should be stored.
  - **RegWrite:** Control signal to enable register writing, managing register file updates effectively.

- **Operations:**
  - Write back the operation result to the specified register in the register file, updating register values for subsequent instructions.
  - Control whether the register write operation should be enabled, ensuring proper register file management and operation within the pipeline.
