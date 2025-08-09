// Code your testbench here
// or browse Examples
module tb();
  
  reg clock;
  reg reset;
  reg [31:0] input_pc_address;
  reg [31:0] input_instruc;
  
  
  wire [31:0] output_pc_address;
  wire [31:0] output_instruc;
  
  
  IF_ID uut(
    .clock(clock),
    .reset(reset),
    .input_pc_address(input_pc_address),
    .input_instruc(input_instruc),
    .out_pc_address(output_pc_address),
    .output_instruc(output_instruc)
  );
  
  
   initial clock = 0;
  always #5 clock = ~clock;  // Toggle every 5 ns → 10 ns period = 100 MHz

  // Test sequence
  initial begin
    
    // Initialize inputs
    input_pc_address = 32'b0; input_instruc = 32'b0; clock = 0; reset = 1; 
    
    #10 reset = 0;
    
    #10 input_pc_address = 32'b010111; input_instruc = 32'b010101;
    
    
    #10 $display("pc address =%d, instruction = %d", output_pc_address, output_instruc);
    
    
    #10 reset = 1;
    
    
    #10 $display("pc address =%d, instruction = %d", output_pc_address, output_instruc);
    
    #10 $finish;
    
    
   
  end
  
  
  
  
endmodule
