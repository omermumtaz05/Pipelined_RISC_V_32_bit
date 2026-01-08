import cpu_pkg::*;

module IF_ID(
    input logic clock,
    input logic reset,
    input logic if_id_write,
    input if_id_data_t data_in,
  
    input if_id_flush,

    output if_id_data_t data_out
);

    always_ff @ (posedge clock)
      if(reset || if_id_flush)
            begin
                data_out <= '0;
            end
      
        
  	else if(if_id_write)
            begin
                data_out <= data_in;

            end
        

endmodule
