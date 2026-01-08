
module imm_gen_tb();
  
  //Inputs declared as regs
  reg [31:0] inst;
  
  //Outputs declared as wires
  wire [31:0] imm;
  
  imm_gen uut(
    .inst(inst),
    .imm(imm)
  );
  


  // Test sequence
  initial begin
    // Initialize inputs
    inst = 0;
    //I type (addi)
    #10 inst = 32'b00000001010010101010101010010011;
    #1 $display("imm is %d ", imm); // expected imm 20
    
    #10 inst = 32'b00000001010010101010101010000011; // lw expect 20
    
    #1 $display("imm is %d ", imm);
    
      
    
   	#10 inst = 32'b00000001010110101010101000100011; // sw expect 20
    #1 $display("imm is %d ", imm);
    
    #10 inst = 32'b00000001010101010101101001100011; // beq input 10
    //expect 20
    #1 $display("imm is %d ", imm);
    
    
    #10 $finish;
    
    
   
  end
endmodule
