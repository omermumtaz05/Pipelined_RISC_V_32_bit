module pc_inc_adder(
    input logic [31:0] PC_out,
    output logic [31:0] inc_pc
);

    assign inc_pc = PC_out + 32'd4;

endmodule
