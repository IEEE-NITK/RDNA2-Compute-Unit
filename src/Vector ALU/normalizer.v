`timescale 1ns / 1ps

module normalizer(
    input [23:0] significand,
    input [7:0] exp,
    input cout,
    input neg_flag,
    output reg [23:0] norm_sig,
    output reg [7:0] norm_exp
    );
    
    wire[24:0] temp;
    wire[24:0] temp_sig;
    
    reg[7:0] temp_z;
    
    assign temp = {cout, significand};
    assign temp_sig = temp >> 1;    
    
    always @(*)
    begin
        if (neg_flag == 1'b0)
        begin
            if (cout == 1'b1)
            begin
                norm_sig <= temp[23:0];
                norm_exp <= exp + 1;
            end    
            else
            begin
                norm_sig <= significand;
                norm_exp <= exp;
            end
        end
        else if (neg_flag == 1'b1)
        begin
            if (cout == 1'b1)
            begin
                norm_sig = significand;
                temp_z = 8'b0;
                while (norm_sig[23] != 1'b1)
                begin
                    norm_sig = norm_sig << 1;
                    temp_z = temp_z + 1'b1;
                end
                
                norm_exp = exp - temp_z;
            end    
            else
            begin
                norm_sig <= ~(significand) + 1;
                norm_exp <= exp;
            end
        end
    end
    
endmodule
