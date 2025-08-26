
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
	// addi x3, x0, 20
	instr[0] = 8'h93;
	instr[1] = 8'h01;
	instr[2] = 8'h40;
	instr[3] = 8'h01;
	    
	// lw x8, 120(x3)

	instr[4] = 8'h03;
	instr[5] = 8'hA4;
	instr[6] = 8'h81;
	instr[7] = 8'h07;

	// add x10, x3, x8
	instr[8] = 8'h33;
	instr[9] = 8'h05;
	instr[10] = 8'h34;
	instr[11] = 8'h00;

	// sub x11, x10, x8
	instr[12] = 8'hb3;
	instr[13] = 8'h05;
	instr[14] = 8'h85;
	instr[15] = 8'h40;

	//beq x3, x11, 8
	instr[16] = 8'h63;
	instr[17] = 8'h84;
	instr[18] = 8'hb1;
	instr[19] = 8'h00;
	    
	// garbage address
	instr[20] = 8'hxx;
	instr[21] = 8'hxx;
	instr[22] = 8'hxx;
	instr[23] = 8'hxx;
	    
	// garbage address
	instr[24] = 8'hxx;
	instr[25] = 8'hxx;
	instr[26] = 8'hxx;
	instr[27] = 8'hxx;
	
	// and x13, x8, x3
	instr[28] = 8'hb3;
	instr[29] = 8'h76;
	instr[30] = 8'h34;
	instr[31] = 8'h00;
	    
	// or x14, x8, x3
	instr[32] = 8'h33;
	instr[33] = 8'h67;
	instr[34] = 8'h34;
	instr[35] = 8'h00;
	    
	// sw x3, 150(x0)
	instr[36] = 8'h23;
	instr[37] = 8'h2b;
	instr[38] = 8'h30;
	instr[39] = 8'h08;
	    
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
    input logic  reset,
    
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
         	
         	for(i = 0; i < 127; i = i + 1)
                	data[i] <= '0;

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
