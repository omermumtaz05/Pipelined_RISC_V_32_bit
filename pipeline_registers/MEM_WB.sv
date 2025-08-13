import cpu_pkg::*;

module MEM_WB(
    // standard sequential
    input clock,
    input reset,

    input mem_wb_data_t data_in,
    input mem_wb_control_t control_in,

    output mem_wb_data_t data_out,
    output mem_wb_control_t control_out

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
