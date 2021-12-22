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
    reg[22:0] fraction_out;
    wire[23:0] significand_out;
    wire Cout;
    
    //difference of exponents
    wire[7:0] diff_exp;
    wire Borrow;
    reg[7:0] diff_amt;
    
    //mantissa or fraction to be shifted
    reg[22:0] frac_shift;
    reg[23:0] significand_shift;
    
    //mantissa or fraction that remains same
    reg[22:0] frac_non_shift;
    reg[23:0] significand_non_shift;
    
    //mantissa or fraction after shifting
    wire[23:0] significand_shifted;
    
    assign sign_A = A[31];
    assign exp_A = A[30:23];
    assign fraction_A = A[22:0];
    
    assign sign_B = B[31];
    assign exp_B = B[30:23];
    assign fraction_B = B[22:0];
    
    subtractor_8b sub(.A(exp_A), .B(exp_B), .diff(diff_exp), .Borrow(Borrow));
    RightShiftv2 shift(.A(significand_shift), .amt(diff_amt), .out(significand_shifted));
    CSA_24b adder(.A(significand_non_shift), .B(significand_shifted), .Sum(significand_out), .Cout(Cout));
    
always @(*)
    begin
        NaN_flag <= 1'b0;
        //checking for positive infinity
        if (A == pos_inf_32)
        begin
        $display("in pos inf");
            if (B == pos_inf_32)
            begin
                out <= pos_inf_32;   // inf + inf case
            end
            else if(B == neg_inf_32)
            begin
                NaN_flag <= 1'b1;
                sign_out <= 1'bX;
                exp_out <= nan_exp_32; // inf + -inf case
                out <= {sign_out, exp_out, fraction_out};
                $display("nan case");
            end
            else
            begin
                out <= pos_inf_32;   // inf + number case
            end
        end
        //checking for negative infinity
        else if (A == neg_inf_32)
        begin
        $display("in neg inf");
            if (B == neg_inf_32)
            begin
                out <= neg_inf_32;   // -inf + -inf case
            end
            else if (B == pos_inf_32)
            begin
                NaN_flag <= 1'b1;
                sign_out <= 1'bX;
                exp_out <= nan_exp_32; // -inf + inf case
                out <= {sign_out, exp_out, fraction_out};
                $display("nan case");
            end
            else
            begin
                out <= neg_inf_32;   // -inf + number case
            end
        end
        else if(B == pos_inf_32)
        begin
        //num + inf case
            out <= pos_inf_32;
        end
        else if (B == neg_inf_32)
        begin
        //num - inf case
            out <= neg_inf_32;
        end
        // checking for Not a Number
        else if (exp_A == nan_exp_32)
        begin
            NaN_flag <= 1'b1;
            exp_out <= nan_exp_32;
            out <= {sign_out, exp_out, fraction_out};
            $display("in nan");
        end
        else if (exp_B == nan_exp_32)
        begin
            NaN_flag <= 1'b1;
            exp_out <= nan_exp_32;
            out <= {sign_out, exp_out, fraction_out};
            $display("in nan");
        end
        //continuing with normal addition
        else
        begin
        $display("in normal");
            //determinning output exponent and calculatiing exponent difference
            if (Borrow == 1'b1)
            begin
                
                diff_amt <= 9'd256 - diff_exp;
                
                $display("A shifted, diff_exp = %d, diff_amt = %d", diff_exp, diff_amt);
                $display("exp_A = %d, exp_B = %d", exp_A, exp_B);
                //exp_B is bigger
                frac_shift <= fraction_A;
                significand_shift <= {1'b1, frac_shift};
                
                //frac_non_shift = fraction_B;
                significand_non_shift <= {1'b1, significand_non_shift};
                
                //exponent and sign
                exp_out <= exp_B;
            end
            else if (Borrow == 1'b0)
            begin
                //exp_A is bigger
                diff_amt <= diff_exp;
                $display("B shifted, diff_exp = %d, diff_amt = %d", diff_exp, diff_amt);
                $display("exp_A = %d, exp_B = %d", exp_A, exp_B);
                frac_shift <= fraction_B;
                significand_shift <= {1'b1, frac_shift};
                
                frac_non_shift <= fraction_A;
                significand_non_shift <= {1'b1, frac_non_shift};
                
                exp_out <= exp_A;
            end
            fraction_out <= significand_out[22:0];
            out <= {sign_out, exp_out, fraction_out};
        end
    end
    
endmodule
