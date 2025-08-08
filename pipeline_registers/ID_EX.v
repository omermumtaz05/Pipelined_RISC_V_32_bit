module ID_EX(
    //standard for all sequential
    input clock,
    input reset,
    
    // data to be stored
    input [31:0] ifid_pc_address,
    input [31:0] reg_read_data1,
    input [31:0] reg_read_data2,

    input [31:0] imm,
    input [3:0] funct_inst_bits,
    input [4:0] rd,

    //control signals for upcoming stages to be storeed

    //WB stage control
    input WB_reg_write,
    input WB_mem_to_reg,

    //Mem stage contorl signals
    input M_branch,
    input M_mem_read,
    input M_mem_write,

    // EX stage control signals
    input [1:0] EX_ALU_Op,
    input EX_ALU_Src,


    //data being outputted
    output reg [31:0] out_ifid_pc_address,
    output reg [31:0] out_reg_read_data1,
    output reg [31:0] out_reg_read_data2,

    output reg [31:0] out_imm,
    output reg [3:0] out_funct_inst_bits,
    output reg [4:0] out_rd.

    //control signals to be outputted
    
    //WB stage control output
    output reg WB_reg_write_out,
    output reg WB_mem_to_reg_out,

    //MEM stage controls
    output reg M_branch_out,
    output reg M_mem_read_out,
    output reg M_mem_write_out,

    //EX stage controls
    output reg [1:0] EX_ALU_Op_out,
    output reg EX_ALU_Src_out,
);


    always @ (posedge clock)
    if(reset){
        begin
            out_ifid_pc_address <= 32'b0;
            out_reg_read_data1 <= 32'b0;
            out_reg_read_data2 <= 32'b0;

            out_imm <= 32'b0;
            out_funct_inst_bits <= 4'b0;
            out_rd <= 5'b0;
            
            // All 7 control signals
            WB_reg_write_out <= 1'b0;
            WB_mem_to_reg_out <= 1'b0;

            M_branch_out <= 1'b0;
            M_mem_read_out <= 1'b0;
            M_mem_write_out <= 1'b0

            EX_ALU_Op_out <= 2'b0;
            EX_ALU_Src_out <= 1'b0;
        end
    }

    else {
        begin        
            out_ifid_pc_address <= ifid_pc_address;
            out_reg_read_data1 <= reg_read_data1;
            out_reg_read_data2 <= reg_read_data2;

            out_imm <= imm;
            out_funct_inst_bits <= funct_inst_bits;
            out_rd <= rd;
            
            // All 7 control signals

            WB_reg_write_out <= WB_reg_write;
            WB_mem_to_reg_out <= WB_mem_to_reg;

            M_branch_out <= M_branch;
            M_mem_read_out <= M_mem_read;
            M_mem_write_out <= M_mem_write;

            EX_ALU_Op_out <= EX_ALU_Op;
            EX_ALU_Src_out <= EX_ALU_Src;
        end
    }


endmodule




//VERIFY