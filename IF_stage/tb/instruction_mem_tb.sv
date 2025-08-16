// Code your testbench here
// or browse Examples
module tb();
  
  logic clock;
  logic [31:0] address;

  
  logic [31:0] read_instr;
  
  
  instruction_memory uut(.clock(clock),
                         .address(address),
                         .read_instr(read_instr));
  
  initial clock = 0;
  always #5 clock = ~clock;  // Toggle every 5 ns → 10 ns period = 100 MHz

  
  initial begin
    
    clock = 0;
    
    #10 address = 32'd0;
    
    #10 $display("instruction at address 0 is: %h", read_instr);
    
    #10 address = 32'd4;
    
    #10 $display("instruction at address 4 is: %h", read_instr);
    
    #10 address = 32'd17; //incorrect. just testing 4 byte concatenation
    
    #10 $display("instruction at address 17 is: %h", read_instr);
    
    #10 address = 32'd16;
    
    #10 $display("instruction at address 16 is: %h", read_instr);
    

    

    #10 $finish;
    
    
    
  end
  
                
             
  
  
  
  
endmodule
