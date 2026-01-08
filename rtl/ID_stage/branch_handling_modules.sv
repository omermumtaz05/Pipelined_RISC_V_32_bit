module branch_fwd_unit(
    input logic [5:0] if_id_rs1,
    input logic [5:0] if_id_rs2,

    input logic [5:0] id_ex_rd,
    input logic [5:0] ex_mem_rd,
    input logic [5:0] mem_wb_rd,

    input logic control_branch,

    input logic id_ex_regWrite,
    input logic ex_mem_regWrite,
    input logic mem_wb_regWrite,

    output logic [1:0] fwd_c_sel,
    output logic [1:0] fwd_d_sel
  );

  //fwd C
  always_comb 
      begin 
          //id ex fwd
          if((id_ex_rd != 0) && id_ex_rd == if_id_rs1 && id_ex_regWrite && control_branch)
              fwd_c_sel = 2'b01;

          // ex mem fwd
          else if((ex_mem_rd != 0) && ex_mem_rd == if_id_rs1 && ex_mem_regWrite && control_branch 
                  && !(id_ex_rd == if_id_rs1 && id_ex_regWrite))
              fwd_c_sel = 2'b10;

          //mem wb fwd
          else if((mem_wb_rd != 0) && mem_wb_rd == if_id_rs1 && mem_wb_regWrite && control_branch 
                  && !(id_ex_rd == if_id_rs1 && id_ex_regWrite) // make sure earlier stage not writing to same reg
                  && !(ex_mem_rd == if_id_rs1 && ex_mem_regWrite)) // make sure earlier stage not writing to same reg
              fwd_c_sel = 2'b11;

          //no fwd!
          else
              fwd_c_sel = '0;

      end

  //fwd D
  always_comb 
      begin 
          //id ex fwd
          if((id_ex_rd != 0) && id_ex_rd == if_id_rs2 && id_ex_regWrite && control_branch)
              fwd_d_sel = 2'b01;
  
          // ex mem fwd
          else if((ex_mem_rd != 0) && ex_mem_rd == if_id_rs2 && ex_mem_regWrite && control_branch 
                  && !(id_ex_rd == if_id_rs2 && id_ex_regWrite))
              fwd_d_sel = 2'b10;

          //mem wb fwd
          else if((mem_wb_rd != 0) && (mem_wb_rd == if_id_rs2) && mem_wb_regWrite && control_branch 
                  && !(id_ex_rd == if_id_rs2 && id_ex_regWrite) // make sure earlier stage not writing to same reg
                  && !(ex_mem_rd == if_id_rs2 && ex_mem_regWrite)) // make sure earlier stage not writing to same reg
              fwd_d_sel = 2'b11;

          //no fwd!
          else
              fwd_d_sel = '0;

      end


endmodule

module fwd_c_mux(
    input [31:0] readRegData1,
    input [31:0] EX_ALU_out,
    input [31:0] ex_mem_alu_out,
    input [31:0] mem_to_reg_out,

    input [1:0] fwd_c_sel,

    output [31:0] fwd_c_out

);


  assign fwd_c_out =  EX_ALU_out ? (fwd_c_sel == 2'b01):
                      ex_mem_alu_out ? (fwd_c_sel == 2'b10):
                      mem_to_reg_out ? (fwd_c_sel == 2'b11):
                      readRegData1;


endmodule

module fwd_d_mux(
    input [31:0] readRegData2,
    input [31:0] EX_ALU_out,
    input [31:0] ex_mem_alu_out,
    input [31:0] mem_to_reg_out,

    input [1:0] fwd_d_sel,

    output [31:0] fwd_d_out

);


	assign fwd_d_out = EX_ALU_out ? (fwd_d_sel == 2'b01):
                    	ex_mem_alu_out ? (fwd_d_sel == 2'b10):
      mem_to_reg_out ? (fwd_d_sel == 2'b11):
  readRegData2;


endmodule

module comparator(
    input logic [31:0] regData1,
    input logic [31:0] regData2,
	input reset,
  	input clock,
  
    output logic equal_to

);

  always_comb// @ (posedge clock)
    begin
      if(reset || (regData1 != regData2))
        equal_to <= '0;
      
      else if(regData1 == regData2)
      
        	equal_to <= 1'b1;
    end


endmodule
