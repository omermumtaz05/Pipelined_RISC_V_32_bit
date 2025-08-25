module forward_b_mux(
    input logic [31:0] read_data_2,
    input logic [31:0] ex_mem_out,
    input logic [31:0] mem_wb_out,

    input logic [1:0] forward_b,

    output logic [31:0] alu_inp_2
);

    assign alu_inp_2 = (forward_b == 2'b00) ? read_data_2:
                       (forward_b == 2'b01) ? mem_wb_out:
                       (forward_b == 2'b10) ? ex_mem_out:
                       read_data_2;



endmodule
