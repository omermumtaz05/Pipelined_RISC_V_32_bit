// Code your testbench here
// or browse Examples

module control_tb();

  
  reg [31:0] instruction;

  
  wire [1:0] ALUOp;
  wire ALUSrc;
  wire branch;
  wire mem_read;
  wire mem_write;
  wire reg_write;
  wire mem_to_reg;
  
  
  
  
  control uut(
    .instruc(instruction),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .branch(branch),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .reg_write(reg_write),
    .mem_to_reg(mem_to_reg)
  );
  


  // Test sequence
  initial begin
    // Initialize inputs
    instruction = 32'b0;
    
    #10
    //test lw
    instruction = 32'hxxxxxx83;
    
    #10
    $display("ALUOp = %b, alu src = %b, branch = %b, mem read = %b, mem write = %b, reg write = %b, mem_to_reg = %b", ALUOp, ALUSrc, branch, mem_read, mem_write, reg_write, mem_to_reg);
    
    #10
    //test sw
    instruction = 32'hxxxxxxa3;
    
    #10
    $display("ALUOp = %b, alu src = %b, branch = %b, mem read = %b, mem write = %b, reg write = %b, mem_to_reg = %b", ALUOp, ALUSrc, branch, mem_read, mem_write, reg_write, mem_to_reg);
    
    #10
    //test r-type
    instruction = 32'hxxxxxxb3;
    
    #10
    $display("ALUOp = %b, alu src = %b, branch = %b, mem read = %b, mem write = %b, reg write = %b, mem_to_reg = %b", ALUOp, ALUSrc, branch, mem_read, mem_write, reg_write, mem_to_reg);
    
    #10
    //test beq
    instruction = 32'hxxxxxxe3;
    
    #10
    $display("ALUOp = %b, alu src = %b, branch = %b, mem read = %b, mem write = %b, reg write = %b, mem_to_reg = %b", ALUOp, ALUSrc, branch, mem_read, mem_write, reg_write, mem_to_reg);
    
     #10
    //test addi
    instruction = 32'hxxxxxx93;
    
    #10
    $display("ALUOp = %b, alu src = %b, branch = %b, mem read = %b, mem write = %b, reg write = %b, mem_to_reg = %b", ALUOp, ALUSrc, branch, mem_read, mem_write, reg_write, mem_to_reg);
    
    #10 $finish;
    

    
    
   
  end
endmodule
