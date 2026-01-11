# Pipelined RISC V 32 bit
This repository contains the code for a pipelined RISC-V 32-bit implementation in SystemVerilog. 

The CPU consists of 5 stages which are:
- Instruction fetch (IF) containing instruction memory and program counter.
- Instruction decode (ID) containing the control unit, immediate generator, register file, and control hazard resolution.
- Execute (EX) containing the ALU, ALU control, and data forwarding unit.
- Memory access (MEM) containing data memory.
- Write back (WB) which writes data into registers if regWrite is asserted.

The CPU has been verified for:
 - Standard pipeline flow of instructions including lw, sw, addi, R-type, and beq
 - EX/MEM and MEM/WB data hazards triggering forwarding
 - Load-use hazards inserting NOPs
 - Control hazards - branch resolution done in ID stage flushing one instruction

   
