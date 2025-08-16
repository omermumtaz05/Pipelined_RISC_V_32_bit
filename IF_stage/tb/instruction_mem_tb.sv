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
