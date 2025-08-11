// Code your design here
module ALUControl(
    
input funct7_bit_6,
input [2:0] funct3,
input [1:0] ALUOp,

output reg [3:0] control

);
  
    always @ (*)
        begin
            if(ALUOp == 2'b00)
                control = 4'b0010;
            else if(ALUOp == 2'b01)
                control = 4'b0110;
            else if(ALUOp == 2'b10)
                begin
                  if(funct7_bit_6 == 1'b0 && funct3 == 3'b0)
                        control = 4'b0010; // add
                  else if(funct7_bit_6 == 1'b1 && funct3 == 3'b0)
                        control = 4'b0110; // sub
                  else if(funct7_bit_6 == 1'b0 && funct3 == 3'b111)
                        control = 4'b0000; // AND
                    else if(funct7_bit_6 == 1'b0 && funct3 == 3'b110)
                        control = 4'b0001; // OR;
                end
        end

endmodule
