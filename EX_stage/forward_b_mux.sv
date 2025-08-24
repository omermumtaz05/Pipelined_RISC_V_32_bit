module forward_b_mux(
    input logic [4:0] id_ex_rs2,
    input logic [4:0] ex_mem_rd,
    input logic [4:0] mem_wb_rd,

    input logic [1:0] forward_b,

    output logic [4:0] alu_inp_2
);


assign alu_inp_2 = (forward_b == 2'b00) ? id_ex_rs2:
                       (forward_b == 2'b01) ? mem_wb_rd:
                       (forward_b == 2'b10) ? ex_mem_rd:
                       id_ex_rs2;



endmodule
