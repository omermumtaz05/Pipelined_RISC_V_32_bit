module register_tb();
  
  //Inputs declared as regs
  
  reg [4:0] readReg1;
  reg [4:0] readReg2;
  reg [4:0] writeReg;
  reg [31:0] writeData;
  reg reset;
  reg regWrite;
  reg clk;
 
  //Outputs declared as wires
  
  wire [31:0] readData1;
  wire [31:0] readData2;
  
  register uut(
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg),
    .writeData(writeData),
    .reset(reset),
    .regWrite(regWrite),
    .clk(clk),
    .readData1(readData1),
    .readData2(readData2)
  );
  
	
  initial clk = 0;
  always #5 clk = ~clk;  // Toggle every 5 ns → 10 ns period = 100 MHz

  // Test sequence
  initial begin
    // Initialize inputs
    readReg1 = 0; readReg2 = 0; writeReg = 0; writeData = 0; 
    reset = 1; regWrite = 0;
    
    
    #10 reset = 0;
    
    #10 writeData = 32'd200; writeReg = 5'd2; regWrite = 1;
    	// store decimal 200 into register 2
    
    #10 writeData = 32'd10; writeReg = 5'd5; regWrite = 1;
    	//store decimal 10 into register 5
    
    #10 regWrite = 0; readReg1 = 5'd2; readReg2 = 5'd5;
    
    #10
    
    $display("readData1=%d readData2=%d ", readData1, readData2);
    
    #10 reset = 1;
    
    #10 regWrite = 0; readReg1 = 5'd2; readReg2 = 5'd5;
    
    #10 $display("readData1=%d readData2=%d ", readData1, readData2);
    
    #10 $finish;
    
    
   
  end
endmodule
