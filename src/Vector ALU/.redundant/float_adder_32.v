`timescale 1ns / 1ps

module float_adder_32(
    input wire[31:0] A,
    input wire[31:0] B,
    output reg[31:0] out,
    output reg NaN_flag,
    output reg overflow_flag,
    output reg neg_flag
    );
    
function [23:0] complement2 (   input hidden_bit,
                                input [22:0] fraction);
    begin
        complement2 = ~{hidden_bit, fraction} + 1;
    end
endfunction
    
`include "floats.vh"    
    // For A --------------------------------------------------------------------------------------------------------------------------------------
    wire sign_A;
    wire[7:0] exp_A;
    wire[22:0] fraction_A;
    reg hidden_bit_A;
    reg[23:0] significand_A;
    
    // For B --------------------------------------------------------------------------------------------------------------------------------------
    wire sign_B;
    wire[7:0] exp_B;
    wire[22:0] fraction_B;
    reg hidden_bit_B;
    reg[23:0] significand_B;
    
    // For output --------------------------------------------------------------------------------------------------------------------------------------
    reg sign_out;
    reg[7:0] exp_out;
    reg[22:0] fraction_out;
    wire[23:0] significand_out;
    wire Cout;
    
    //normalized outputs --------------------------------------------------------------------------------------------------------------------------------------
    wire[23:0] norm_significand;
    wire[7:0] norm_exp;
    
    //difference of exponents --------------------------------------------------------------------------------------------------------------------------------------
    wire[7:0] diff_exp;
    wire Borrow;
    reg[7:0] diff_amt;
    
    //mantissa or fraction to be shifted --------------------------------------------------------------------------------------------------------------------------------------
    reg[22:0] frac_shift;
    reg[23:0] significand_shift;
    
    //mantissa or fraction that remains same --------------------------------------------------------------------------------------------------------------------------------------
    reg[22:0] frac_non_shift;
    reg[23:0] significand_non_shift;
    
    //mantissa or fraction after shifting --------------------------------------------------------------------------------------------------------------------------------------
    wire[23:0] significand_shifted;
    
    assign sign_A = A[31];
    assign exp_A = A[30:23];
    assign fraction_A = A[22:0];
    
    assign sign_B = B[31];
    assign exp_B = B[30:23];
    assign fraction_B = B[22:0];
    
    subtractor_8b sub(.A(exp_A), .B(exp_B), .diff(diff_exp), .Borrow(Borrow));
    RightShift shift(.A(significand_shift), .amt(diff_amt), .out(significand_shifted));
    CSA_24b adder(.A(significand_non_shift), .B(significand_shifted), .Sum(significand_out), .Cout(Cout));
    normalizer norm(.significand(significand_out), .exp(exp_out), .cout(Cout), .neg_flag(neg_flag), .norm_sig(norm_significand), .norm_exp(norm_exp));
    
    reg [23:0] temp_comp ;
    
always @(*)
    begin
        // checking denormal cases --------------------------------------------------------------------------------------------------------
        if (exp_A == denorm_32)
        begin
            hidden_bit_A <= 1'b0;        
        end
        else
        begin
            hidden_bit_A <= 1'b1;
        end
        
        if (exp_B == denorm_32)
        begin
            hidden_bit_B <= 1'b0;
        end
        else
        begin
            hidden_bit_B <= 1'b1;
        end
    
        NaN_flag <= 1'b0;
        //checking for positive infinity --------------------------------------------------------------------------------------------------------
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
        //checking for negative infinity --------------------------------------------------------------------------------------------------------
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
         // --------------------------------------------------------------------------------------------------------
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
        // checking for Not a Number --------------------------------------------------------------------------------------------------------
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
        //continuing with addition --------------------------------------------------------------------------------------------------------
        else
        begin
        $display("in normal");
        
            if (sign_A == sign_B)
            begin
            $display("same sign");
                neg_flag <= 1'b0;
                sign_out <= sign_A;
                
                significand_A = { hidden_bit_A, fraction_A};
                significand_B = { hidden_bit_B, fraction_B};
            end
            // diff sign            
            else if (sign_A != sign_B)
            begin
            $display("diff sign");
                neg_flag <= 1'b1;
                if (sign_A == 1'b1)
                begin
                    significand_A = complement2(hidden_bit_A, fraction_A);
                end
                else if(sign_B == 1'b1)
                begin
                    significand_B = complement2(hidden_bit_B, fraction_B);
                end
            end

            //determinning output exponent and calculatiing exponent difference
            if (Borrow == 1'b1)
            begin
                
                diff_amt <= 9'd256 - diff_exp;
                
                sign_out = sign_B;
                
                $display("A shifted, diff_exp = %d, diff_amt = %d", diff_exp, diff_amt);
                $display("exp_A = %d, exp_B = %d", exp_A, exp_B);
                //exp_B is bigger
                //frac_shift <= fraction_A;
                //significand_shift <= {hidden_bit_A, frac_shift};
                significand_shift = significand_A;
                
                //frac_non_shift = fraction_B;
                //significand_non_shift <= { hidden_bit_B, significand_non_shift};
                significand_non_shift = significand_B;
                
                //exponent and sign
                exp_out <= exp_B;
            end
            else if (Borrow == 1'b0)
            begin
                
                sign_out = sign_A;
                
                //exp_A is bigger
                diff_amt <= diff_exp;
                $display("B shifted, diff_exp = %d, diff_amt = %d", diff_exp, diff_amt);
                $display("exp_A = %d, exp_B = %d", exp_A, exp_B);
                
                //frac_shift <= fraction_B;
                //significand_shift <= { hidden_bit_B, frac_shift};
                significand_shift = significand_B;
                
                //frac_non_shift <= fraction_A;
                //significand_non_shift <= { hidden_bit_A, frac_non_shift};
                significand_non_shift = significand_A;
                
                exp_out = exp_A;
            end        
            
            fraction_out = norm_significand[22:0];
            out = {sign_out, norm_exp, fraction_out};
        end
    end
    
endmodule