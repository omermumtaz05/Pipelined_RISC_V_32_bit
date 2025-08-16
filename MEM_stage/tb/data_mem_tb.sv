module memory_tb();
  
  //Inputs declared as regs
  
  logic [31:0] address;
  logic [31:0] writeData;

  logic memRead;
  logic memWrite;
  
  logic reset;
  logic clk;

  //Outputs declared as wires
  
  logic [31:0] memData;
  
 data_memory uut(
    .address(address),
    .writeData(writeData),
    .memRead(memRead),
    .memWrite(memWrite),
    .reset(reset),
    .clk(clk),
    
    .memData(memData)
  );
  
	
  initial clk = 0;
  always #5 clk = ~clk;  // Toggle every 5 ns → 10 ns period = 100 MHz

  // Test sequence
  initial begin
    
    // Initialize inputs
	address = 0; writeData = 0; memRead = 0; memWrite = 0; 
    reset = 1; clk = 0; 
    
    #10 reset = 0;
    
    #10 writeData = 32'd200; address = 32'd3; memWrite = 1;
    	memRead = 0;
    
    	// store decimal 200 into address 2
    
    #10 memRead = 1; address = 32'd3;
    	//store decimal 10 into address 5
    
    #10 $display("memData=%d", memData);
    
    
    #10 writeData = 32'd10; address = 32'd5; memWrite = 1;
    	memRead = 0;
    
    #10 memRead = 1; address = 32'd5;
    	//store decimal 10 into register 5
    
    #10 $display("memData=%d", memData);
    
    #10 writeData = 20'b10110111001011011101; address = 32'd20; 
    	memWrite =  1;
    	memRead = 0;
    
    #10 memRead = 1; address = 32'd20;
    	//store decimal 10 into register 5
    
    #10 $display("memData=%d", memData);
    
        #10 writeData = 32'hFFFFFFFE; address = 32'd30; memWrite = 1;
    	memRead = 0;

    
    #10 memRead = 1; address = 32'd30;
	#1 $display("Read at 30 memData = %h", memData);
    $display("Bytes 30-33: %h %h %h %h", uut.data[30], uut.data[31], 			uut.data[32], uut.data[33]);

    #10 memRead = 1; address = 32'd33;
    #1 $display("Read at 33 memData = %h", memData);
    $display("Bytes 33-36: %h %h %h %h", uut.data[33], uut.data[34], 			uut.data[35], uut.data[36]);

    
    #10 $finish;
    
    
   
  end
endmodule
