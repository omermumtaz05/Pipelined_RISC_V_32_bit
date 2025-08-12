import cpu_pkg::*;


module ID_EX(
    //standard for all sequential
    input logic clock,
    input logic reset,
    
    input pipeline_data_t data_in,

    input pipeline_control_t control_in,

    output pipeline_data_t data_out,
    
    output pipeline_control_t control_out
);


    always_ff @ (posedge clock)
    if(reset)
        begin
            data_out <= '0;
        
            control_out <= '0;
        end

    else 
        begin        

            data_out <= data_in;

            control_out <= control_in;
        end


endmodule
