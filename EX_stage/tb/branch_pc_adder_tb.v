// Code your testbench here
// or browse Examples
module tb();
  
  reg [31:0] PC_out;
  reg [31:0] imm;
  
  wire [31:0] branch_address;
  
  
  branch_pc_adder uut(.PC_address(PC_out),
                      .imm(imm),
                      .branch_address(branch_address));
  
 
  
  
  initial begin
    
    #10
    PC_out = 32'd16; imm = 32'd8;
    
    #10
    
    $display("branch PC address is: %d", branch_address);
    
    #10 $finish;
    
    
    
  end
  
                
             
  
  
  
  
endmodule
