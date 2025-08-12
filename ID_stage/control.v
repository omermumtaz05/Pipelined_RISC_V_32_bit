// Code your design here
module control(
    input [31:0] instruc,

    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg branch,
    output reg mem_read,
    output reg mem_write,
    output reg reg_write,
    output reg mem_to_reg


);

parameter LW = 7'b0000011,
          SW = 7'b0100011,
          R_type = 7'b0110011,
          BEQ = 7'b1100011,
	      ADDI = 7'b0010011;

  
    always @ (*)
    begin
        if(instruc[6:0] == R_type)
        begin
            ALUOp = 2'b10;
            ALUSrc = 1'b0;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            reg_write = 1'b1;
            mem_to_reg = 1'b0;
        end
        

        else if(instruc[6:0] == LW)
        begin
            ALUOp = 2'b00;
            ALUSrc = 1'b1;
            branch = 1'b0;
            mem_read = 1'b1;
            mem_write = 1'b0;
            reg_write = 1'b1;
            mem_to_reg = 1'b1;
        end
        

        else if(instruc[6:0] == SW)
        begin
            ALUOp = 2'b00;
            ALUSrc = 1'b1;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b1;
            reg_write = 1'b0;
            mem_to_reg = 1'bx;
        end
        

        else if(instruc[6:0] == BEQ)
        begin
            ALUOp = 2'b01;
            ALUSrc = 1'b0;
            branch = 1'b1;
            mem_read = 1'b0;
            mem_write = 1'b0;
            reg_write = 1'b0;
            mem_to_reg = 1'bx;
        end
        

        else if(instruc[6:0] == ADDI)
        begin
            ALUOp = 2'b00;
            ALUSrc = 1'b1;
            branch = 1'b0;
            mem_read = 1'b0;
            mem_write = 1'b0;
            reg_write = 1'b1;
            mem_to_reg = 1'b0;
        end
   

    end


endmodule
