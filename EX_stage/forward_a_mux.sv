module forward_a_mux(
    input logic [31:0] read_data_1,
    input logic [31:0] ex_mem_out,
    input logic [31:0] mem_wb_out,

    input logic [1:0] forward_a,

    output logic [31:0] alu_inp_1
);

    assign alu_inp_1 = (forward_a == 2'b00) ? read_data_1:
                       (forward_a == 2'b01) ? mem_wb_out:
                       (forward_a == 2'b10) ? ex_mem_out:
                       read_data_1;



endmodule
