module mem_to_reg_mux(
    input logic [31:0] mem_read_data,
    input logic [31:0] ALU_result,
    input logic mem_to_reg,

    output logic [31:0] write_data

);

    assign write_data = ~mem_to_reg ? ALU_result : mem_read_data;
       

endmodule
