// Code your testbench here
// or browse Examples
module tb();
  
    reg clock;
    reg reset;
    
    // data to be stored
    reg [31:0] read_data;
  	reg [31:0] ALU_result_in;
    reg [4:0] rd;

    //control signals for upcoming stages to be storeed

    //WB stage control
    reg WB_reg_write;
    reg WB_mem_to_reg;


    //data being outputted
  	wire [31:0] read_data_out;
    wire [31:0] ALU_result_out;
    wire [4:0] rd_out;

    //control signals to be outputted
    
    //WB stage control output
    wire WB_reg_write_out;
    wire WB_mem_to_reg_out;
  
  
  MEM_WB uut(
    //inputs
    .clock(clock),
    .reset(reset),
    
    .read_data_in(read_data),
    .ALU_result_in(ALU_result_in),
    .rd_in(rd),
    
    .WB_reg_write_in(WB_reg_write),
    .WB_mem_to_reg_in(WB_mem_to_reg),
    
    
   	// outputs
    .read_data_out(read_data_out),
    .ALU_result_out(ALU_result_out),
    .rd_out(rd_out),
    
    .WB_reg_write_out(WB_reg_write_out),
    .WB_mem_to_reg_out(WB_mem_to_reg_out)
   
   
  );
  
  
   initial clock = 0;
  always #5 clock = ~clock;  // Toggle every 5 ns → 10 ns period = 100 MHz

  // Test sequence
  initial begin
    
    // Initialize inputs
    clock = 0; reset = 1; 
    
    #10 reset = 0;
    
    #10 WB_reg_write = 1;
    	WB_mem_to_reg = 1;
    
  
    #10 $display("reg write = %d, mem to reg = %d", WB_reg_write_out, WB_mem_to_reg_out);
    
    
    #10 read_data = 32'd1234;
    	ALU_result_in = 32'd12345;
        rd = 5'd31;
    
    
    #10 $display("read data from mem = %d, alu result = %d, read data 2 = %d", read_data_out, ALU_result_out, rd_out);
    
     #10 reset = 1;
   
     #10 $display("reg write = %d, mem to reg = %d", WB_reg_write_out, WB_mem_to_reg_out);
    
     #10 $display("read data from mem = %d, alu result = %d, read data 2 = %d", read_data_out, ALU_result_out, rd_out); 
    
    #10 $finish; 
    
   
  end

  
endmodule
