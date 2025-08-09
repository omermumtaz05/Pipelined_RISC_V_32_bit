// Code your testbench here
// or browse Examples
module tb();
  
    reg clock;
    reg reset;
    
    // data to be stored
  	reg [31:0] ifid_pc_address;
    reg [31:0] reg_read_data1;
    reg [31:0] reg_read_data2;

    reg [31:0] imm;
    reg [3:0] funct_inst_bits;
    reg [4:0] rd;

    //control signals for upcoming stages to be storeed

    //WB stage control
    reg WB_reg_write;
    reg WB_mem_to_reg;

    //Mem stage contorl signals
    reg M_branch;
    reg M_mem_read;
    reg M_mem_write;

    // EX stage control signals
  reg [1:0] EX_ALU_Op;
    reg EX_ALU_Src;


    //data being outputted
  wire [31:0] out_ifid_pc_address;
  wire [31:0] out_reg_read_data1;
  wire [31:0] out_reg_read_data2;

  wire [31:0] out_imm;
  wire [3:0] out_funct_inst_bits;
  wire [4:0] out_rd;

    //control signals to be outputted
    
    //WB stage control output
    wire WB_reg_write_out;
    wire WB_mem_to_reg_out;

    //MEM stage controls
    wire M_branch_out;
    wire M_mem_read_out;
    wire M_mem_write_out;

    //EX stage controls
  wire [1:0] EX_ALU_Op_out;
    wire EX_ALU_Src_out;
  
  
  ID_EX uut(
    .clock(clock),
    .reset(reset),
    
    .ifid_pc_address(ifid_pc_address),
    .reg_read_data1(reg_read_data1),
    .reg_read_data2(reg_read_data2),
    .imm(imm),
    .funct_inst_bits(funct_inst_bits),
    .rd(rd),
    
    .WB_reg_write(WB_reg_write),
    .WB_mem_to_reg(WB_mem_to_reg),
    
    .M_branch(M_branch),
    .M_mem_read(M_mem_read),
    .M_mem_write(M_mem_write),
    
    .EX_ALU_Op(EX_ALU_Op),
    .EX_ALU_Src(EX_ALU_Src),
    
    
    .out_ifid_pc_address(out_ifid_pc_address),
    .out_reg_read_data1(out_reg_read_data1),
    .out_reg_read_data2(out_reg_read_data2),
    .out_imm(out_imm),
    .out_funct_inst_bits(out_funct_inst_bits),
    .out_rd(out_rd),
    
    .WB_reg_write_out(WB_reg_write_out),
    .WB_mem_to_reg_out(WB_mem_to_reg_out),
    
    .M_branch_out(M_branch_out),
    .M_mem_read_out(M_mem_read_out),
    .M_mem_write_out(M_mem_write_out),
    
    .EX_ALU_Op_out(EX_ALU_Op_out),
    .EX_ALU_Src_out(EX_ALU_Src_out)
    
    
    
  );
  
  
   initial clock = 0;
  always #5 clock = ~clock;  // Toggle every 5 ns → 10 ns period = 100 MHz

  // Test sequence
  initial begin
    
    // Initialize inputs
    clock = 0; reset = 1; 
    
    #10 reset = 0;
    
    #10 WB_reg_write = 1;
   		 WB_mem_to_reg = 1;

     	M_branch = 1;
     	M_mem_read = 1;
    	 M_mem_write = 1;
    
    	 EX_ALU_Op = 2'b10;
    	 EX_ALU_Src = 1;
  
  	#10 $display("reg write = %d, mem to reg = %d, branch = %d, mem read = %d, mem write = %d, alu op = %d, alu src = %d", WB_reg_write_out, WB_mem_to_reg_out, M_branch_out, M_mem_read_out, M_mem_write_out, EX_ALU_Op_out, EX_ALU_Src_out);
    
    
    #10 ifid_pc_address = 32'd1234;
    	reg_read_data1 = 32'd1234;
    	reg_read_data2 = 32'd4321;

      	imm = 32'd1234;
        funct_inst_bits = 4'd15;
        rd = 5'd31;
    
    
    #10 $display("pc address = %d, read data 1 = %d, read data 2 = %d, immediate = %d, funct bits = %d, rd = %d", out_ifid_pc_address, out_reg_read_data1, out_reg_read_data2, out_imm, out_funct_inst_bits, out_rd);
    
      #10 reset = 1;
   
    #10 $display("reg write = %d, mem to reg = %d, branch = %d, mem read = %d, mem write = %d, alu op = %d, alu src = %d", WB_reg_write_out, WB_mem_to_reg_out, M_branch_out, M_mem_read_out, M_mem_write_out, EX_ALU_Op_out, EX_ALU_Src_out);
    
    
     #10 $display("pc address = %d, read data 1 = %d, read data 2 = %d, immediate = %d, funct bits = %d, rd = %d", out_ifid_pc_address, out_reg_read_data1, out_reg_read_data2, out_imm, out_funct_inst_bits, out_rd);
    
    #10 $finish;
    
    
   
  end
  
  
  
  
endmodule
