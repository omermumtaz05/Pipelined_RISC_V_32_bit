// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
module tb();
  
  //inputs
  logic clock;
  logic reset;
  
  logic PCWrite;
  logic [31:0] next_pc;

  
  //output
  logic [31:0] pc_out;
  
  
  ProgramCounter uut(.clk(clock),
                         .reset(reset),
                         
                         .PCWrite(PCWrite),
                         .next_pc(next_pc),
                     
                         .pc_out(pc_out));
  
  initial clock = 0;
  always #5 clock = ~clock;  // Toggle every 5 ns → 10 ns period = 100 MHz

  
  initial begin
    
    #10
    clock = 0; 
    reset = 1; 
    next_pc = '0; PCWrite = 0;
    
    #10;
    
    #10 reset = 0;
     
    #10 PCWrite = 1; next_pc = 32'd125;
    
    #10 $display("PC value is: %d", pc_out);
    
    #10 PCWrite = 0; next_pc = 'd12345;
    
    #10 $display("PC value is: %d", pc_out);
    
    #10 reset = 1;
    
    #10 $display("PC value is: %d", pc_out);
    
    

    #10 $finish;
    
    
    
  end
  
                
             
  
  
  
  
endmodule
