
module ALUControl_tb();
  
  //Inputs declared as regs
  reg funct7;
  reg [2:0] funct3;
  reg [1:0] ALUOp;
  
  //Outputs declared as wires
  wire [3:0] control;
  
  ALUControl uut(
    .funct7_bit_6(funct7),
    .funct3(funct3),
    .ALUOp(ALUOp),
    .control(control)
  );
  


  // Test sequence
  initial begin
    // Initialize inputs
    funct7 = 0; funct3 = 0; ALUOp = 0;
    
    //lw and sw
    #10 funct7 = 1'bx; funct3 = 3'bxxx; ALUOp = 2'b00; 
    
    #1 $display("ALUControl is %b for lw and sw", control);
    
    //beq
    #10 funct7 = 1'bx; funct3 = 3'bxxx; ALUOp = 2'b01; 
    #1 $display("ALUControl is %b for beq", control);
    
    // r-type:
    
    //add
    #10 funct7 = 1'b0; funct3 = 3'b000; ALUOp = 2'b10;
    #1 $display("ALUControl is %b for add", control);
    
    //sub
    #10 funct7 = 1'b1; funct3 = 3'b000; ALUOp = 2'b10;
    #1 $display("ALUControl is %b for sub", control);
    
    //and
    #10 funct7 = 1'b0; funct3 = 3'b111; ALUOp = 2'b10;
    #1 $display("ALUControl is %b for and", control);
    
    //or
    #10 funct7 = 1'b0; funct3 = 3'b110; ALUOp = 2'b10;
    #1 $display("ALUControl is %b for or", control);
    
    
    #10 $finish;
    
    
   
  end
endmodule
