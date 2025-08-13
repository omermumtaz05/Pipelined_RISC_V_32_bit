package cpu_pkg;

typedef struct packed {
    // WB stage control
    reg WB_reg_write;
    reg WB_mem_to_reg;

    // Mem stage control signals
    reg M_branch;
    reg M_mem_read;
    reg M_mem_write;

    // EX stage control signals
    reg [1:0] EX_ALU_Op;
    reg EX_ALU_Src;
} pipeline_control_t_id_ex;

typedef struct packed {
    // Data to be stored
    reg [31:0] pc_address;
    reg [31:0] reg_read_data1;
    reg [31:0] reg_read_data2;

    reg [31:0] imm;
    reg [3:0] funct_inst_bits;
    reg [4:0] rd;
} pipeline_data_t_id_ex;

endpackage
