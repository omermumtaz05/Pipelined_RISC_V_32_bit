module forwarding_unit(
    input logic [4:0] id_ex_rs1,
    input logic [4:0] id_ex_rs2,
    input logic [4:0] ex_mem_rd,
    input logic [4:0] mem_wb_rd,

    input logic ex_mem_reg_write,
    input logic mem_wb_reg_write,

    
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);


always_comb 
begin
    begin
        if((ex_mem_rd != 0) && ex_mem_reg_write && (ex_mem_rd == id_ex_rs1))

            forward_a = 2'b10;

        else if((mem_wb_rd != 0) && mem_wb_reg_write 
        && (mem_wb_rd == id_ex_rs1)
        && !(ex_mem_reg_write && (ex_mem_rd != 0) // make sure prev instruction in ex/mem stage doesnt write to/read from same address
        && ex_mem_rd == id_ex_rs1))

            forward_a = 2'b01;

        else
            forward_a = '0;
    end

    begin
        if((ex_mem_rd != 0) && ex_mem_reg_write && (ex_mem_rd == id_ex_rs2))

            forward_b = 2'b10;

        else if((mem_wb_rd != 0) && mem_wb_reg_write 
        && (mem_wb_rd == id_ex_rs2)
        && !(ex_mem_reg_write && (ex_mem_rd != 0) // make sure prev instruction in ex/mem stage doesnt write to/read from same address
        && ex_mem_rd == id_ex_rs2))

            forward_b = 2'b01;

        else
            forward_b = '0;
    end

end



endmodule
