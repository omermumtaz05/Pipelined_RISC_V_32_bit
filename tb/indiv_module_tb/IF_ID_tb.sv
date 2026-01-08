
import cpu_pkg::*;

module tb();
  
  logic clock;
  logic reset;
  
  if_id_data_t data_in;
  if_id_data_t data_out;
  
  IF_ID uut(
    .clock(clock),
    .reset(reset),
    .data_in(data_in),
    .data_out(data_out)
  );
  
  
   initial clock = 0;
  always #5 clock = ~clock;  // Toggle every 5 ns → 10 ns period = 100 MHz

  // Test sequence
  initial begin
    
    // Initialize inputs
    #10 clock = 0; reset = 1; data_in = '0; 
    
	#10;
    
    #10 reset = 0;
    
    #10 data_in.pc_address = 32'd42010; data_in.instruc = 32'd43210;
    
    
    #10 $display("pc address =%d, instruction = %d", data_out.pc_address, data_out.instruc);
    
    
    #10 reset = 1;
    
    
    #10 $display("pc address =%d, instruction = %d", data_out.pc_address, data_out.instruc);
    
    #10 $stop;
    
    
   
  end
  
  
  
  
endmodule
