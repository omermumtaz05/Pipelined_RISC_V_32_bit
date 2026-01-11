# Pipelined RISC V 32 bit
This repository contains the code for a pipelined RISC-V 32-bit implementation in SystemVerilog. 

## The CPU's features include:
- Data forwarding for data hazards including EX/MEM and MEM/WB hazards.
- Stall insertion for load-use hazards
- Branch resolution in the ID stage through one instruction flush 
- Data forwarding and stall insertion for load-use hazards during branch check.
- Compatable with lw, sw, addi, R-type (add, sub, and, or) and beq.

## The CPU has been verified for:
 - Standard pipeline flow of instructions including lw, sw, addi, R-type, and beq
 - EX/MEM and MEM/WB data hazards triggering forwarding
 - Load-use hazards inserting NOPs
 - Control hazards - branch resolution done in ID stage flushing one instruction

   
