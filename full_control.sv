//ID stage control unit
import cpu_pkg::*;

module control(
    input logic [31:0] instruc,

    output id_ex_control_t all_ctrl_out

);

parameter LW = 7'b0000011,
          SW = 7'b0100011,
          R_type = 7'b0110011,
          BEQ = 7'b1100011,
	      ADDI = 7'b0010011;

  
    always_comb
    begin
        if(instruc[6:0] == R_type)
        begin
            all_ctrl_out.EX_ALU_Op = 2'b10;
            all_ctrl_out.EX_ALU_Src = 1'b0;
            all_ctrl_out.M_branch = 1'b0;
            all_ctrl_out.M_mem_read = 1'b0;
            all_ctrl_out.M_mem_write = 1'b0;
            all_ctrl_out.WB_reg_write = 1'b1;
            all_ctrl_out.WB_mem_to_reg = 1'b0;
        end
        

        else if(instruc[6:0] == LW)
        begin

            all_ctrl_out.EX_ALU_Op = 2'b00;
            all_ctrl_out.EX_ALU_Src = 1'b1;
            all_ctrl_out.M_branch = 1'b0;
            all_ctrl_out.M_mem_read = 1'b1;
            all_ctrl_out.M_mem_write = 1'b0;
            all_ctrl_out.WB_reg_write = 1'b1;
            all_ctrl_out.WB_mem_to_reg = 1'b1;
        end
        

        else if(instruc[6:0] == SW)
        begin
            all_ctrl_out.EX_ALU_Op = 2'b00;
            all_ctrl_out.EX_ALU_Src = 1'b1;
            all_ctrl_out.M_branch = 1'b0;
            all_ctrl_out.M_mem_read = 1'b0;
            all_ctrl_out.M_mem_write = 1'b1;
            all_ctrl_out.WB_reg_write = 1'b0;
            all_ctrl_out.WB_mem_to_reg = 1'bx;
        end
        

        else if(instruc[6:0] == BEQ)
        begin
            all_ctrl_out.EX_ALU_Op = 2'b01;
            all_ctrl_out.EX_ALU_Src = 1'b0;
            all_ctrl_out.M_branch = 1'b1;
            all_ctrl_out.M_mem_read = 1'b0;
            all_ctrl_out.M_mem_write = 1'b0;
            all_ctrl_out.WB_reg_write = 1'b0;
            all_ctrl_out.WB_mem_to_reg = 1'bx;
        end
        

        else if(instruc[6:0] == ADDI)
        begin
            all_ctrl_out.EX_ALU_Op = 2'b00;
            all_ctrl_out.EX_ALU_Src = 1'b1;
            all_ctrl_out.M_branch = 1'b0;
            all_ctrl_out.M_mem_read = 1'b0;
            all_ctrl_out.M_mem_write = 1'b0;
            all_ctrl_out.WB_reg_write = 1'b1;
            all_ctrl_out.WB_mem_to_reg = 1'b0;
        end
   

    end


endmodule


//ALU control in EX stage

module ALUControl(
    
input logic funct7_bit_6,
input logic [2:0] funct3,
input logic [1:0] ALUOp,

output logic [3:0] control

);
  
    always_comb
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

