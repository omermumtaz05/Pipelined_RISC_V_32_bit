# Pipelined RISC V 32 bit
This repository contains the code for a pipelined RISC-V 32-bit implementation in SystemVerilog. 

## The CPU's features include
- Data forwarding for data hazards including EX/MEM and MEM/WB hazards.
- Stall insertion for load-use hazards
- Branch resolution in the ID stage through one instruction flush 
- Data forwarding and stall insertion for load-use hazards during branch check.
- Compatibility with  lw, sw, addi, R-type (add, sub, and, or) and beq.

Verification was done for the above features using testbenches in Icarus Verilog and ModelSim, displaying register, memory, and control signal values each clock cycle.

## Block Diagram:
<img width="1193" height="918" alt="Screenshot 2026-01-10 at 8 16 21 PM" src="https://github.com/user-attachments/assets/b967f33c-4de1-4e77-a7cc-83f21baaf679" />

