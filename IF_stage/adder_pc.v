module pc_inc_adder(
    input [31:0] PC_out,
    output [31:0] inc_pc
);

    assign inc_pc = PC_out + 32'd4;

endmodule