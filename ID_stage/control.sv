import cpu_pkg::*;

module control(
    input logic [31:0] instruc,
	input logic equal_to, 
  	input logic stall,
  
    output id_ex_control_t all_ctrl_out,
  	output logic if_id_flush

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
            if_id_flush = 1'b0;
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
            if_id_flush = 1'b0;
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
            if_id_flush = 1'b0;
        end
        

      else if((instruc[6:0] == BEQ) && stall)
        begin
            all_ctrl_out.EX_ALU_Op = 2'b01;
            all_ctrl_out.EX_ALU_Src = 1'b0;
            all_ctrl_out.M_branch = 1'b1;
            all_ctrl_out.M_mem_read = 1'b0;
            all_ctrl_out.M_mem_write = 1'b0;
            all_ctrl_out.WB_reg_write = 1'b0;
            all_ctrl_out.WB_mem_to_reg = 1'bx;
            if_id_flush = 1'b0;
        end
        
      else if((instruc[6:0] == BEQ) && equal_to)
        begin
            all_ctrl_out.EX_ALU_Op = 2'b01;
            all_ctrl_out.EX_ALU_Src = 1'b0;
            all_ctrl_out.M_branch = 1'b1;
            all_ctrl_out.M_mem_read = 1'b0;
            all_ctrl_out.M_mem_write = 1'b0;
            all_ctrl_out.WB_reg_write = 1'b0;
            all_ctrl_out.WB_mem_to_reg = 1'bx;
            if_id_flush = 1'b1;
        end
        
      else if((instruc[6:0] == BEQ) && !equal_to)
        begin
            all_ctrl_out.EX_ALU_Op = 2'b01;
            all_ctrl_out.EX_ALU_Src = 1'b0;
            all_ctrl_out.M_branch = 1'b1;
            all_ctrl_out.M_mem_read = 1'b0;
            all_ctrl_out.M_mem_write = 1'b0;
            all_ctrl_out.WB_reg_write = 1'b0;
            all_ctrl_out.WB_mem_to_reg = 1'bx;
            if_id_flush = 1'b0;
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
            if_id_flush = 1'b0;
        end
   
		else
          begin
            all_ctrl_out.EX_ALU_Op = 2'b00;
            all_ctrl_out.EX_ALU_Src = 1'b0;
            all_ctrl_out.M_branch = 1'b0;
            all_ctrl_out.M_mem_read = 1'b0;
            all_ctrl_out.M_mem_write = 1'b0;
            all_ctrl_out.WB_reg_write = 1'b0;
            all_ctrl_out.WB_mem_to_reg = 1'b0;
            if_id_flush = 1'b0;
          end
    end


endmodule
