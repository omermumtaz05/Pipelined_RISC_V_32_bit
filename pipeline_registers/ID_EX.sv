typedef struct packed{
    //WB stage control
    logic WB_reg_write,
    logic WB_mem_to_reg,

    //Mem stage contorl signals
    logic M_branch,
    logic M_mem_read,
    logic M_mem_write,

    // EX stage control signals
    logic [1:0] EX_ALU_Op,
    logic EX_ALU_Src,

} pipeline_control_t;


module ID_EX(
    //standard for all sequential
    input logic clock,
    input logic reset,
    
    // data to be stored
    input logic [31:0] ifid_pc_address,
    input logic [31:0] reg_read_data1,
    input logic [31:0] reg_read_data2,

    input logic [31:0] imm,
    input logic [3:0] funct_inst_bits,
    input logic [4:0] rd,

    //control signals for upcoming stages to be storeed

    //WB stage control
    input pipeline_control_t control_in,


    //data being outputted
    output logic [31:0] out_ifid_pc_address,
    output logic [31:0] out_reg_read_data1,
    output logic [31:0] out_reg_read_data2,

    output logic [31:0] out_imm,
    output logic [3:0] out_funct_inst_bits,
  	output logic [4:0] out_rd,

    //control signals to be outputted
    
    //WB stage control output
    output pipeline_control_t control_out
);


    always_ff @ (posedge clock)
    if(reset)
        begin
            out_ifid_pc_address <= '0;
            out_reg_read_data1 <= '0;
            out_reg_read_data2 <= '0;

            out_imm <= '0;
            out_funct_inst_bits <= '0;
            out_rd <= '0;
            
            // All 7 control signals
            control_out <= '0;
        end

    else 
        begin        
            out_ifid_pc_address <= ifid_pc_address;
            out_reg_read_data1 <= reg_read_data1;
            out_reg_read_data2 <= reg_read_data2;

            out_imm <= imm;
            out_funct_inst_bits <= funct_inst_bits;
            out_rd <= rd;
            
            // All 7 control signals

           control_out <= control_in;
        end


endmodule
