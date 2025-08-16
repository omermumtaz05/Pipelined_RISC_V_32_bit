module PC_source_mux(
    input [31:0] branch_address,
    input [31:0] increment_address,
    input PCSrc,

    output [31:0] PC_input

);

    assign PC_input = ~PCSrc ? increment_address : branch_address;
       

endmodule

//needs to be verif
