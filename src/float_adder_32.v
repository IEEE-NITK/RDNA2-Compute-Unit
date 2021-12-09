`include "floats.vh"
`timescale 1ns / 1ps


module float_adder_32(
    input wire[31:0] A,
    input wire[31:0] B,
    output reg[31:0] out
    );
    
    reg sign_A = A[31];
    reg[7:0] exp_A = A[30:23];
    reg[22:0] fraction_A = A[22:0];
    
    reg sign_B = B[31];
    reg[7:0] exp_B = B[30:23];
    reg[22:0] fraction_B = B[22:0];
    
    reg sign_out;
    reg[7:0] exp_out;
    reg[22:0] fraction_out;
    
    if(exp_A == denorm_32)
    begin
        if (exp_B == denorm_32)
        begin
            //subnormal or denormal addition
            assign exp_out = 8'b0;
        end
        else
        begin
            //mixed addition
        end
    end
    else
    begin
        if (exp_B == denorm_32)
        begin
            //mixed addition
        end
        else
        begin
            //normal addition
        end
    end
    
endmodule
