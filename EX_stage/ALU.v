module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] control,
    output zero, 
    output reg [31:0] result
);

    always @ (*)
        begin
            case(control)
                4'b0000: result = A & B;
                4'b0001: result = A | B;
                4'b0010: result = A + B;
                4'b0110: result = A - B;
                default: result = 32'b0;
            endcase
        end

    
    assign zero = (result == 0);
    


endmodule


