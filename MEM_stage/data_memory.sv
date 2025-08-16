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
