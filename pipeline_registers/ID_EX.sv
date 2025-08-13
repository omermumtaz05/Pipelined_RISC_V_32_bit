import cpu_pkg::*;


module ID_EX(
    //standard for all sequential
    input logic clock,
    input logic reset,
    
    input id_ex_data_t data_in,

    input id_ex_control_t control_in,

    output id_ex_data_t data_out,
    
    output id_ex_control_t control_out
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
