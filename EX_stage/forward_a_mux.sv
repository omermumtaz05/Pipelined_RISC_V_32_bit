module forward_a_mux(
    input logic [4:0] id_ex_rs1,
    input logic [4:0] ex_mem_rd,
    input logic [4:0] mem_wb_rd,

    input logic [1:0] forward_a,

    output logic [4:0] alu_inp_1
);

    assign alu_inp_1 = (forward_a == 2'b00) ? id_ex_rs1:
                       (forward_a == 2'b01) ? mem_wb_rd:
                       (forward_a == 2'b10) ? ex_mem_rd:
                       id_ex_rs1;



endmodule
