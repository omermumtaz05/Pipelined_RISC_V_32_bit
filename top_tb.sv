
module top_tb();

logic clock;
logic reset;


top_module uut(
	.clock(clock),
	.reset(reset)
);



  initial clock = 1;
  always #5 clock = ~clock;  // Toggle every 5 ns ? 10 ns period = 100 MHz

  // Test sequence
  initial begin
    
    // Initialize inputs
    reset = 1; 
    
    #10 reset = 0;
    
    #10
    
    
    #10 
    
    
    #10 
    
    
    #10 
    #10 
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
	#10
#10
	#10
	#10
	#10
	#10
#10
	#10
	#10
	#10
	#10
#10
	#10
	#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
#10
    #10 $stop;
    
    
   
  end

endmodule
