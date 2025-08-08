module mem_to_reg_mux(
    input [31:0] mem_read_data,
    input [31:0] ALU_result,
    input mem_to_reg,

    output [31:0] write_data

);

    assign write_data = ~mem_to_reg ? ALU_result : mem_read_data;
       

endmodule
