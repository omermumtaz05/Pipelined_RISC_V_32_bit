# Pipelined RISC V 32 bit
This repository contains the code for a pipelined RISC-V 32-bit implementation in SystemVerilog. 

## The CPU's verified features include
- Data forwarding for data hazards including EX/MEM and MEM/WB hazards.
- Stall insertion for load-use hazards
- Branch resolution in the ID stage through one instruction flush 
- Data forwarding and stall insertion for load-use hazards during branch check.
- Compatibility with  lw, sw, addi, R-type (add, sub, and, or) and beq.

Verification was done using testbenches displaying register values each clock cycle in Icarus Verilog and ModelSim.

## Block Diagram:
