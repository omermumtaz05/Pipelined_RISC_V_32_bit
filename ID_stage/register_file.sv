module register(
    input clock,
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

    always_comb @ (*)
        begin
            readData1 = RF[readReg1];
            readData2 = RF[readReg2];
        end

endmodule
