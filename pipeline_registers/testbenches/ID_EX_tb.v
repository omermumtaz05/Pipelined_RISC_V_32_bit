// Code your testbench here
// or browse Examples

import cpu_pkg::*;

module tb();
  
    logic clock;
    logic reset;
    
    id_ex_data_t data_in;

    id_ex_control_t control_in;

    id_ex_data_t data_out;

    id_ex_control_t control_out;

  
  
  ID_EX uut(
    //standard for all sequential
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
    clock = 0; reset = 1; data_in = '0; control_in = '0;
    
    #10 reset = 0;
    
    #10 control_in.WB_reg_write = 1;
   		  control_in.WB_mem_to_reg = 1;

     	  control_in.M_branch = 1;
     	  control_in.M_mem_read = 1;
    	  control_in.M_mem_write = 1;
    
    	  control_in.EX_ALU_Op = 2'b10;
    	  control_in.EX_ALU_Src = 1;
  
  
 	data_in.pc_address = 32'd1234;
    	data_in.reg_read_data1 = 32'd12345;
    	data_in.reg_read_data2 = 32'd4321;

      	data_in.imm = 32'd123456;
        data_in.funct_inst_bits = 4'd15;
        data_in.rd = 5'd31;

	#10 $display("reg write = %b, mem to reg = %b, branch = %b, mem read = %b, mem write = %b, alu op = %b, alu src = %b", 
    control_out.WB_reg_write, control_out.WB_mem_to_reg, control_out.M_branch, control_out.M_mem_read, control_out.M_mem_write, 
    control_out.EX_ALU_Op, control_out.EX_ALU_Src);
    
    
    #10 $display("pc address = %d, read data 1 = %d, read data 2 = %d, immediate = %d, funct bits = %d, rd = %d", 
        data_out.pc_address, data_out.reg_read_data1, data_out.reg_read_data2, data_out.imm, data_out.funct_inst_bits, data_out.rd);
    
      #10 reset = 1;
   
    #10 $display("reg write = %b, mem to reg = %b, branch = %b, mem read = %b, mem write = %b, alu op = %b, alu src = %b", 
    control_out.WB_reg_write, control_out.WB_mem_to_reg, control_out.M_branch, control_out.M_mem_read, control_out.M_mem_write, 
    control_out.EX_ALU_Op, control_out.EX_ALU_Src);
    
     #10 $display("pc address = %d, read data 1 = %d, read data 2 = %d, immediate = %d, funct bits = %d, rd = %d", 
      data_out.pc_address, data_out.reg_read_data1, data_out.reg_read_data2, data_out.imm, data_out.funct_inst_bits, data_out.rd);
    
    #10 $stop;
    
    
   
  end
  
  
  
endmodule
