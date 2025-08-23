
module forwarding_unit_tb();
  
  //Inputs declared as regs
  logic [4:0] id_ex_rs1;
  logic [4:0] id_ex_rs2;
  logic [4:0] ex_mem_rd;
  logic [4:0] mem_wb_rd;
  
  logic ex_mem_reg_write;
  logic mem_wb_reg_write;

  logic [1:0] forward_a;
  logic [1:0] forward_b;
  
  
  forwarding_unit uut(
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .ex_mem_rd(ex_mem_rd),
    .mem_wb_rd(mem_wb_rd),
    
    .ex_mem_reg_write(ex_mem_reg_write),
    .mem_wb_reg_write(mem_wb_reg_write),
    
    .forward_a(forward_a),
    .forward_b(forward_b)
    
  );
  


  // Test sequence
  initial begin
    // Initialize inputs
  	id_ex_rs1 = '0; id_ex_rs2 = '0; ex_mem_rd = '0;
    mem_wb_rd = '0; ex_mem_reg_write = 0;
    mem_wb_reg_write = 0;
    
    // forward a = 2'b10 test
    #10 ex_mem_rd = 'b10101; ex_mem_reg_write = 1; 
    	id_ex_rs1 = 'b10101; 
    
    #1 $display("forward a is %b", forward_a);
    
    //forward a = 2'b01 test
    #10 mem_wb_rd = 'b10101; mem_wb_reg_write = 1; 
    	id_ex_rs1 = 'b10101; 
    
    	ex_mem_rd = 'b01010; ex_mem_reg_write = 0; 
    
    #1 $display("forward_a is %b", forward_a);
    
      //forward a = 2'b10 but also 01 test
    #10 mem_wb_rd = 'b11111; mem_wb_reg_write = 1; 
    	id_ex_rs1 = 'b11111; 
    
    	ex_mem_rd = 'b11111; ex_mem_reg_write = 1; //ex_mem is more recent and has hazard so it takes precedence
    
    #1 $display("forward_a is %b", forward_a);
    
    //forward a = 2'b00
    #10 mem_wb_rd = '0; mem_wb_reg_write = 0; 
    	id_ex_rs1 = 'b11111; 
    
    	ex_mem_rd = 'b1010; ex_mem_reg_write = 1; 
    
    #1 $display("forward_a is %b", forward_a);
    
    
    // forward b = 2'b10 test
    #10 ex_mem_rd = 'b10101; ex_mem_reg_write = 1; 
    	id_ex_rs2 = 'b10101; id_ex_rs1 = '0;
    
    #1 $display("forward b is %b", forward_b);
    
    //forward b = 2'b01 test
    #10 mem_wb_rd = 'b10101; mem_wb_reg_write = 1; 
    	id_ex_rs2 = 'b10101; 
    
    	ex_mem_rd = 'b01010; ex_mem_reg_write = 0; 
    
    #1 $display("forward_b is %b", forward_b);
    
      //forward a = 2'b10 but also 01 test
    #10 mem_wb_rd = 'b11111; mem_wb_reg_write = 1; 
    	id_ex_rs2 = 'b11111; 
    
    	ex_mem_rd = 'b11111; ex_mem_reg_write = 1; //ex_mem is more recent and has hazard so it takes precedence
    
    #1 $display("forward_b is %b", forward_b);
    
    //forward b = 2'b00
    #10 mem_wb_rd = '0; mem_wb_reg_write = 0; 
    	id_ex_rs2 = 'b11111; 
    
    	ex_mem_rd = 'b1010; ex_mem_reg_write = 1; 
    
    #1 $display("forward_b is %b", forward_b);

    #10 $finish;

   
  end
endmodule
