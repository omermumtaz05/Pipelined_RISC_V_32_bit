module PC_source_mux(
    input [31:0] read_data_2,
    input [31:0] imm,
    input ALUSrc,

    output [31:0] ALU_inp2

);

    assign ALU_inp2 = ~ALUSrc ? read_data_2 : imm;
       

endmodule