// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples

module top_tb();

logic clock;
logic reset;


top_module uut(
	.clock(clock),
	.reset(reset)
);
  



  initial clock = 1;
  always #5 clock = ~clock;  // Toggle every 5 ns ? 10 ns period = 100 MHz

  always @(posedge clock) begin
    if (!reset) begin
        $display("=== Cycle %0t ===", $time);
      $display("  PC = %0h", uut.PC_out);
      $display("  RF[2]=%0h RF[3]=%0h RF[4]=%0h RF[5]=%0h", 
                 uut.RF.RF[2], uut.RF.RF[3], uut.RF.RF[4], uut.RF.RF[5]);
      $display("  RF[6]=%0h RF[7]=%0h RF[8]=%0h RF[9]=%0h RF[10]=%0h", uut.RF.RF[6], uut.RF.RF[7], uut.RF.RF[8], uut.RF.RF[9], uut.RF.RF[10]);
      $display(" RF[11] = %0h, RF[12] = %0h", uut.RF.RF[11], uut.RF.RF[12]);
      $display("DM[100]=%0h DM[101]=%0h DM[102]=%0h DM[103]=%0h ",
                uut.DM.data[100], uut.DM.data[101], uut.DM.data[102], uut.DM.data[103]);
      
        $display("");
    end
end
  

  // Test sequence
  initial begin
    reset = 1;
    #10 reset = 0;
    
    repeat(20) @(posedge clock);
    
    // Add these!
    $display("=== CHECKING RESULTS ===");
     $display("x2 = %h (expected 0000006d)", uut.RF.RF[2]);
    $display("x3 = %h (expected 00000011)", uut.RF.RF[3]);
    $display("x4 = %h (expected 00000014)", uut.RF.RF[4]);
    $display("x5 = %h (expected 00000020)", uut.RF.RF[5]);
    $display("x6 = %h (expected 00000031)", uut.RF.RF[6]);
    $display("x7 = %h (expected 00000034)", uut.RF.RF[7]);
    $display("x8 = %h (expected 00FF00FF)", uut.RF.RF[8]);
    $display("x9 = %h (expected 00FF01FF)", uut.RF.RF[9]);
    $display("x10 = %h (expected 00000032)", uut.RF.RF[10]);
    
    if (uut.RF.RF[2] === 32'h6D) $display("PASS: lw x2");
    else $error("FAIL: lw x2");
    
    if (uut.RF.RF[3] === 32'h11) $display("PASS: addi x3, x0, 17");
    else $error("FAIL: addi x3, x0, 17");
    
    if (uut.RF.RF[4] === 32'h14) $display("PASS: addi x4, x3, 3");
    else $error("FAIL: addi x4, x3, 3");
    
    if (uut.RF.RF[5] === 32'h20) $display("PASS: addi x5, x3, 15");
    else $error("FAIL: addi x5, x3, 15");
    
    if (uut.RF.RF[6] === 32'h31) $display("PASS: add x6, x3, x5");
    else $error("FAIL: add x6, x3, x5");
    
    if (uut.RF.RF[7] === 32'h34) $display("PASS: add x7, x4, x5");
    else $error("FAIL: add x7, x4, x5");
    
    if (uut.RF.RF[8] === 32'hFF00FF) $display("PASS: lw x8, 40(x0)");
    else $error("FAIL: lw x8, 40(x0)");
    
    if (uut.RF.RF[9] === 32'hFF01FF) $display("PASS: addi x9, x8, 256");
    else $error("FAIL: addi x9, x8, 256");
    
    if (uut.RF.RF[10] === 32'h32) $display("PASS: addi x10, x0, 50");
    else $error("FAIL: addi x10, x0, 50");
    
    if (uut.DM.data[100] === 8'hFF &&
        uut.DM.data[101] === 8'h01 &&
        uut.DM.data[102] === 8'hFF &&
        uut.DM.data[103] === 8'h00) 
      
      $display("PASS: sw x9, 100(x0)");
    
    else 
      $error("FAIL: sw x9, 100(x0)");
    
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
