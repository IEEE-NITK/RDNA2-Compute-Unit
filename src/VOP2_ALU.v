`include "VOP2.sv"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IEEE NITK
// Engineer: Kruti Deepan Panda
// 
// Create Date: 04.10.2021 18:48:26
// Design Name: ALU
// Module Name: VOP2_ALU
// Project Name: RDNA2 Compute Unit 
//////////////////////////////////////////////////////////////////////////////////


module VOP2_ALU(
input wire instruction[31:0]
    );
    
    wire src0[8:0] = instruction[8:0] ;
    wire vsrc1[7:0]= instruction[16:9] ;
    wire vsrc2[7:0]= instruction[24:7] ;
    wire op[5:0]= instruction[30:25] ;
    
    always @(*)
    begin
        case(op)
            V_CNDMASK_B32   :begin
                                //Conditional mask on each thread. In VOP3 the VCC source may be a
                                //scalar GPR specified in S2.u.
                                //Floating-point modifiers are valid for this instruction if S0.u
                                //and S1.u are 32-bit floating point values. This instruction is
                                //suitable for negating or taking the absolute value of a
                                //floating-point value.
                                //D.u32 = VCC ? S1.u32 : S0.u32.
                            end
            V_DOT2C_F32_F16 :begin
                                //Dot product of packed FP16 values, accumulate with destination.
                                //D.f32 = S0.f16[0] * S1.f16[0] + S0.f16[1] * S1.f16[1] + D.f32.
                            end
            V_ADD_F32       :begin
                                //Add two single-precision values. 0.5ULP precision, denormals are supported.
                                //D.f32 = S0.f32 + S1.f32.
                            end
            V_SUB_F32       :begin
                                //Subtract the second single-precision input from the first input.
                                //D.f32 = S0.f32 - S1.f32.
                            end
            V_SUBREV_F32    :begin
                                //Subtract the first single-precision input from the second input.
                                //D.f32 = S1.f32 - S0.f32.
                            end
            V_MUL_LEGACY_F32:begin
                                //Multiply two single-precision values. Follows DX9 rules where 0.0 times anything produces 0.0 (this is not IEEE compliant).
                                //D.f32 = S0.f32 * S1.f32. // DX9 rules, 0.0*x = 0.0
                            end
            V_MUL_F32       :begin
                                //Multiply two single-precision values. 0.5ULP precision, denormals are supported.
                                //D.f32 = S0.f32 * S1.f32.
                            end
            V_MUL_I32_I24   :begin
                                //Multiply two signed 24-bit integers and store the result as a
                                //signed 32-bit integer. This opcode is as efficient as basic
                                //single-precision opcodes since it utilizes the single-precision
                                //floating point multiplier. See also V_MUL_HI_I32_I24.
                                //D.i32 = S0.i24 * S1.i24.
                            end
            V_MUL_HI_I32_I24:begin
                                //Multiply two signed 24-bit integers and store the high 32 bits
                                //of the result as a signed 32-bit integer. See also
                                //V_MUL_I32_I24.
                                //D.i32 = (S0.i24 * S1.i24)>>32;
                            end
            V_MUL_U32_U24   :begin
                                //Multiply two unsigned 24-bit integers and store the result as an
                                //unsigned 32-bit integer. This opcode is as efficient as basic
                                //single-precision opcodes since it utilizes the single-precision
                                //floating point multiplier. See also V_MUL_HI_U32_U24.
                                //D.u32 = S0.u24 * S1.u24.
                            end
            V_MUL_HI_U32_U24:begin
                                //Multiply two unsigned 24-bit integers and store the high 32 bits
                                //of the result as an unsigned 32-bit integer. See also
                                //V_MUL_U32_U24.
                                //D.u32 = (S0.u24 * S1.u24)>>32.
                            end
            V_DOT4C_I32_I8  :begin
                                //Dot product of packed byte values, accumulate with destination.
                                //D.i32 =
                                //      S0.i8[0] * S1.i8[0] +
                                //      S0.i8[1] * S1.i8[1] +
                                //      S0.i8[2] * S1.i8[2] +
                                //      S0.i8[3] * S1.i8[3] + D.i32.
                            end
            V_MIN_F32       :begin
                                //Compute the minimum of two single-precision floats.
                                //D.f32 = min(S0.f32,S1.f32);
                                //if (IEEE_MODE && S0.f == sNaN)
                                //  D.f = Quiet(S0.f);
                                //else if (IEEE_MODE && S1.f == sNaN)
                                //  D.f = Quiet(S1.f);
                                //else if (S0.f == NaN)
                                //  D.f = S1.f;
                                //else if (S1.f == NaN)
                                //  D.f = S0.f;
                                //else if (S0.f == +0.0 && S1.f == -0.0)
                                //  D.f = S1.f;
                                //else if (S0.f == -0.0 && S1.f == +0.0)
                                //  D.f = S0.f;
                                //else // Note: there's no IEEE special case here like there is for V_MAX_F32.
                                //  D.f = (S0.f < S1.f ? S0.f : S1.f);
                                //endif.
                            end
            V_MAX_F32       :begin
                                //Compute the maximum of two single-precision floats.
                                //D.f32 = max(S0.f32,S1.f32);
                                //if (IEEE_MODE && S0.f == sNaN)
                                //  D.f = Quiet(S0.f);
                                //else if (IEEE_MODE && S1.f == sNaN)
                                //  D.f = Quiet(S1.f);
                                //else if (S0.f == NaN)
                                //  D.f = S1.f;
                                //else if (S1.f == NaN)
                                //  D.f = S0.f;
                                //else if (S0.f == +0.0 && S1.f == -0.0)
                                //  D.f = S0.f;
                                //else if (S0.f == -0.0 && S1.f == +0.0)
                                //  D.f = S1.f;
                                //else if (IEEE_MODE)
                                //  D.f = (S0.f >= S1.f ? S0.f : S1.f);
                                //else
                                //  D.f = (S0.f > S1.f ? S0.f : S1.f);
                                //endif.
                            end
            V_MIN_I32       :begin
                                //Compute the minimum of two signed integers.
                                //D.i32 = (S0.i32 < S1.i32 ? S0.i32 : S1.i32).
                            end
            V_MAX_I32       :begin
                                //Compute the maximum of two signed integers.
                                //D.i32 = (S0.i32 >= S1.i32 ? S0.i32 : S1.i32).
                            end
            V_MIN_U32       :begin
                                //Compute the minimum of two unsigned integers.
                                //D.u32 = (S0.u32 < S1.u32 ? S0.u32 : S1.u32).
                            end
        endcase
    end
    
endmodule
