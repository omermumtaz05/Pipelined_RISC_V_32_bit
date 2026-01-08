import cpu_pkg::*;

module control_mux(
    input id_ex_control_t all_control_in,

    input logic stall,

    output id_ex_control_t ctrl_mux_out

);

assign ctrl_mux_out = (stall) ? '0: all_control_in;


endmodule
