module branch_pc_adder(
    input logic [31:0] PC_address,
    input logic [31:0] imm,

    output logic [31:0] branch_address


);

    assign branch_address = PC_address + imm;


endmodule
