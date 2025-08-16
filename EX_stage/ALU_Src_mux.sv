module ALU_source_mux(
    input logic [31:0] read_data_2,
    input logic [31:0] imm,
    input logic ALUSrc,

    output logic [31:0] ALU_inp2

);

    assign ALU_inp2 = ~ALUSrc ? read_data_2 : imm;
       

endmodule
