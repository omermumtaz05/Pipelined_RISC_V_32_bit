//IF/ID register:


import cpu_pkg::*;

module IF_ID(
    input logic clock,
    input logic reset,
    input logic if_id_write,
    input if_id_data_t data_in,

    output if_id_data_t data_out
);

    always_ff @ (posedge clock)
      if(reset)
            begin
                data_out <= '0;
            end
      
        
        else if(if_id_write)
            begin
                data_out <= data_in;

            end
        

endmodule



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
