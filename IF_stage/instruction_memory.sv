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

     //sw x9, 100(x0)
      instr[32] = 8'h23;
      instr[33] = 8'h22;
      instr[34] = 8'h90;
      instr[35] = 8'h06;
      
	//addi x10, x0, 50
      instr[36] = 8'h13;
      instr[37] = 8'h05;
      instr[38] = 8'h20;
      instr[39] = 8'h03;

    //sub x10, x10, x10
      instr[40] = 8'h33;
      instr[41] = 8'h05; 
      instr[42] = 8'ha5;
      instr[43] = 8'h40;
      
      // nops
      
      instr[44] = '0;
      instr[45] = '0; 
      instr[46] = '0;
      instr[47] = '0;
      
      instr[48] = 8'h00;
      instr[49] = 8'h00; 
      instr[50] = 8'h00;
      instr[51] = 8'h00;
      
      //beq x10, x0, 8 
      
      instr[52] = 8'h63;
      instr[53] = 8'h04; 
      instr[54] = 8'h05;
      instr[55] = 8'h00;
      
      //addi x11, x0, 256
      instr[56] = 8'h93;
      instr[57] = 8'h05;
      instr[58] = 8'h00;
      instr[59] = 8'h10;
      
      //addi x12, x0, 256
      instr[60] = 8'h13;
      instr[61] = 8'h06;
      instr[62] = 8'h00;
      instr[63] = 8'h10;
      
      //lw x14, 100(x0)
      instr[64] = 8'h03;
      instr[65] = 8'h27;
      instr[66] = 8'h40;
      instr[67] = 8'h06;
      
      //beq x9, x14, 8
      instr[68] = 8'h63;
      instr[69] = 8'h84;
      instr[70] = 8'he4;
      instr[71] = 8'h00;
      
      //addi x15, x0, 256
      instr[72] = 8'h93;
      instr[73] = 8'h07;
      instr[74] = 8'h00;
      instr[75] = 8'h10;
      
      //addi x16, x0, 256
      instr[76] = 8'h13;
      instr[77] = 8'h08;
      instr[78] = 8'h00;
      instr[79] = 8'h10;
    end
  
    always_comb
       begin
            read_instr <= {instr[address + 3], instr[address + 2], 	instr[address + 1], instr[address]};
       end
        
       

endmodule
