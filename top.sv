import cpu_pkg::*;

module top(
    input logic clock, 
    input logic reset
    );

    // pc and if/id control
    logic PCWrite, if_id_write;

    // control unit output signals
    logic [1:0] ALUOp;
    logic ALUSrc, branch, mem_read, mem_write, reg_write, mem_to_reg;

    // mux control signals
    logic PCSrc, control_mux;
    
    //pipeline register values

    if_id_data_t ifid_data_in, ifid_data_out;

    id_ex_data_t idex_data_in, idex_data_out;

    id_ex_control_t idex_control_in, idex_control_out, all_ctrl_out;

    mem_wb_data_t memwb_data_in, memwb_data_out;

    ex_mem_data_t exmem_data_in, exmem_data_out;

    // fwd sels
    logic [1:0] fwd_a_sel, fwd_b_sel;

    //alu inps
    logic [31:0] ALU_inp_1, ALU_inp_2;

    //alu ctrl and zero
    logic [3:0] ALU_control;
    logic zero;

    logic [31:0] inc_addrs, branch_addrs, PC_in;
    logic [31:0] memtoreg_mux_out;
    logic [31:0] imm;
    

    // IF stage:
    PC_source_mux pc_mux(.branch_address(branch_addrs), .increment_address(inc_addrs),
                            .PCSrc(PCSrc), .PC_input(PC_in));


    ProgramCounter PC (.clk(clock), .reset(reset),
                        .PCWrite(PCWrite), .next_pc(PC_in),
                        .pc(ifid_data_in.pc_address));

    pc_inc_adder pc_inc(.PC_out(PC_out), .inc_pc(inc_addrs));

    instruction_memory IM(.clock(clock), .address(PC_out), .read_instr(ifid_data_in.instruc));


    IF_ID if_id(.clock(clock), .reset(reset), .if_id_write(if_id_write),
                .data_in(ifid_data_in), .data_out(ifid_data_out));

    // ID stage:

    register RF(.clk(clock), .reset(reset),
                .readReg1(ifid_data_out.instruc[19:15]), .readReg2(ifid_data_out.instruc[24:20]),
                .writeReg(memwb_data_out.rd), .writeData(memtoreg_mux_out),
                .regWrite(reg_write) .readData1(idex_data_in.reg_read_data1), readData2(idex_data_in.reg_read_data2));


 

    imm_gen imm_gen(.inst(ifid_data_out.instruc), .imm(idex_data_in.imm));


    hazard_detection haz_dec(.id_ex_mem_read(idex_control_out.M_mem_read), .id_ex_rd(idex_data_out.rd),
                             .if_id_rs1(ifid_data_out.instruc[19:15]), .if_id_rs2(ifid_data_out.instruc[24:20]),
                             .PCWrite(PCWrite), .if_id_write(if_id_write), .control_mux_sig(control_mux));

    
    control control_unit(.instruc(ifid_data_out.instruc), .all_ctrl_out(all_ctrl_out));

    control_mux ctrl_mux(.all_control_in(all_ctrl_out), .stall(control_mux), .all_control_out(idex_control_in));


    assign idex_data_in.pc_address = ifid_data_out.pc_address;
 
    assign idex_data_in.funct_inst_bits = {ifid_data_out.instruc[30], ifid_data_out.instruc[14:12]}
    assign idex_data_in.rd = ifid_data_out.instruc[11:7];


    ID_EX idex_reg(.clock(clock), .reset(reset), .data_in(idex_data_in), .control_in(idex_control_in),
                    .data_out(idex_data_out), .control_out(idex_control_out));


    //EX stage


    forward_a_mux fwd_a_mux(
    .read_data_1(idex_data_out.reg_read_data1),
    .ex_mem_out(exmem_data_out.ALU_result),
    .mem_wb_out(memtoreg_mux_out),

    .forward_a(fwd_a_sel),

    .alu_inp_1(ALU_inp_1)
    );

    forward_b_mux fwd_b_mux(
    .read_data_2(idex_data_out.reg_read_data2),
    .ex_mem_out(exmem_data_out.ALU_result),
    .mem_wb_out(memtoreg_mux_out),

    .forward_b(fwd_b_sel),

    .alu_inp_2(ALU_inp_2)
    );


  /*  ALU alu(
    .A(ALU_inp_1),
    .B(ALU_inp_2),
    .control(ALU_control),
    .zero(zero), 
    .result(exmem_data_in.ALU_result)
    );

    forwarding_unit fwd_unit(
    .id_ex_rs1(idex_data_out.),
    input logic [4:0] id_ex_rs2,
    input logic [4:0] ex_mem_rd,
    input logic [4:0] mem_wb_rd,

    input logic ex_mem_reg_write,
    input logic mem_wb_reg_write,

    
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);*/





endmodule
