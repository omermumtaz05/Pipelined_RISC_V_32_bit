import cpu_pkg::*;

module tb();
  
    logic clock;
    logic reset;
    
    ex_mem_data_t data_in;

    ex_mem_control_t control_in;

    ex_mem_data_t data_out;

    ex_mem_control_t control_out;
  
  
  EX_MEM uut(
    .clock(clock),
    .reset(reset),
    
    .data_in(data_in),
    .control_in(control_in),
    .data_out(data_out),
    .control_out(control_out)
    
    
  );
  
  
   initial clock = 0;
  always #5 clock = ~clock;  // Toggle every 5 ns → 10 ns period = 100 MHz

  // Test sequence
  initial begin
    
    // Initialize inputs
    clock = 0; reset = 1; 
    
    #10 reset = 0;
    
    #10 control_in.WB_reg_write = 1;
    	control_in.WB_mem_to_reg = 1;

     	control_in.M_branch = 1;
     	control_in.M_mem_read = 1;
    	control_in.M_mem_write = 1;
    
    	control_in.ALU_zero = 1;
  
    #10 $display("reg write = %d, mem to reg = %d, branch = %d, mem read = %d, mem write = %d, alu zero = %d", 
        control_out.WB_reg_write, control_out.WB_mem_to_reg, control_out.M_branch, control_out.M_mem_read, 
        control_out.M_mem_write, control_out.ALU_zero);
    
    
    #10 data_in.branch_adder_sum = 32'd1234;
    	data_in.ALU_result = 32'd12345;
    	data_in.reg_read_data2 = 32'd4321;
      data_in.rd = 5'd31;
    
    
    #10 $display("branch sum = %d, alu result = %d, read data 2 = %d,rd = %d", 
        data_out.branch_adder_sum, data_out.ALU_result, 
        data_out.reg_read_data2, data_out.rd);
    
     #10 reset = 1;
   
    #10 $display("reg write = %d, mem to reg = %d, branch = %d, mem read = %d, mem write = %d, alu zero = %d", 
        control_out.WB_reg_write, control_out.WB_mem_to_reg, control_out.M_branch, control_out.M_mem_read, 
        control_out.M_mem_write, control_out.ALU_zero);

        $display("branch sum = %d, alu result = %d, read data 2 = %d,rd = %d", 
        data_out.branch_adder_sum, data_out.ALU_result, 
        data_out.reg_read_data2, data_out.rd);

    #10 $stop;
    
    
   
  end
  
  
  
  
endmodule
