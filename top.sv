
import cpu_pkg::*;

module top_module(
    input logic clock, 
    input logic reset
    );

    // pc and if/id control
    logic PCWrite, if_id_write;

  //  assign PCWrite = 1'b1; // testing for no hazard or forward detec
  //  assign if_id_write = 1'b1; // testing for no hazard or forward detec

    // mux control signals
    logic PCSrc, control_mux;
    
    //pipeline register values

    //ifid
    if_id_data_t ifid_data_in, ifid_data_out;

    //idex
    id_ex_data_t idex_data_in, idex_data_out;
    id_ex_control_t idex_control_in, idex_control_out, ctrl_unit_out;

    //exmem
    ex_mem_data_t exmem_data_in, exmem_data_out;
    ex_mem_control_t exmem_control_in, exmem_control_out;

    //memwb
    mem_wb_data_t memwb_data_in, memwb_data_out;
    mem_wb_control_t memwb_control_in, memwb_control_out;

    // fwd sels
    logic [1:0] fwd_a_sel, fwd_b_sel;

    //alu inps
    logic [31:0] ALU_inp_1, ALU_inp_2;
    logic [31:0] fwd_b_out;

    //alu ctrl and zero
    logic [3:0] ALU_control;
    logic zero;

    logic [31:0] inc_addrs, branch_addrs, PC_in, PC_out;
    logic [31:0] memtoreg_mux_out;
    logic [31:0] imm;

    logic [4:0] if_id_rs1, if_id_rs2;
    

    // IF stage:
    PC_source_mux pc_mux(.branch_address(branch_addrs), .increment_address(inc_addrs),
                            .PCSrc(PCSrc), .PC_input(PC_in));


    ProgramCounter pc_reg(.clk(clock), .reset(reset),
                        .PCWrite(PCWrite), .next_pc(PC_in),
                          .pc_out(PC_out));

    pc_inc_adder pc_inc(.PC_out(PC_out), .inc_pc(inc_addrs));

    instruction_memory IM(.clock(clock), .address(PC_out), .read_instr(ifid_data_in.instruc));
    assign ifid_data_in.pc_address = PC_out;

    IF_ID if_id(.clock(clock), .reset(reset), .if_id_write(if_id_write),
                .data_in(ifid_data_in), .data_out(ifid_data_out));

    // ID stage:

    register RF(.clk(clock), .reset(reset),
                .readReg1(ifid_data_out.instruc[19:15]), .readReg2(ifid_data_out.instruc[24:20]),
                .writeReg(memwb_data_out.rd), .writeData(memtoreg_mux_out),
                .regWrite(memwb_control_out.WB_reg_write), .readData1(idex_data_in.reg_read_data1), .readData2(idex_data_in.reg_read_data2));

    assign if_id_rs1 = ifid_data_out.instruc[19:15];
    assign if_id_rs2 = ifid_data_out.instruc[24:20];

    hazard_detection hzd_dtc_unit(
    .id_ex_mem_read(idex_control_out.M_mem_read),
    .id_ex_rd(idex_data_out.rd),
    .if_id_rs1(if_id_rs1),
    .if_id_rs2(if_id_rs2),


    .PCWrite(PCWrite),
    .if_id_write(if_id_write),
    .control_mux_sig(control_mux)
    );


    imm_gen imm_gen(.inst(ifid_data_out.instruc), .imm(idex_data_in.imm));

    control control_unit(.instruc(ifid_data_out.instruc), .all_ctrl_out(ctrl_unit_out));

    control_mux ctrl_mux(
    .all_control_in(ctrl_unit_out),

    .stall(control_mux),

    .ctrl_mux_out(idex_control_in)

);
    assign idex_data_in.pc_address = ifid_data_out.pc_address;

    assign idex_data_in.funct_inst_bits = {ifid_data_out.instruc[30], ifid_data_out.instruc[14:12]};
    assign idex_data_in.rd = ifid_data_out.instruc[11:7];

    assign idex_data_in.rs1 = ifid_data_out.instruc[19:15];
    assign idex_data_in.rs2 = ifid_data_out.instruc[24:20];

    ID_EX idex_reg(.clock(clock), .reset(reset), .data_in(idex_data_in), .control_in(idex_control_in),
                    .data_out(idex_data_out), .control_out(idex_control_out));


    //EX stage


    ALU alu(
    .A(ALU_inp_1),
    .B(ALU_inp_2),
    .control(ALU_control),
    .zero(exmem_control_in.ALU_zero), 
    .result(exmem_data_in.ALU_result)
    );


    ALUControl alu_ctrl(

    .funct7_bit_6(idex_data_out.funct_inst_bits[3]),
    .funct3(idex_data_out.funct_inst_bits[2:0]),
    .ALUOp(idex_control_out.EX_ALU_Op),

    .control(ALU_control)
    );


    ALU_source_mux alu_src_mux(
    .read_data_2(fwd_b_out),
    .imm(idex_data_out.imm),
    .ALUSrc(idex_control_out.EX_ALU_Src),

    .ALU_inp2(ALU_inp_2)
    );


    branch_pc_adder branch_addr(
    .PC_address(idex_data_out.pc_address),
    .imm(idex_data_out.imm),

    .branch_address(exmem_data_in.branch_adder_sum)
    );

    forwarding_unit fwd_unit(
    .id_ex_rs1(idex_data_out.rs1),
    .id_ex_rs2(idex_data_out.rs2),
    .ex_mem_rd(exmem_data_out.rd),
    .mem_wb_rd(memwb_data_out.rd),

    .ex_mem_reg_write(exmem_control_out.WB_reg_write),
    .mem_wb_reg_write(memwb_control_out.WB_reg_write),
    
    .forward_a(fwd_a_sel),
    .forward_b(fwd_b_sel)
    );

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

    .alu_inp_2(fwd_b_out)
);

    assign exmem_data_in.reg_read_data2 = idex_data_out.reg_read_data2;
    assign exmem_data_in.rd = idex_data_out.rd;

    assign exmem_control_in.WB_reg_write = idex_control_out.WB_reg_write;
    assign exmem_control_in.WB_mem_to_reg = idex_control_out.WB_mem_to_reg;

    assign exmem_control_in.M_branch = idex_control_out.M_branch;
    assign exmem_control_in.M_mem_read = idex_control_out.M_mem_read;
    assign exmem_control_in.M_mem_write = idex_control_out.M_mem_write;

    EX_MEM exmem_reg(
    .clock(clock),
    .reset(reset),

    .data_in(exmem_data_in),
    .control_in(exmem_control_in),

    .data_out(exmem_data_out),
    .control_out(exmem_control_out)
    );


    //MEM stage

    data_memory DM(
    .clk(clock),
    .reset(reset),
    .address(exmem_data_out.ALU_result),
    .writeData(exmem_data_out.reg_read_data2),
    .memRead(exmem_control_out.M_mem_read),
    .memWrite(exmem_control_out.M_mem_write),
    .memData(memwb_data_in.read_data)
    );

    assign PCSrc = exmem_control_out.M_branch & exmem_control_out.ALU_zero;

    assign memwb_data_in.ALU_result = exmem_data_out.ALU_result;
    assign memwb_data_in.rd = exmem_data_out.rd;

    assign memwb_control_in.WB_reg_write = exmem_control_out.WB_reg_write;
    assign memwb_control_in.WB_mem_to_reg = exmem_control_out.WB_mem_to_reg;

    MEM_WB memwb_reg(
    .clock(clock),
    .reset(reset),

    .data_in(memwb_data_in),
    .control_in(memwb_control_in),

    .data_out(memwb_data_out),
    .control_out(memwb_control_out)
    );

    mem_to_reg_mux mem_reg_mux(
    .mem_read_data(memwb_data_out.read_data),
    .ALU_result(memwb_data_out.ALU_result),
    .mem_to_reg(memwb_control_out.WB_mem_to_reg),

    .write_data(memtoreg_mux_out)
    );



endmodule
