import cpu_pkg::*;

module top(
    input logic clock, 
    input logic reset
    );

    // pc and if/id control
    logic PCWrite, if_id_writem;

    // mux control signals
    logic PCSrc;

    if_id_data_t ifid_data_in, ifid_data_out;

    logic [31:0] inc_addrs, branch_addrs, PC_in;

    //logic [31:0] instr;

    PC_source_mux pc_mux(.branch_address(branch_addrs), .increment_address(inc_addrs),
                            .PCSrc(PCSrc), .PC_input(PC_in));


    ProgramCounter PC (.clk(clock), .reset(reset),
                        .PCWrite(PCWrite), .next_pc(PC_in),
                        .pc(ifid_data_in.pc_address));

    pc_inc_adder pc_inc(.PC_out(PC_out), .inc_pc(inc_addrs));

    instruction_memory IM(.clock(clock), .address(PC_out), .read_instr(ifid_data_in.instruc));


    IF_ID if_id(.clock(clock), .reset(reset),
                if_id_data_t ifid_data_in,  if_id_data_t ifid_data_out);


endmodule
