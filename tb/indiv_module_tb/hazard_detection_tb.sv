
module forwarding_unit_tb();
  
  logic [4:0] if_id_rs1;
  logic [4:0] if_id_rs2;
  logic [4:0] id_ex_rd;
  
  logic id_ex_mem_read;
  

  logic PCWrite;
  logic control_mux_sig;
  logic if_id_write;
  
  
  hazard_detection uut(
    .if_id_rs1(if_id_rs1),
    .if_id_rs2(if_id_rs2),
    .id_ex_rd(id_ex_rd),
    
    .id_ex_mem_read(id_ex_mem_read),
    
    .PCWrite(PCWrite),
    .control_mux_sig(control_mux_sig),
    .if_id_write(if_id_write)
    
  );
  


  // Test sequence
  initial begin
    // Initialize inputs
  	if_id_rs1 = '0; if_id_rs2 = '0; 
    id_ex_rd = '0; id_ex_mem_read = 0;

    
    #10 id_ex_mem_read = 1; 
    	if_id_rs1 = 'b10101; 
    	id_ex_rd = 'b10101; 
    
    #1 $display("ID/EX memread asserted & RD = RS1:\nPCWrite is %b, IF/ID write is %b, control mux sel is %b\n", PCWrite, if_id_write, control_mux_sig);
    
    #10 if_id_rs1 = '0; 
    
    #10 id_ex_mem_read = 1; 
    	if_id_rs2 = 'b10101; 
    	id_ex_rd = 'b10101; 
    
    #1 $display("ID/EX memread asserted & RD = RS2:\nPCWrite is %b, IF/ID write is %b, control mux sel is %b\n", PCWrite, if_id_write, control_mux_sig);
    
    #10 id_ex_mem_read = 0; 
    	if_id_rs2 = 'b01010; 
    	id_ex_rd = 'b01010; 
    
    #1 $display("ID/EX memread deasserted rd = rs2:\nPCWrite is %b, IF/ID write is %b, control mux sel is %b\n", PCWrite, if_id_write, control_mux_sig);
    
    #10 id_ex_mem_read = 0;
    	if_id_rs1 = 'b10101; 
    	if_id_rs2 = 'b11111; 
    	id_ex_rd = 'b10101; 
    
    #1 $display("ID/EX memread deasserted rd = rs1:\nPCWrite is %b, IF/ID write is %b, control mux sel is %b\n", PCWrite, if_id_write, control_mux_sig);

    
    #10 id_ex_mem_read = 1;
    	if_id_rs1 = 'b00000; 
    	if_id_rs2 = 'b11111; 
    	id_ex_rd = 'b10101; 
    
    #1 $display("ID/EX memread asserted but other conditions not fulfilled:\nPCWrite is %b, IF/ID write is %b, control mux sel is %b\n", PCWrite, if_id_write, control_mux_sig);
    
    #10 id_ex_mem_read = 0;
    	if_id_rs1 = 'b00000; 
    	if_id_rs2 = 'b11111; 
    	id_ex_rd = 'b10101; 
    
    #1 $display("No conditions fulfilled:\nPCWrite is %b, IF/ID write is %b, control mux sel is %b\n", PCWrite, if_id_write, control_mux_sig);

    #10 $finish;

   
  end
    
endmodule
