This repository contains the code for a pipelined RISC-V 32-bit implementation in SystemVerilog. 

## Features:
- Data forwarding for data hazards including EX/MEM and MEM/WB hazards.
- Stall insertion for load-use hazards
- Branch resolution in the ID stage through one instruction flush 
- Data forwarding and stall insertion for load-use hazards during branch check.
- Compatibility with  lw, sw, addi, R-type (add, sub, and, or) and beq.

Verification was done for the above features using testbenches in Icarus Verilog and ModelSim, displaying register, memory, and control signal values each clock cycle.

## Block Diagram:
![IMG_64F9B2892418-1](https://github.com/user-attachments/assets/f6669a4f-f7ca-4252-af61-3c009bdeac15)

## Structure:
- `rtl/` - Source modules, both individual and combined based on pipeline stage
- `tb/` - Testbenches for individual modules and full CPU verification
