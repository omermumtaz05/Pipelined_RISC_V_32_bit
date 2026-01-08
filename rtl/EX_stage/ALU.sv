module ALU(
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [3:0] control,
    output logic zero, 
    output logic [31:0] result
);

    always_comb
        begin
            case(control)
                4'b0000: result = A & B;
                4'b0001: result = A | B;
                4'b0010: result = A + B;
                4'b0110: result = A - B;
                default: result = '0;
            endcase
        end

    
    assign zero = (result == 0);
    


endmodule
