module hazard_detection(
    input logic id_ex_mem_read,
    input logic [4:0] id_ex_rd,
    input logic [4:0] if_id_rs1,
    input logic [4:0] if_id_rs2,


    output logic PCWrite,
    output logic if_id_write,
    output logic control_mux_sig
);


always_comb
begin

    if(id_ex_mem_read &&
    id_ex_rd == if_id_rs1 &&
    id_ex_rd ==  if_id_rs2)

        begin

            PCWrite = 0;
            if_id_write = 0;
            control_mux_sig = 1; // input 0 into all control signals

        end

    else 
    // regular instruction flow
        begin

            PCWrite = 1;
            if_id_write = 1;
            control_mux_sig = 0; //
            
        end


end

endmodule
