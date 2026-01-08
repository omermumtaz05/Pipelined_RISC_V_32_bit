# Pipelined RISC V 32 bit
This repository contains the code for a pipelined RISC-V 32-bit implementation in SystemVerilog. The CPU has five stages, which include instruction fetch (IF), instruction decode (ID), execute (EX), memory access (MEM), and write back (WB).

The CPU has been verified for:
 - Standard pipeline flow of instructions including lw, sw, addi, R-type, and beq
 - EX/MEM and MEM/WB data hazards triggering forwarding
 - Load-use hazards inserting NOPs
 - Control hazards - branch resolution done in ID stage flushing one instruction

   
