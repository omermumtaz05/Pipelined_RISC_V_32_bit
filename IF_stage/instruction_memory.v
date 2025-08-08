module insrtuction_memory(
    input [31:0]address,
    input clk,
    input reset,
    output reg [31:0] read_instr
);

    reg [7:0] instr [127:0];

    integer i;
    
    always @ (posedge clk)
    begin
       if(reset){
       begin
         	
         	for(i = 128; i < 256; i = i + 1){
                	data[i] <= 8'b0;
            }
       end
       }
       else{
       begin
            read_instr <= {instr[address + 3], instr[address + 2], instr[address + 1], instr[address]};
       end
        }
       
       end




endmodule