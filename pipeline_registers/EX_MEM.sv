import cpu_pkg::*;

module EX_MEM(
    
    input logic clock,
    input logic reset,

    input ex_mem_data_t data_in,

    input ex_mem_control_t control_in,

    output ex_mem_data_t data_out,
    
    output ex_mem_control_t control_out
    
    

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


//Verify!!!
