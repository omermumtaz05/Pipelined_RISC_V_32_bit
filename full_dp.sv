
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
      pc_out <= next_pc; // & 32'h0000007F;
     
  end
      
endmodule

module PC_source_mux(
    input [31:0] branch_address,
    input [31:0] increment_address,
    input PCSrc,

    output [31:0] PC_input

);

    assign PC_input = ~PCSrc ? increment_address : branch_address;
       

endmodule

module pc_inc_adder(
    input logic [31:0] PC_out,
    output logic [31:0] inc_pc
);

    assign inc_pc = PC_out + 32'd4;

endmodule


module instruction_memory(
 	input logic clock,
  
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

	// addi x5, x3, 3 - memwb hazard
	instr[12] = 8'h93;
	instr[13] = 8'h82;
	instr[14] = 8'hf1;
	instr[15] = 8'h00;
	   
    end
  
    always_ff @ (posedge clock)
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
 
   
    always_ff @ (posedge clk)
   begin
    if(reset)
	data[20] = 32'h0000006D;
    
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
