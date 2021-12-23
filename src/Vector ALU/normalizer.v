`timescale 1ns / 1ps

module normalizer(
    input [23:0] significand,
    input [7:0] exp,
    input cout,
    output reg [23:0] norm_sig,
    output reg [7:0] norm_exp
    );
    
    wire[24:0] temp;
    wire[24:0] temp_sig;
    
    assign temp = {cout, significand};
    assign temp_sig = temp >> 1;    
    
    always @(*)
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
    
endmodule
