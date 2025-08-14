module ProgramCounter(
  input logic clk,
  input logic reset,

  input logic PCWrite,
  input logic [31:0] next_pc,

  output logic [31:0] pc);



  always_ff @ (posedge clk)
    if(reset)
      pc <= '0;
    else if(PCWrite)
	begin
      pc <= next_pc & 32'h0000007F;
     
  end
      
endmodule


//verify
