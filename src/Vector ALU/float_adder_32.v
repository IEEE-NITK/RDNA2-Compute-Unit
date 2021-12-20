`timescale 1ns / 1ps


module float_adder_32(
    input wire[31:0] A,
    input wire[31:0] B,
    output reg[31:0] out,
    output reg NaN_flag,
    output reg overflow_flag
    );
`include "floats.vh"    
    // For A
    wire sign_A;
    wire[7:0] exp_A;
    wire[22:0] fraction_A;
    // For B
    wire sign_B;
    wire[7:0] exp_B;
    wire[22:0] fraction_B;
    // For output
    reg sign_out;
    reg[7:0] exp_out;
    wire[22:0] fraction_out;
    wire Cout;
    
    //difference of exponents
    wire[7:0] diff_exp;
    wire Borrow;
    
    //mantissa or fraction to be shifted
    reg[22:0] frac_shift;
    //mantissa or fraction that remains same
    reg[22:0] frac_non_shift;
    
    //mantissa or fraction after shifting
    wire[22:0] frac_shifted;
    
    assign sign_A = A[31];
    assign exp_A = A[30:23];
    assign fraction_A = A[22:0];
    
    assign sign_B = B[31];
    assign exp_B = B[30:23];
    assign fraction_B = B[22:0];
    
    subtractor_8b exp(.A(exp_A), .B(exp_B), .diff(diff_exp), .Borrow(Borrow));
    RightShifter shift(.A(frac_shift), .amt(diff_exp), .out(frac_shifted));
    CSA_23b adder(.A(frac_non_shift), .B(frac_shifted), .Sum(fraction_out), .Cout(Cout));
    
always @(*)
    begin
        //checking for positive infinity
        if (A == pos_inf_32)
        begin
        $display("in pos inf");
            if (B == pos_inf_32)
            begin
                out = pos_inf_32;   // inf + inf case
            end
            else if(B == neg_inf_32)
            begin
                sign_out = 1'bX;
                exp_out = nan_exp_32; // inf + -inf case
                NaN_flag = 1'b1;
            end
            else
            begin
                out = pos_inf_32;   // inf + number case
            end
        end
        //checking for negative infinity
        else if (A == neg_inf_32)
        begin
        $display("in neg inf");
            if (B == neg_inf_32)
            begin
                out = neg_inf_32;   // -inf + -inf case
            end
            else if (B == pos_inf_32)
            begin
                sign_out = 1'bX;
                exp_out = nan_exp_32; // -inf + inf case
                NaN_flag = 1'b1;
            end
            else
            begin
                out = neg_inf_32;   // -inf + number case
            end
        end
        else if(B == pos_inf_32)
        begin
        //num + inf case
            out = pos_inf_32;
        end
        else if (B == neg_inf_32)
        begin
        //num - inf case
            out = neg_inf_32;
        end
        // checking for Not a Number
        else if (exp_A == nan_exp_32)
        begin
            exp_out = nan_exp_32;
            $display("in nan");
        end
        else if (exp_B == nan_exp_32)
        begin
            exp_out = nan_exp_32;
        end
        //continuing with normal addition
        else
        begin
        $display("in normal");
            //determinning output exponent and calculatiing exponent difference
            if (Borrow == 1'b1)
            begin
                //exp_B is bigger
                frac_shift = fraction_A;
                frac_non_shift = fraction_B;
            end
            else if (Borrow == 1'b0)
            begin
                //exp_A is bigger
                frac_shift = fraction_B;
                frac_non_shift = fraction_A;
            end
            sign_out = 1'b1;
            out = {sign_out, exp_out, fraction_out};
        end
    end
    
endmodule
