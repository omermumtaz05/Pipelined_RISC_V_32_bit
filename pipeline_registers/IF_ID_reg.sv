import cpu_pkg::*;

module IF_ID(
    input logic clock,
    input logic reset,
    
    input if_id_data_t data_in,

    output if_id_data_t data_out
);

    always_ff @ (posedge clock)
      if(reset)
            begin
                data_out <= '0;
            end
      
        
        else
            begin
                data_out <= data_in;

            end
        

endmodule

//verify!!
