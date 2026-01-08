import cpu_pkg::*;

module tb();
  
    logic clock;
    logic reset;
    
    mem_wb_data_t data_in;

    mem_wb_control_t control_in;

    mem_wb_data_t data_out;

    mem_wb_control_t control_out;

  
  
  MEM_WB uut(

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
    
  
    #10 $display("reg write = %d, mem to reg = %d", control_out.WB_reg_write, control_out.WB_mem_to_reg);
    
    
    #10 data_in.read_data = 32'd1234;
    	data_in.ALU_result = 32'd12345;
        data_in.rd = 5'd31;
    
    
    #10 $display("read data from mem = %d, alu result = %d, read data 2 = %d", data_out.read_data, data_out.ALU_result, data_out.rd);
    
    #10 reset = 1;
   
    #10 $display("reg write = %d, mem to reg = %d", control_out.WB_reg_write, control_out.WB_mem_to_reg);
    
      $display("read data from mem = %d, alu result = %d, read data 2 = %d", data_out.read_data, data_out.ALU_result, data_out.rd);
    
    #10 $stop; 
    
   
  end

  
endmodule
