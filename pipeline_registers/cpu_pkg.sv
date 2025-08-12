package cpu_pkg;


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

} pipeline_control_t_if_id;

typedef struct packed{
     // data to be stored
    logic [31:0] pc_address,
    logic [31:0] reg_read_data1,
    logic [31:0] reg_read_data2,

    logic [31:0] imm,
    logic [3:0] funct_inst_bits,
    logic [4:0] rd,

} pipeline_data_t_if_id;






    
endpackage cpu_pkg;

