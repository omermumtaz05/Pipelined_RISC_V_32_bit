// Code your testbench here
// or browse Examples
module alu_tb();
  
  //Inputs declared as regs
  reg [31:0] A;
  reg [31:0] B;
  reg [3:0] control;
  
  //Outputs declared as wires
  wire zero;
  wire [31:0] result;
  
  ALU uut(
    .A(A),
    .B(B),
    .control(control),
    .zero(zero),
    .result(result)
  );
  


  // Test sequence
  initial begin
    // Initialize inputs
    A = 0; B = 0; control = 0;
    
    #10 A = 2000; B = 2000; control = 4'b0110;
    #1 $display("At time %0t: A=%d B=%d control=%b result=%d zero=%b", $time, A, B, control, result, zero);
    
    #10 A = 10; B = 20; control = 4'b0010;
    #1 $display("At time %0t: A=%d B=%d control=%b result=%d zero=%b", $time, A, B, control, result, zero);
    
    #10 A = 32'd31; B = 32'd21; control = 4'b0000;
    #1 $display("At time %0t: A=%d B=%d control=%b result=%d zero=%b", $time, A, B, control, result, zero);
    
    #10 A = 32'd21; B = 32'd8; control = 4'b0001;
    #1 $display("At time %0t: A=%d B=%d control=%b result=%d zero=%b", $time, A, B, control, result, zero);
    
    #10 $finish;
    
    
   
  end
endmodule
