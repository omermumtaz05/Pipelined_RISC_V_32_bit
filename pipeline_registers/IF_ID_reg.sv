// Code your design here
// Code your design here

module IF_ID(
    input logic clock,
    input logic reset,
    
    input logic [31:0] input_pc_address,
    input logic [31:0] input_instruc,

    output logic [31:0] out_pc_address,
    output logic [31:0] output_instruc
);

    always_ff @ (posedge clock)
      if(reset)
            begin
                out_pc_address <= '0;
                output_instruc <= '0;
            end
      
        
        else
            begin
                out_pc_address <= input_pc_address;
                output_instruc <= input_instruc;

            end
        

endmodule

//verify!!
