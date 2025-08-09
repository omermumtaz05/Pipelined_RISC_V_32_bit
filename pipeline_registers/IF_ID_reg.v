// Code your design here
module IF_ID(
    input clock,
    input reset,
    
    input [31:0] input_pc_address,
    input [31:0] input_instruc,

    output reg [31:0] out_pc_address,
    output reg [31:0] output_instruc
);

    always @ (posedge clock)
      if(reset)
            begin
                out_pc_address <= 32'b0;
                output_instruc <= 32'b0;
            end
      
        
        else
            begin
                out_pc_address <= input_pc_address;
                output_instruc <= input_instruc;

            end
        

endmodule

//verify!!
