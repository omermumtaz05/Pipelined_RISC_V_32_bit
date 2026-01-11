module top_tb();

logic clock;
logic reset;


top_module uut(
	.clock(clock),
	.reset(reset)
);
  



  initial clock = 1;
  always #5 clock = ~clock;  // Toggle every 5 ns ? 10 ns period = 100 MHz
  
always_ff @(posedge clock) begin
    if (!reset) begin
        $display("=== Cycle %0t ===", $time);
      $display("  PC = %0d", uut.PC_out);
      $display( "IF: %0h", uut.IM.read_instr);
      $display( "ID: %0h", uut.ifid_data_out.instruc);
      $display( "EX: %0h", uut.idex_data_out.instruc);
      $display( "MEM: %0h", uut.exmem_data_out.instruc);
      $display( "WB: %0h", uut.memwb_data_out.instruc);

        $display("");
    end
end
  
  // Test sequence
  initial begin
    reset = 1;
    #10 reset = 0;
    
    repeat(30) @(posedge clock);
    
     $display("=== Cycle %0t ===", $time);
     $display("  PC = %h", uut.PC_out);
     $display("  RF[2]=%h RF[3]=%h RF[4]=%h RF[5]=%h", 
                 uut.RF.RF[2], uut.RF.RF[3], uut.RF.RF[4], uut.RF.RF[5]);
     $display("  RF[6]=%h RF[7]=%h RF[8]=%h RF[9]=%h",
                 uut.RF.RF[6], uut.RF.RF[7], uut.RF.RF[8], uut.RF.RF[9]);
     $display("");
    
    
    $display("=== DONE ===");
    $stop;
end

endmodule
