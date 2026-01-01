// Code your design here
// Code your design here
// Code your design here
// Code your design here
// Code your design here

package cpu_pkg;

//if id data
typedef struct packed {
    // Data to be stored
    reg [31:0] pc_address;
    reg [31:0] instruc;
    
} if_id_data_t;

// id ex control and data

typedef struct packed {
  
    // WB stage control
    reg WB_reg_write;
    reg WB_mem_to_reg;

    // Mem stage control signals
    reg M_branch;
    reg M_mem_read;
    reg M_mem_write;

    // EX stage control signals
    reg [1:0] EX_ALU_Op;
    reg EX_ALU_Src;

} id_ex_control_t;

typedef struct packed {
    // Data to be stored
    reg [31:0] pc_address;
    reg [31:0] reg_read_data1;
    reg [31:0] reg_read_data2;

    reg [31:0] imm;
    reg [3:0] funct_inst_bits;
    reg [4:0] rd;

    reg [4:0] rs1;
    reg [4:0] rs2;

} id_ex_data_t;

//ex mem control and data
typedef struct packed {
    
    reg WB_reg_write;
    reg WB_mem_to_reg;

    
    reg M_branch;
    reg M_mem_read;
    reg M_mem_write;

    reg ALU_zero;

} ex_mem_control_t;

typedef struct packed {
    
    reg [31:0] branch_adder_sum;
    reg [31:0] ALU_result;
    reg [31:0] reg_read_data2;
    reg [4:0] rd;

} ex_mem_data_t;

//mem wb control and data
typedef struct packed {
    
    reg WB_reg_write;
    reg WB_mem_to_reg;

} mem_wb_control_t;

typedef struct packed {
    
    reg [31:0] read_data;
    reg [31:0] ALU_result;
    reg [4:0] rd;

} mem_wb_data_t;


endpackage


import cpu_pkg::*;

//IF stage:

module ProgramCounter(
  input logic clk,
  input logic reset,

  input logic PCWrite,
  input logic [31:0] next_pc,

  output logic [31:0] pc_out);


  always_ff @ (posedge clk)
    if(reset)
      pc_out <= '0;
    else if(PCWrite)
	begin
      pc_out <= next_pc & 32'h0000007F;
     
  end
      
endmodule

module PC_source_mux(
    input [31:0] branch_address,
    input [31:0] increment_address,
    input PCSrc,

    output [31:0] PC_input

);

    assign PC_input = PCSrc ?  branch_address : increment_address;
       

endmodule

module pc_inc_adder(
    input logic [31:0] PC_out,
    output logic [31:0] inc_pc
);

    assign inc_pc = PC_out + 32'd4;

endmodule


module instruction_memory(
    input logic [31:0]address,
    output logic [31:0] read_instr
);

    logic [7:0] instr [127:0];

   	initial begin
	
	// lw x2, 20(x0)
	instr[0] = 8'h03;
	instr[1] = 8'h21;
	instr[2] = 8'h40;
	instr[3] = 8'h01;


	// addi x3, x0, 17
	instr[4] = 8'h93;
	instr[5] = 8'h01;
	instr[6] = 8'h10;
	instr[7] = 8'h01;

	// addi x4, x3, 3 - exmem hazard
	instr[8] = 8'h13;
	instr[9] = 8'h82;
	instr[10] = 8'h31;
	instr[11] = 8'h00;

	// addi x5, x3, 15 - memwb hazard
	instr[12] = 8'h93;
	instr[13] = 8'h82;
	instr[14] = 8'hf1;
	instr[15] = 8'h00;

	// add x6, x3, x5 - ex mem fwd B hazard
	instr[16] = 8'h33;
	instr[17] = 8'h83;
	instr[18] = 8'h51;
	instr[19] = 8'h00;

	// add x7, x4, x5 - mem wb fwd B hazard
	instr[20] = 8'hb3;
	instr[21] = 8'h03;
	instr[22] = 8'h52;
	instr[23] = 8'h00;

	//lw x8, 40(x0) 
	instr[24] = 8'h03;
	instr[25] = 8'h24;
	instr[26] = 8'h80;
	instr[27] = 8'h02;

	//addi x9, x8, 256 - load use hazard check
	instr[28] = 8'h93;
	instr[29] = 8'h04;
	instr[30] = 8'h04;
	instr[31] = 8'h10;

	//addi x10, x0, 50
	instr[32] = 8'h13;
	instr[33] = 8'h05;
	instr[34] = 8'h20;
	instr[35] = 8'h03;
      
    //sw x9, 100(x0)
      instr[36] = 8'h23;
      instr[37] = 8'h22;
      instr[38] = 8'h90;
      instr[39] = 8'h06;
      
      //beq x0, x0, 8
      instr[40] = 8'h63;
      instr[41] = 8'h04;
      instr[42] = 8'h00;
      instr[43] = 8'h00;
      
      //addi x11, x0, 256
      instr[44] = 8'h93;
      instr[45] = 8'h05;
      instr[46] = 8'h00;
      instr[47] = 8'h10;
      
      //addi x12, x0, 256
      instr[48] = 8'h13;
      instr[49] = 8'h06;
      instr[50] = 8'h00;
      instr[51] = 8'h10;
      
    end
  
    always_comb
       begin
            read_instr <= {instr[address + 3], instr[address + 2], 	instr[address + 1], instr[address]};
       end
        
       

endmodule


//ID stage

module imm_gen(
    input logic [31:0] inst,
  	output logic [31:0] imm
);


    always_comb
        case(inst[6:0])

            7'b0000011,
          	7'b0010011:
              imm = {{20{inst[31]}}, inst[31:20]}; // lw and addi

            7'b0100011:

          		imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
          		

            7'b1100011:
      
  		 		    imm = {{19{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};

            default:
            
                imm = '0;

        endcase

endmodule


module control_mux(
    input id_ex_control_t all_control_in,

    input logic stall,

    output id_ex_control_t ctrl_mux_out

);

assign ctrl_mux_out = (stall) ? '0: all_control_in;


endmodule


module register(
    input clk,
  	input reset,

    input logic [4:0] readReg1,

    input logic [4:0] readReg2,
    input logic [4:0] writeReg,
    input logic [31:0] writeData,
    input logic regWrite,

    output logic [31:0] readData1,
  output logic [31:0] readData2
);

    logic [31:0] RF [31:0]; // 32 registers each carrying 32 bits of data each

    integer i;
    always_ff @ (posedge clk)
      if(reset)
        begin
  		
        for (i = 0; i < 32;  i = i + 1)
          RF[i] = 32'b0;
  
        end
        	
       else if(regWrite & writeReg != 0)
            RF[writeReg] <= writeData;

    always_comb
        begin
            readData1 = RF[readReg1];
            readData2 = RF[readReg2];

            if(readReg1 == writeReg)
                readData1 = writeData;
            if(readReg2 == writeReg)
                readData2 = writeData;
        end
  
  	/*always_comb
      begin
        if(
      end
  */

endmodule

module comparator(
    input logic [31:0] regData1,
    input logic [31:0] regData2,
	input reset,
  	input clock,
  
    output logic equal_to

);

  always_ff @ (posedge clock)
    begin
      if(reset || (regData1 != regData2))
        equal_to <= '0;
      
      else if(regData1 == regData2)
      
        	equal_to <= 1'b1;
    end


endmodule

// EX stage:

module ALU(
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [3:0] control,
    output logic zero, 
    output logic [31:0] result
);

    always_comb
        begin
            case(control)
                4'b0000: result = A & B;
                4'b0001: result = A | B;
                4'b0010: result = A + B;
                4'b0110: result = A - B;
                default: result = '0;
            endcase
        end

    
    assign zero = (result == 0);
    


endmodule

module forward_a_mux(
    input logic [31:0] read_data_1,
    input logic [31:0] ex_mem_out,
    input logic [31:0] mem_wb_out,

    input logic [1:0] forward_a,

    output logic [31:0] alu_inp_1
);

    assign alu_inp_1 = (forward_a == 2'b00) ? read_data_1:
                       (forward_a == 2'b01) ? mem_wb_out:
                       (forward_a == 2'b10) ? ex_mem_out:
                       read_data_1;


endmodule

module forward_b_mux(
    input logic [31:0] read_data_2,
    input logic [31:0] ex_mem_out,
    input logic [31:0] mem_wb_out,

    input logic [1:0] forward_b,

    output logic [31:0] alu_inp_2
);

    assign alu_inp_2 = (forward_b == 2'b00) ? read_data_2:
                       (forward_b == 2'b01) ? mem_wb_out:
                       (forward_b == 2'b10) ? ex_mem_out:
                       read_data_2;

endmodule

module branch_pc_adder(
    input logic [31:0] PC_address,
    input logic [31:0] imm,

    output logic [31:0] branch_address


);

    assign branch_address = PC_address + imm;


endmodule

module ALU_source_mux(
    input logic [31:0] read_data_2,
    input logic [31:0] imm,
    input logic ALUSrc,

    output logic [31:0] ALU_inp2

);

    assign ALU_inp2 = ~ALUSrc ? read_data_2 : imm;
       

endmodule

//MEM stage:

module data_memory(
    input logic clk,
    input logic reset,
    input logic [31:0] address,
    input logic [31:0] writeData,
    input logic memRead,
    input logic memWrite,
  
    output logic [31:0] memData
);

    logic [7:0] data [127:0];
 
    integer i;

    always_ff @ (posedge clk)
   begin
    if(reset)
    begin
	/*(for(i = 0; i < 128; i = i + 1)
		if(i != 20)
			data[i] = 0;*/

	data[20] = 8'h6D;
	data[21] = '0;
	data[22] = '0;
	data[23] = '0;

	data[40] = 8'hFF;
	data[41] = 8'h00;
	data[42] = 8'hFF;
	data[43] = 8'h00;
    end
    else if(memWrite)
       begin
            data[address] <= writeData[7:0];
            data[address + 1] <= writeData[15:8];
            data[address + 2] <= writeData[23:16];
            data[address + 3] <= writeData[31:24];
       end
     end

    always_comb
        if(memRead)
            memData = {data[address + 3], data[address + 2], data[address + 1], data[address]};
        else
            memData = '0;


endmodule

//WB stage

module mem_to_reg_mux(
    input logic [31:0] mem_read_data,
    input logic [31:0] ALU_result,
    input logic mem_to_reg,

    output logic [31:0] write_data

);

    assign write_data = ~mem_to_reg ? ALU_result : mem_read_data;
       

endmodule

//ID stage control unit
import cpu_pkg::*;

module control(
    input logic [31:0] instruc,
	input logic equal_to, 
  
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

module forwarding_unit(
    input logic [4:0] id_ex_rs1,
    input logic [4:0] id_ex_rs2,
    input logic [4:0] ex_mem_rd,
    input logic [4:0] mem_wb_rd,

    input logic ex_mem_reg_write,
    input logic mem_wb_reg_write,

    
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);


always_comb 
begin
    begin
        if((ex_mem_rd != 0) && ex_mem_reg_write && (ex_mem_rd == id_ex_rs1))

            forward_a = 2'b10;

        else if((mem_wb_rd != 0) && mem_wb_reg_write 
        && (mem_wb_rd == id_ex_rs1)
        && !(ex_mem_reg_write && (ex_mem_rd != 0) // make sure prev instruction in ex/mem stage doesnt write to/read from same address
        && ex_mem_rd == id_ex_rs1))

            forward_a = 2'b01;

        else
            forward_a = '0;
    end

    begin
        if((ex_mem_rd != 0) && ex_mem_reg_write && (ex_mem_rd == id_ex_rs2))

            forward_b = 2'b10;

        else if((mem_wb_rd != 0) && mem_wb_reg_write 
        && (mem_wb_rd == id_ex_rs2)
        && !(ex_mem_reg_write && (ex_mem_rd != 0) // make sure prev instruction in ex/mem stage doesnt write to/read from same address
        && ex_mem_rd == id_ex_rs2))

            forward_b = 2'b01;

        else
            forward_b = '0;
    end

end



endmodule

module hazard_detection(
    input logic id_ex_mem_read,
    input logic [4:0] id_ex_rd,
    input logic [4:0] if_id_rs1,
    input logic [4:0] if_id_rs2,


    output logic PCWrite,
    output logic if_id_write,
    output logic control_mux_sig
);


always_comb
begin

    if(id_ex_mem_read &&
      ((id_ex_rd == if_id_rs1) || 
       (id_ex_rd ==  if_id_rs2)))

        begin

            PCWrite = 0;
            if_id_write = 0;
            control_mux_sig = 1; // input 0 into all control signals

        end

    else 
    // regular instruction flow
        begin

            PCWrite = 1;
            if_id_write = 1;
            control_mux_sig = 0; //
            
        end



end



endmodule


//IF/ID register:


import cpu_pkg::*;

module IF_ID(
    input logic clock,
    input logic reset,
    input logic if_id_write,
    input if_id_data_t data_in,
  
    input if_id_flush,

    output if_id_data_t data_out
);

    always_ff @ (posedge clock)
      if(reset || if_id_flush)
            begin
                data_out <= '0;
            end
      
        
  	else if(if_id_write)
            begin
                data_out <= data_in;

            end
        

endmodule



module ID_EX(
    //standard for all sequential
    input logic clock,
    input logic reset,
    
    input id_ex_data_t data_in,

    input id_ex_control_t control_in,

    output id_ex_data_t data_out,
    
    output id_ex_control_t control_out
);


    always_ff @ (posedge clock)
    if(reset)
        begin
            data_out <= '0;
        
            control_out <= '0;
        end

    else 
        begin        

            data_out <= data_in;

            control_out <= control_in;
        end


endmodule

module EX_MEM(
    
    input logic clock,
    input logic reset,

    input ex_mem_data_t data_in,

    input ex_mem_control_t control_in,

    output ex_mem_data_t data_out,
    
    output ex_mem_control_t control_out
    
    

);


    always_ff @ (posedge clock)
    if(reset)
        begin
            data_out <= '0;
        
            control_out <= '0;
        end

    else 
        begin        

            data_out <= data_in;

            control_out <= control_in;
        end


endmodule

module MEM_WB(
    // standard sequential
    input clock,
    input reset,

    input mem_wb_data_t data_in,
    input mem_wb_control_t control_in,

    output mem_wb_data_t data_out,
    output mem_wb_control_t control_out

);


    always_ff @ (posedge clock)
    if(reset)
        begin
            data_out <= '0;
            control_out <= '0;
        end

    else 
        begin        

            data_out <= data_in;
            control_out <= control_in;
        end

endmodule

import cpu_pkg::*;

module top_module(
    input logic clock, 
    input logic reset
    );

    // pc and if/id control
    logic PCWrite, if_id_write;

  //  assign PCWrite = 1'b1; // testing for no hazard or forward detec
  //  assign if_id_write = 1'b1; // testing for no hazard or forward detec

    // mux control signals
    logic PCSrc, control_mux;
    
    //pipeline register values

    //ifid
    if_id_data_t ifid_data_in, ifid_data_out;

    //idex
    id_ex_data_t idex_data_in, idex_data_out;
    id_ex_control_t idex_control_in, idex_control_out, ctrl_unit_out;

    //exmem
    ex_mem_data_t exmem_data_in, exmem_data_out;
    ex_mem_control_t exmem_control_in, exmem_control_out;

    //memwb
    mem_wb_data_t memwb_data_in, memwb_data_out;
    mem_wb_control_t memwb_control_in, memwb_control_out;

    // fwd sels
    logic [1:0] fwd_a_sel, fwd_b_sel;

    //alu inps
    logic [31:0] ALU_inp_1, ALU_inp_2;
    logic [31:0] fwd_b_out;


    //alu ctrl and zero
    logic [3:0] ALU_control;
    logic zero;

    logic [31:0] inc_addrs, branch_addrs, PC_in, PC_out;
    logic [31:0] memtoreg_mux_out;
    logic [31:0] imm;
  
	//branch
  	logic equal_to;
  	logic if_id_flush;
    logic [4:0] if_id_rs1, if_id_rs2;
    

    // IF stage:
    PC_source_mux pc_mux(.branch_address(branch_addrs), .increment_address(inc_addrs),
                            .PCSrc(PCSrc), .PC_input(PC_in));


    ProgramCounter pc_reg(.clk(clock), .reset(reset),
                        .PCWrite(PCWrite), .next_pc(PC_in),
                          .pc_out(PC_out));

    pc_inc_adder pc_inc(.PC_out(PC_out), .inc_pc(inc_addrs));

    instruction_memory IM( .address(PC_out), .read_instr(ifid_data_in.instruc));
    assign ifid_data_in.pc_address = PC_out;

  IF_ID if_id(.clock(clock), .reset(reset), .if_id_write(if_id_write), .if_id_flush(if_id_flush),
                .data_in(ifid_data_in), .data_out(ifid_data_out));

    // ID stage:

    register RF(.clk(clock), .reset(reset),
                .readReg1(ifid_data_out.instruc[19:15]), .readReg2(ifid_data_out.instruc[24:20]),
                .writeReg(memwb_data_out.rd), .writeData(memtoreg_mux_out),
                .regWrite(memwb_control_out.WB_reg_write), .readData1(idex_data_in.reg_read_data1), .readData2(idex_data_in.reg_read_data2));

    assign if_id_rs1 = ifid_data_out.instruc[19:15];
    assign if_id_rs2 = ifid_data_out.instruc[24:20];

    hazard_detection hzd_dtc_unit(
    .id_ex_mem_read(idex_control_out.M_mem_read),
    .id_ex_rd(idex_data_out.rd),
    .if_id_rs1(if_id_rs1),
    .if_id_rs2(if_id_rs2),


    .PCWrite(PCWrite),
    .if_id_write(if_id_write),
    .control_mux_sig(control_mux)
    );


    imm_gen imm_gen(.inst(ifid_data_out.instruc), .imm(idex_data_in.imm));

  control control_unit(.instruc(ifid_data_out.instruc), .equal_to(equal_to), .all_ctrl_out(ctrl_unit_out), .if_id_flush(if_id_flush));

    control_mux ctrl_mux(
    .all_control_in(ctrl_unit_out),

    .stall(control_mux),

    .ctrl_mux_out(idex_control_in)

	);
  	
    // assign PCSrc = exmem_control_out.M_branch & exmem_control_out.ALU_zero;
  
     branch_pc_adder branch_addr(
       .PC_address(ifid_data_out.pc_address),
       .imm(idex_data_in.imm),

       .branch_address(branch_addrs)
      );

    comparator comp(
      .regData1(idex_data_in.reg_read_data1),
      .regData2(idex_data_in.reg_read_data2),
      .reset(reset),
      .clock(clock),
      .equal_to(equal_to)
      
    );
  
  	assign PCSrc = ctrl_unit_out.M_branch && equal_to;
  
    assign idex_data_in.pc_address = ifid_data_out.pc_address;

    assign idex_data_in.funct_inst_bits = {ifid_data_out.instruc[30], ifid_data_out.instruc[14:12]};
    assign idex_data_in.rd = ifid_data_out.instruc[11:7];

    assign idex_data_in.rs1 = ifid_data_out.instruc[19:15];
    assign idex_data_in.rs2 = ifid_data_out.instruc[24:20];

    ID_EX idex_reg(.clock(clock), .reset(reset), .data_in(idex_data_in), .control_in(idex_control_in),
                    .data_out(idex_data_out), .control_out(idex_control_out));


    //EX stage


    ALU alu(
    .A(ALU_inp_1),
    .B(ALU_inp_2),
    .control(ALU_control),
    .zero(exmem_control_in.ALU_zero), 
    .result(exmem_data_in.ALU_result)
    );


    ALUControl alu_ctrl(

    .funct7_bit_6(idex_data_out.funct_inst_bits[3]),
    .funct3(idex_data_out.funct_inst_bits[2:0]),
    .ALUOp(idex_control_out.EX_ALU_Op),

    .control(ALU_control)
    );


    ALU_source_mux alu_src_mux(
    .read_data_2(fwd_b_out),
    .imm(idex_data_out.imm),
    .ALUSrc(idex_control_out.EX_ALU_Src),

    .ALU_inp2(ALU_inp_2)
    );


    forwarding_unit fwd_unit(
    .id_ex_rs1(idex_data_out.rs1),
     .id_ex_rs2(idex_data_out.rs2),
    .ex_mem_rd(exmem_data_out.rd),
    .mem_wb_rd(memwb_data_out.rd),

    .ex_mem_reg_write(exmem_control_out.WB_reg_write),
    .mem_wb_reg_write(memwb_control_out.WB_reg_write),
    
    .forward_a(fwd_a_sel),
    .forward_b(fwd_b_sel)
    );

    forward_a_mux fwd_a_mux(
    .read_data_1(idex_data_out.reg_read_data1),
    .ex_mem_out(exmem_data_out.ALU_result),
    .mem_wb_out(memtoreg_mux_out),
    .forward_a(fwd_a_sel),

    .alu_inp_1(ALU_inp_1)
    );

    forward_b_mux fwd_b_mux(
    .read_data_2(idex_data_out.reg_read_data2),
    .ex_mem_out(exmem_data_out.ALU_result),
    .mem_wb_out(memtoreg_mux_out),
    .forward_b(fwd_b_sel),

    .alu_inp_2(fwd_b_out)
);

    assign exmem_data_in.reg_read_data2 = fwd_b_out;
    assign exmem_data_in.rd = idex_data_out.rd;

    assign exmem_control_in.WB_reg_write = idex_control_out.WB_reg_write;
    assign exmem_control_in.WB_mem_to_reg = idex_control_out.WB_mem_to_reg;

    assign exmem_control_in.M_branch = idex_control_out.M_branch;
    assign exmem_control_in.M_mem_read = idex_control_out.M_mem_read;
    assign exmem_control_in.M_mem_write = idex_control_out.M_mem_write;

    EX_MEM exmem_reg(
    .clock(clock),
    .reset(reset),

    .data_in(exmem_data_in),
    .control_in(exmem_control_in),

    .data_out(exmem_data_out),
    .control_out(exmem_control_out)
    );


    //MEM stage

    data_memory DM(
    .clk(clock),
    .reset(reset),
    .address(exmem_data_out.ALU_result),
    .writeData(exmem_data_out.reg_read_data2),
    .memRead(exmem_control_out.M_mem_read),
    .memWrite(exmem_control_out.M_mem_write),
    .memData(memwb_data_in.read_data)
    );

    assign memwb_data_in.ALU_result = exmem_data_out.ALU_result;
    assign memwb_data_in.rd = exmem_data_out.rd;

    assign memwb_control_in.WB_reg_write = exmem_control_out.WB_reg_write;
    assign memwb_control_in.WB_mem_to_reg = exmem_control_out.WB_mem_to_reg;

    MEM_WB memwb_reg(
    .clock(clock),
    .reset(reset),

    .data_in(memwb_data_in),
    .control_in(memwb_control_in),

    .data_out(memwb_data_out),
    .control_out(memwb_control_out)
    );

    mem_to_reg_mux mem_reg_mux(
    .mem_read_data(memwb_data_out.read_data),
    .ALU_result(memwb_data_out.ALU_result),
    .mem_to_reg(memwb_control_out.WB_mem_to_reg),

    .write_data(memtoreg_mux_out)
    );



endmodule
