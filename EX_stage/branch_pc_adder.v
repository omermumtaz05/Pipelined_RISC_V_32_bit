module branch_pc_adder(
    input [31:0] PC_address,
    input [31:0] imm,

    output [31:0] branch_address


);

    assign branch_address = PC_address + imm;


endmodule