module EX_MEM(
    //standard for all sequential
    input clock,
    input reset,
    
    // data to be stored
    input [31:0] branch_adder_sum_in,
    input [31:0] ALU_result_in,
    input [31:0] reg_read_data2_in,
    input [4:0] rd,

    //control signals for upcoming stages to be storeed

    // WB control signals
    input WB_reg_write_in,
    input WB_mem_to_reg_in,

    // M stage control signals 
    input M_branch_in,
    input M_mem_read_in,
    input M_mem_write_in,

    //ALU zero control
    input ALU_zero_in,


    //data being outputted
    output reg [31:0] branch_adder_sum_out,
    output reg [31:0] ALU_result_out,
    output reg [31:0] reg_read_data2_out,
    output reg [4:0] rd_out,

    //control signals to be outputted

    //WB control signals
    output reg WB_reg_write_out,
    output reg WB_mem_to_reg_out,

    //Mem stage control signals
    output reg M_branch_out,
    output reg M_mem_read_out,
    output reg M_mem_write_out,

    //ALU zero control out
    output reg ALU_zero_out

);


    always @ (posedge clock)
    if(reset){
        begin
            branch_adder_sum_out <= 32'b0;
            ALU_result_out <= 32'b0;
            reg_read_data2_out <= 32'b0
            rd_out <= 5'b0;
   
            WB_reg_write_out <= 1'b0;
            WB_mem_to_reg_out <= 1'b0;

            M_branch_out <= 1'b0;
            M_mem_read_out <= 1'b0;
            M_mem_write_out <= 1'b0;

            ALU_zero_out <= 1'b0;
        end
    }

    else {
        begin        
            branch_adder_sum_out <= branch_adder_sum_in;
            ALU_result_out <= ALU_result_in;
            reg_read_data2_out <= reg_read_data2_in;
            rd_out <= rd;
              
            WB_reg_write_out <= WB_reg_write_in
            WB_mem_to_reg_out <= WB_mem_to_reg_in;

            M_branch_out <= M_branch_in;
            M_mem_read_out <= M_mem_read_in;
            M_mem_write_out <= M_mem_write_in;

            ALU_zero_out <= ALU_zero_in;
        end
    }


endmodule


//Verify!!!

