module MEM_WB(
    // standard sequential
    input clock,
    input reset,

    //datapath inputs
    input [31:0] read_data_in,
    input [31:0] ALU_result_in,
    input [4:0] rd_in,

    //control signal inputs
    input WB_reg_write_in,
    input WB_mem_to_reg_in,

    //datapath outputs
    output reg [31:0] read_data_out,
    output reg [31:0] ALU_result_out,
    output reg [4:0] rd_out,

    //control signal inputs
    output reg WB_reg_write_out,
    output reg WB_mem_to_reg_out,
);

    always @ (posedge clock)
    if(reset){
        begin
            read_data_out <= 32'b0;
            ALU_result_out <= 32'b0;
            rd_out <= 5'b0;

            WB_reg_write_out <= 1'b0;
            WB_mem_to_reg_out <= 1'b0;
        end
    }
    else {
        begin
            read_data_out <= read_data_in;
            ALU_result_out <= ALU_result_in;
            rd_out <= rd_in;

            WB_reg_write_out <= WB_reg_write_in;
            WB_mem_to_reg_out <= WB_mem_to_reg_in;
        end
    }

endmodule