
package cpu_pkg;

//if id data
typedef struct packed {
    // Data to be stored
    reg [31:0] pc_address;
    reg [31:0] instruc;
    
} if_id_data_t;

// id ex control and data

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

} id_ex_control_t;

typedef struct packed {
    // Data to be stored
    reg [31:0] pc_address;
    reg [31:0] reg_read_data1;
    reg [31:0] reg_read_data2;

    reg [31:0] imm;
    reg [3:0] funct_inst_bits;
    reg [4:0] rd;

    reg [4:0] rs1;
    reg [4:0] rs2;

} id_ex_data_t;

//ex mem control and data
typedef struct packed {
    
    reg WB_reg_write;
    reg WB_mem_to_reg;

    
    reg M_branch;
    reg M_mem_read;
    reg M_mem_write;

    reg ALU_zero;

} ex_mem_control_t;

typedef struct packed {
    
    reg [31:0] branch_adder_sum;
    reg [31:0] ALU_result;
    reg [31:0] reg_read_data2;
    reg [4:0] rd;

} ex_mem_data_t;

//mem wb control and data
typedef struct packed {
    
    reg WB_reg_write;
    reg WB_mem_to_reg;

} mem_wb_control_t;

typedef struct packed {
    
    reg [31:0] read_data;
    reg [31:0] ALU_result;
    reg [4:0] rd;

} mem_wb_data_t;


endpackage
