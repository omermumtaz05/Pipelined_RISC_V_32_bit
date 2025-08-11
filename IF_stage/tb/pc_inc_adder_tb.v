// Code your testbench here
// or browse Examples
module tb();
  
  reg [31:0] PC_out;
  wire [31:0] inc_pc;
  
  
  pc_inc_adder uut(.PC_out(PC_out),
                   .inc_pc(inc_pc));
  
  
  
  
  initial begin
    
    #10
    PC_out = 32'd16;
    
    #10
    
    $display("next incremented PC address is: %d", inc_pc);
    
    #10 $finish;
    
    
    
  end
  
                
             
  
  
  
  
endmodule
