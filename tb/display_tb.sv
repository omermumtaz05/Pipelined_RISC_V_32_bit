module top_tb();

logic clock;
logic reset;


top_module uut(
	.clock(clock),
	.reset(reset)
);
  
string if_inst, id_inst, ex_inst, mem_inst, wb_inst;
  string if_full, id_full, ex_full, mem_full, wb_full;
  
parameter LW = 7'b0000011,
          SW = 7'b0100011,
          R_type = 7'b0110011,
          BEQ = 7'b1100011,
	      ADDI = 7'b0010011;
  
  
logic if_funct7_bit6;
logic [2:0] if_funct3;
assign if_funct7_bit6 = uut.IM.read_instr[30];
assign if_funct3 = uut.IM.read_instr[14:12];
  
logic id_funct7_bit6;
logic [2:0] id_funct3;
assign id_funct7_bit6 = uut.ifid_data_out.instruc[30];
assign id_funct3 = uut.ifid_data_out.instruc[14:12];

 logic ex_funct7_bit6;
logic [2:0] ex_funct3;
assign ex_funct7_bit6 = uut.idex_data_out.instruc[30];
assign ex_funct3 = uut.idex_data_out.instruc[14:12];

  logic mem_funct7_bit6;
logic [2:0] mem_funct3;
assign mem_funct7_bit6 = uut.exmem_data_out.instruc[30];
assign mem_funct3 = uut.exmem_data_out.instruc[14:12];

 
logic wb_funct7_bit6;
logic [2:0] wb_funct3;
assign wb_funct7_bit6 = uut.memwb_data_out.instruc[30];
assign wb_funct3 = uut.memwb_data_out.instruc[14:12];
  
  
  initial clock = 1;
  always #5 clock = ~clock;  // Toggle every 5 ns ? 10 ns period = 100 MHz
  
  always_comb
    begin
      case(uut.IM.read_instr[6:0])
        LW: if_inst = "lw";
        SW: if_inst = "sw";
        BEQ: if_inst = "beq";
        R_type: 
             begin
                  if(if_funct7_bit6 == 1'b0 && if_funct3 == 3'b0)
                        if_inst = "add";
                  else if(if_funct7_bit6 == 1'b1 && if_funct3 == 3'b0)
                        if_inst = "sub";
                  else if(if_funct7_bit6 == 1'b0 && if_funct3 == 3'b111)
                        if_inst = "and";
                    else if(if_funct7_bit6 == 1'b0 && if_funct3 == 3'b110)
                        if_inst = "or";
                end
            
        ADDI: if_inst = "addi";
        default: if_inst = "0";
        
      endcase
      
      
    end
  
    always_comb
    begin
      case(uut.ifid_data_out.instruc[6:0])
        LW: id_inst = "lw";
        SW: id_inst = "sw";
        BEQ: id_inst = "beq";
        R_type: 
            begin
              if(id_funct7_bit6 == 1'b0 && id_funct3 == 3'b0)
                        id_inst = "add";
                else if(id_funct7_bit6 == 1'b1 && id_funct3 == 3'b0)
                        id_inst = "sub";
                else if(id_funct7_bit6 == 1'b0 && id_funct3 == 3'b111)
                        id_inst = "and";
              else if(id_funct7_bit6 == 1'b0 && id_funct3 == 3'b110)
                        id_inst = "or";
               	else
                      id_inst = "error";
             end
        
        ADDI: id_inst = "addi";
        default: id_inst = "0";
        
      endcase
      
      
    end
  
    always_comb
    begin
      case(uut.idex_data_out.instruc[6:0])
        LW: ex_inst = "lw";
        SW: ex_inst = "sw";
        BEQ: ex_inst = "beq";
         R_type: 
            begin
              if(ex_funct7_bit6 == 1'b0 && ex_funct3 == 3'b0)
                        ex_inst = "add";
                else if(ex_funct7_bit6 == 1'b1 && ex_funct3 == 3'b0)
                        ex_inst = "sub";
                else if(ex_funct7_bit6 == 1'b0 && ex_funct3 == 3'b111)
                        ex_inst = "and";
              else if(ex_funct7_bit6 == 1'b0 && ex_funct3 == 3'b110)
                        ex_inst = "or";
               	else
                      ex_inst = "error";
             end
        ADDI: ex_inst = "addi";
        default: ex_inst = "0";
        
      endcase
      
      
    end
  
    always_comb
    begin
      case(uut.exmem_data_out.instruc[6:0])
        LW: mem_inst = "lw";
        SW: mem_inst = "sw";
        BEQ: mem_inst = "beq";
        R_type: 
            begin
              if(mem_funct7_bit6 == 1'b0 && mem_funct3 == 3'b0)
                        mem_inst = "add";
                else if(mem_funct7_bit6 == 1'b1 && mem_funct3 == 3'b0)
                        mem_inst = "sub";
                else if(mem_funct7_bit6 == 1'b0 && mem_funct3 == 3'b111)
                        mem_inst = "and";
                else if(mem_funct7_bit6 == 1'b0 && mem_funct3 == 3'b110)
                        mem_inst = "or";

             end
        ADDI: mem_inst = "addi";
        default: mem_inst = "0";
        
      endcase
      
      
    end
  
    always_comb
    begin
      case(uut.memwb_data_out.instruc[6:0])
        LW: wb_inst = "lw";
        SW: wb_inst = "sw";
        BEQ: wb_inst = "beq";
        R_type: 
            begin
              if(wb_funct7_bit6 == 1'b0 && wb_funct3 == 3'b0)
                        wb_inst = "add";
                else if(wb_funct7_bit6 == 1'b1 && wb_funct3 == 3'b0)
                        wb_inst = "sub";
                else if(wb_funct7_bit6 == 1'b0 && wb_funct3 == 3'b111)
                        wb_inst = "and";
              else if(wb_funct7_bit6 == 1'b0 && wb_funct3 == 3'b110)
                        wb_inst = "or";

             end
        ADDI: wb_inst = "addi";
        default: wb_inst = "0";
        
      endcase
      
      
    end
  

// IF stage
always_comb begin
      if (uut.if_id_flush) begin
        if_full = "flush";
    end else 
      
    case(uut.IM.read_instr[6:0])
        R_type:
            if_full = $sformatf("%s x%0d, x%0d, x%0d", 
                if_inst,
                uut.IM.read_instr[11:7],
                uut.IM.read_instr[19:15],
                uut.IM.read_instr[24:20]);
        ADDI:
            if_full = $sformatf("%s x%0d, x%0d, %0d", 
                if_inst,
                uut.IM.read_instr[11:7],
                uut.IM.read_instr[19:15],
                $signed(uut.IM.read_instr[31:20]));
        LW:
            if_full = $sformatf("%s x%0d, %0d(x%0d)", 
                if_inst,
                uut.IM.read_instr[11:7],
                $signed(uut.IM.read_instr[31:20]),
                uut.IM.read_instr[19:15]);
        SW:
            if_full = $sformatf("%s x%0d, %0d(x%0d)", 
                if_inst,
                uut.IM.read_instr[24:20],
                $signed({uut.IM.read_instr[31:25], uut.IM.read_instr[11:7]}),
                uut.IM.read_instr[19:15]);
        BEQ:
            if_full = $sformatf("%s x%0d, x%0d, %0d", 
                if_inst,
                uut.IM.read_instr[19:15],
                uut.IM.read_instr[24:20],
                $signed({uut.IM.read_instr[31], uut.IM.read_instr[7], 
                        uut.IM.read_instr[30:25], uut.IM.read_instr[11:8], 1'b0}));
        default: 
            if_full = "nop";
    endcase
end

// ID stage
always_comb 
      begin  
       /*if (uut.stall) 
        id_full = "*** BUBBLE ***"; 
      
       else*/
        case(uut.ifid_data_out.instruc[6:0])
          R_type:
              id_full = $sformatf("%s x%0d, x%0d, x%0d", 
                  id_inst,
                  uut.ifid_data_out.instruc[11:7],
                  uut.ifid_data_out.instruc[19:15],
                  uut.ifid_data_out.instruc[24:20]);
          ADDI:
              id_full = $sformatf("%s x%0d, x%0d, %0d", 
                  id_inst,
                  uut.ifid_data_out.instruc[11:7],
                  uut.ifid_data_out.instruc[19:15],
                  $signed(uut.ifid_data_out.instruc[31:20]));
          LW:
              id_full = $sformatf("%s x%0d, %0d(x%0d)", 
                  id_inst,
                  uut.ifid_data_out.instruc[11:7],
                  $signed(uut.ifid_data_out.instruc[31:20]),
                  uut.ifid_data_out.instruc[19:15]);
          SW:
              id_full = $sformatf("%s x%0d, %0d(x%0d)", 
                  id_inst,
                  uut.ifid_data_out.instruc[24:20],
                  $signed({uut.ifid_data_out.instruc[31:25], uut.ifid_data_out.instruc[11:7]}),
                  uut.ifid_data_out.instruc[19:15]);
          BEQ:
              id_full = $sformatf("%s x%0d, x%0d, %0d", 
                  id_inst,
                  uut.ifid_data_out.instruc[19:15],
                  uut.ifid_data_out.instruc[24:20],
                  $signed({uut.ifid_data_out.instruc[31], uut.ifid_data_out.instruc[7], 
                          uut.ifid_data_out.instruc[30:25], uut.ifid_data_out.instruc[11:8], 1'b0}));
          default: 
              id_full = "nop";
      endcase
end

// EX stage
always_comb  begin
    if (uut.idex_control_out.WB_reg_write == 0 && 
        uut.idex_control_out.M_mem_read == 0 && 
        uut.idex_control_out.M_mem_write == 0 &&
        uut.idex_data_out.instruc[6:0] != 7'b0 &&
        uut.idex_control_out.M_branch == 0) begin
        ex_full = "*** BUBBLE ***";
    end else 
      
    case(uut.idex_data_out.instruc[6:0])
        R_type:
            ex_full = $sformatf("%s x%0d, x%0d, x%0d", 
                ex_inst,
                uut.idex_data_out.instruc[11:7],
                uut.idex_data_out.instruc[19:15],
                uut.idex_data_out.instruc[24:20]);
        ADDI:
            ex_full = $sformatf("%s x%0d, x%0d, %0d", 
                ex_inst,
                uut.idex_data_out.instruc[11:7],
                uut.idex_data_out.instruc[19:15],
                $signed(uut.idex_data_out.instruc[31:20]));
        LW:
            ex_full = $sformatf("%s x%0d, %0d(x%0d)", 
                ex_inst,
                uut.idex_data_out.instruc[11:7],
                $signed(uut.idex_data_out.instruc[31:20]),
                uut.idex_data_out.instruc[19:15]);
        SW:
            ex_full = $sformatf("%s x%0d, %0d(x%0d)", 
                ex_inst,
                uut.idex_data_out.instruc[24:20],
                $signed({uut.idex_data_out.instruc[31:25], uut.idex_data_out.instruc[11:7]}),
                uut.idex_data_out.instruc[19:15]);
        BEQ:
            ex_full = $sformatf("%s x%0d, x%0d, %0d", 
                ex_inst,
                uut.idex_data_out.instruc[19:15],
                uut.idex_data_out.instruc[24:20],
                $signed({uut.idex_data_out.instruc[31], uut.idex_data_out.instruc[7], 
                        uut.idex_data_out.instruc[30:25], uut.idex_data_out.instruc[11:8], 1'b0}));
        default: 
            ex_full = "nop";
    endcase
end

// MEM stage
always_comb begin
    if (uut.exmem_control_out.WB_reg_write == 0 && 
        uut.exmem_control_out.M_mem_read == 0 && 
        uut.exmem_control_out.M_mem_write == 0 &&
        uut.exmem_data_out.instruc[6:0] != 7'b0 &&
        uut.exmem_control_out.M_branch == 0) begin
        mem_full = "*** BUBBLE ***";
    end else
      
      
    case(uut.exmem_data_out.instruc[6:0])
        R_type:
            mem_full = $sformatf("%s x%0d, x%0d, x%0d", 
                mem_inst,
                uut.exmem_data_out.instruc[11:7],
                uut.exmem_data_out.instruc[19:15],
                uut.exmem_data_out.instruc[24:20]);
        ADDI:
            mem_full = $sformatf("%s x%0d, x%0d, %0d", 
                mem_inst,
                uut.exmem_data_out.instruc[11:7],
                uut.exmem_data_out.instruc[19:15],
                $signed(uut.exmem_data_out.instruc[31:20]));
        LW:
            mem_full = $sformatf("%s x%0d, %0d(x%0d)", 
                mem_inst,
                uut.exmem_data_out.instruc[11:7],
                $signed(uut.exmem_data_out.instruc[31:20]),
                uut.exmem_data_out.instruc[19:15]);
        SW:
            mem_full = $sformatf("%s x%0d, %0d(x%0d)", 
                mem_inst,
                uut.exmem_data_out.instruc[24:20],
                $signed({uut.exmem_data_out.instruc[31:25], uut.exmem_data_out.instruc[11:7]}),
                uut.exmem_data_out.instruc[19:15]);
        BEQ:
            mem_full = $sformatf("%s x%0d, x%0d, %0d", 
                mem_inst,
                uut.exmem_data_out.instruc[19:15],
                uut.exmem_data_out.instruc[24:20],
                $signed({uut.exmem_data_out.instruc[31], uut.exmem_data_out.instruc[7], 
                        uut.exmem_data_out.instruc[30:25], uut.exmem_data_out.instruc[11:8], 1'b0}));
        default: 
            mem_full = "nop";
    endcase
end
// WB stage
always_comb begin
    if (uut.memwb_control_out.WB_reg_write == 0 && 
        uut.memwb_control_out.WB_mem_to_reg == 0 &&
        uut.memwb_data_out.instruc[6:0] != 7'b0 &&
       	uut.memwb_control_out.branch == 0) 
        
        	wb_full = "*** BUBBLE ***";
    else 
    case(uut.memwb_data_out.instruc[6:0])
        R_type:
            wb_full = $sformatf("%s x%0d, x%0d, x%0d", 
                wb_inst,
                uut.memwb_data_out.instruc[11:7],
                uut.memwb_data_out.instruc[19:15],
                uut.memwb_data_out.instruc[24:20]);
        ADDI:
            wb_full = $sformatf("%s x%0d, x%0d, %0d", 
                wb_inst,
                uut.memwb_data_out.instruc[11:7],
                uut.memwb_data_out.instruc[19:15],
                $signed(uut.memwb_data_out.instruc[31:20]));
        LW:
            wb_full = $sformatf("%s x%0d, %0d(x%0d)", 
                wb_inst,
                uut.memwb_data_out.instruc[11:7],
                $signed(uut.memwb_data_out.instruc[31:20]),
                uut.memwb_data_out.instruc[19:15]);
        SW:
            wb_full = $sformatf("%s x%0d, %0d(x%0d)", 
                wb_inst,
                uut.memwb_data_out.instruc[24:20],
                $signed({uut.memwb_data_out.instruc[31:25], uut.memwb_data_out.instruc[11:7]}),
                uut.memwb_data_out.instruc[19:15]);
        BEQ:
            wb_full = $sformatf("%s x%0d, x%0d, %0d", 
                wb_inst,
                uut.memwb_data_out.instruc[19:15],
                uut.memwb_data_out.instruc[24:20],
                $signed({uut.memwb_data_out.instruc[31], uut.memwb_data_out.instruc[7], 
                        uut.memwb_data_out.instruc[30:25], uut.memwb_data_out.instruc[11:8], 1'b0}));
        default: 
            wb_full = "nop";
    endcase
end
  

  
 always_ff @(posedge clock) begin
    if (!reset) begin
        $display("=== Cycle %0t ===", $time);
      $display("  PC = %0d", uut.PC_out);
      $display( "IF: %s", if_full);
      $display( "ID: %s", id_full);
      $display( "EX: %s", ex_full);
      $display( "MEM: %s", mem_full);
      $display( "WB: %s", wb_full);
      
      if (uut.memwb_control_out.WB_reg_write && uut.memwb_data_out.rd != 0)
        $display("REG WRITE: x%0d <- %0h", uut.memwb_data_out.rd, uut.memtoreg_mux_out);
      if (uut.exmem_control_out.M_mem_write)
      	$display("MEM WRITE: addr %0d <- %0h", uut.exmem_data_out.ALU_result, uut.exmem_data_out.reg_read_data2);  
      if (uut.exmem_control_out.M_mem_read)
      	$display("MEM READ: addr %0d -> %0h", uut.exmem_data_out.ALU_result, uut.memwb_data_in.read_data);
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
