// Code your testbench here
// or browse Examples
module tb();
  
    reg clock;
    reg reset;
    
    // data to be stored
  	reg [31:0] branch_adder_sum_in;
  	reg [31:0] ALU_result_in;
  	reg [31:0] reg_read_data2_in;
    reg [4:0] rd;

    //control signals for upcoming stages to be storeed

    //WB stage control
    reg WB_reg_write;
    reg WB_mem_to_reg;

    //Mem stage contorl signals
    reg M_branch;
    reg M_mem_read;
    reg M_mem_write;

    // ALU
    reg ALU_zero_in;


    //data being outputted
    wire [31:0] branch_adder_sum_out;
    wire [31:0] ALU_result_out;
    wire [31:0] reg_read_data2_out;
    wire [4:0] rd_out;

    //control signals to be outputted
    
    //WB stage control output
    wire WB_reg_write_out;
    wire WB_mem_to_reg_out;

    //MEM stage controls
    wire M_branch_out;
    wire M_mem_read_out;
    wire M_mem_write_out;
	
  //alu zero output
    wire ALU_zero_out;
  
  
  EX_MEM uut(
    .clock(clock),
    .reset(reset),
    
    .branch_adder_sum_in(branch_adder_sum_in),
    .ALU_result_in(ALU_result_in),
    .reg_read_data2_in(reg_read_data2_in),
    .rd(rd),
    
    .WB_reg_write_in(WB_reg_write),
    .WB_mem_to_reg_in(WB_mem_to_reg),
    
    .M_branch_in(M_branch),
    .M_mem_read_in(M_mem_read),
    .M_mem_write_in(M_mem_write),
    
    .ALU_zero_in(ALU_zero_in),
    
    
    .branch_adder_sum_out(branch_adder_sum_out),
    .ALU_result_out(ALU_result_out),
    .reg_read_data2_out(reg_read_data2_out),
    .rd_out(rd_out),
    
    .WB_reg_write_out(WB_reg_write_out),
    .WB_mem_to_reg_out(WB_mem_to_reg_out),
    
    .M_branch_out(M_branch_out),
    .M_mem_read_out(M_mem_read_out),
    .M_mem_write_out(M_mem_write_out),
    
    .ALU_zero_out(ALU_zero_out)
    
    
    
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
    
    	 ALU_zero_in = 1;
  
    #10 $display("reg write = %d, mem to reg = %d, branch = %d, mem read = %d, mem write = %d, alu zero = %d", WB_reg_write_out, WB_mem_to_reg_out, M_branch_out, M_mem_read_out, M_mem_write_out, ALU_zero_out);
    
    
    #10 branch_adder_sum_in = 32'd1234;
    	ALU_result_in = 32'd12345;
    	reg_read_data2_in = 32'd4321;
        rd = 5'd31;
    
    
    #10 $display("branch sum = %d, alu result = %d, read data 2 = %d,rd = %d", branch_adder_sum_out, ALU_result_out, reg_read_data2_out, rd_out);
    
     #10 reset = 1;
   
    #10 $display("reg write = %d, mem to reg = %d, branch = %d, mem read = %d, mem write = %d, alu zero = %d", WB_reg_write_out, WB_mem_to_reg_out, M_branch_out, M_mem_read_out, M_mem_write_out, ALU_zero_out);
    
     #10 $display("branch sum = %d, alu result = %d, read data 2 = %d,rd = %d", branch_adder_sum_out, ALU_result_out, reg_read_data2_out, rd_out);
    
    #10 $finish;
    
    
   
  end
  
  
  
  
endmodule
