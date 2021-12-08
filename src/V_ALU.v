`include "VOP2.v"
`include "VOP1.v"
`include "Vdefines.sv"
`include "defines.v"
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


module V_ALU(
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
            V_MAX_U32       :begin
                                //Compute the maximum of two unsigned integers.
                                //D.u32 = (S0.u32 >= S1.u32 ? S0.u32 : S1.u32).
                            end
            V_LSHRREV_B32   :begin
                                //Logical shift right with shift count in the first operand.
                                //D.u32 = S1.u32 >> S0[4:0].
                            end
            V_LSHLREV_B32   :begin
                                //Logical shift left with shift count in the first operand.
                                //D.u32 = S1.u32 << S0[4:0].
                            end
            V_AND_B32      :begin
                                //Bitwise AND. Input and output modifiers not supported.
                                //D.u32 = S0.u32 & S1.u32.
                            end
            V_OR_B32       :begin
                                //Bitwise OR. Input and output modifiers not supported.
                                //D.u32 = S0.u32 | S1.u32.
                            end
            V_XOR_B32      :begin
                                //Bitwise XOR. Input and output modifiers not supported.
                                //D.u32 = S0.u32 ^ S1.u32.
                            end
            V_XNOR_B32      :begin
                                //Bitwise XNOR. Input and output modifiers not supported.
                                //D.u32 = ~(S0.u32 ^ S1.u32).
                            end
            V_ADD_NC_U32    :begin
                                //Add two unsigned integers. No carry-in or carry-out.
                                //D.u32 = S0.u32 + S1.u32.
                            end
            V_SUB_NC_U32    :begin
                                //Subtract the second unsigned integer from the first unsigned integer. No carry-in or carry-out.
                                //D.u32 = S0.u32 - S1.u32.
                            end
            V_SUBREV_NC_U32 :begin
                                //Subtract the first unsigned integer from the second unsigned integer. No carry-in or carry-out.
                                //D.u32 = S1.u32 - S0.u32.
                            end
            V_ADD_CO_CI_U32 :begin
                                //Add two unsigned integers and a carry-in from VCC. Store the
                                //result and also save the carry-out to VCC. In VOP3 the VCC
                                //destination may be an arbitrary SGPR-pair, and the VCC source
                                //comes from the SGPR-pair at S2.u.
                                //D.u32 = S0.u32 + S1.u32 + VCC;
                                //VCC = S0.u32 + S1.u32 + VCC >= 0x100000000ULL ? 1 : 0.
                            end
            V_SUB_CO_CI_U32 :begin
                                //Subtract the second unsigned integer from the first unsigned
                                //integer and then subtract a carry-in from VCC. Store the result
                                //and also save the carry-out to VCC. In VOP3 the VCC destination
                                //may be an arbitrary SGPR-pair, and the VCC source comes from the
                                //SGPR-pair at S2.u.
                                //D.u32 = S0.u32 - S1.u32 - VCC;
                                //VCC = S1.u32 + VCC > S0.u32 ? 1 : 0.
                            end
            V_FMAC_F32      :begin
                                //Fused multiply-add of single-precision floats, accumulate with destination.
                                //D.f32 = S0.f32 * S1.f32 + D.f32. // Fused operation
                            end
            V_FMAMK_F32     :begin
                                //Multiply a single-precision float with a literal constant and
                                //add a second single-precision float using fused multiply-add.
                                //This opcode cannot use the VOP3 encoding and cannot use input/output modifiers.
                                //D.f32 = S0.f32 * K.f32 + S1.f32. // K is a 32-bit literal constant.
                            end
            V_FMAAK_F32     :begin
                                //Multiply two single-precision floats and add a literal constant
                                //using fused multiply-add. This opcode cannot use the VOP3
                                //encoding and cannot use input/output modifiers.
                                //D.f32 = S0.f32 * S1.f32 + K.f32. // K is a 32-bit literal constant.
                            end
            V_ADD_F16       :begin
                                //Add two FP16 values. 0.5ULP precision. Supports denormals,
                                //round mode, exception flags and saturation.
                                //D.f16_lo = S0.f16_lo + S1.f16_lo.
                            end
            V_SUB_F16       :begin
                                //Subtract the second FP16 value from the first.
                                //0.5ULP precision, Supports denormals, round mode, exception flags and saturation.
                                //D.f16_lo = S0.f16_lo - S1.f16_lo.
                            end
            V_SUBREV_F16    :begin
                                //Subtract the first FP16 value from the second.
                                //0.5ULP precision. Supports denormals, round mode, exception flags and saturation
                                //D.f16_lo = S1.f16_lo - S0.f16_lo
                            end
            V_MUL_F16       :begin
                                //Multiply two FP16 values. 0.5ULP precision. Supports denormals, round mode, exception flags and saturation.
                                //D.f16_lo = S0.f16_lo * S1.f16_lo.
                            end
            V_FMAC_F16      :begin
                                //Fused multiply-add of FP16 values, accumulate with destination.
                                //0.5ULP precision. Supports denormals, round mode, exception flags and saturation.
                                //D.f16_lo = S0.f16_lo * S1.f16_lo + D.f16_lo.
                            end
            V_FMAMK_F16     :begin
                                //Multiply a FP16 value with a literal constant and add a second
                                //FP16 value using fused multiply-add. This opcode cannot use the
                                //VOP3 encoding and cannot use input/output modifiers. Supports
                                //round mode, exception flags, saturation.
                                //D.f16_lo = S0.f16_lo * K.f16_lo + S1.f16_lo.
                                // K is a 32-bit literal constant stored in the following literal DWORD.
                            end
            V_FMAAK_F16     :begin
                                //Multiply two FP16 values and add a literal constant using fused
                                //multiply-add. This opcode cannot use the VOP3 encoding and
                                //cannot use input/output modifiers. Supports round mode, exception flags, saturation.
                                //D.f16_lo = S0.f16_lo * S1.f16_lo + K.f16_lo.
                                // K is a 32-bit literal constant stored in the following literal DWORD.
                            end
            V_MAX_F16       :begin
                                //Maximum of two FP16 values. IEEE compliant. Supports
                                //denormals, round mode, exception flags, saturation.
                                //D.f16 = max(S0.f16,S1.f16);
                                //if (IEEE_MODE && S0.f16 == sNaN)
                                //  D.f16 = Quiet(S0.f16);
                                //else if (IEEE_MODE && S1.f16 == sNaN)
                                //  D.f16 = Quiet(S1.f16);
                                //else if (S0.f16 == NaN)
                                //  D.f16 = S1.f16;
                                //else if (S1.f16 == NaN)
                                //  D.f16 = S0.f16;
                                //else if (S0.f16 == +0.0 && S1.f16 == -0.0)
                                //  D.f16 = S0.f16;
                                //else if (S0.f16 == -0.0 && S1.f16 == +0.0)
                                //  D.f16 = S1.f16;
                                //else if (IEEE_MODE)
                                //  D.f16 = (S0.f16 >= S1.f16 ? S0.f16 : S1.f16);
                                //else
                                //  D.f16 = (S0.f16 > S1.f16 ? S0.f16 : S1.f16);
                                //endif.
                            end
            V_MIN_F16       :begin
                                //Minimum of two FP16 values. IEEE compliant. Supports
                                //denormals, round mode, exception flags, saturation.
                                //D.f16 = min(S0.f16,S1.f16);
                                //if (IEEE_MODE && S0.f16 == sNaN)
                                //  D.f16 = Quiet(S0.f16);
                                //else if (IEEE_MODE && S1.f16 == sNaN)
                                //  D.f16 = Quiet(S1.f16);
                                //else if (S0.f16 == NaN)
                                //  D.f16 = S1.f16;
                                //else if (S1.f16 == NaN)
                                //  D.f16 = S0.f16;
                                //else if (S0.f16 == +0.0 && S1.f16 == -0.0)
                                //  D.f16 = S1.f16;
                                //else if (S0.f16 == -0.0 && S1.f16 == +0.0)
                                //  D.f16 = S0.f16;
                                //else // Note: there's no IEEE special case here like there is for V_MAX_F16.
                                //  D.f16 = (S0.f16 < S1.f16 ? S0.f16 : S1.f16);
                                //endif.
                            end
            V_LDEXP_F16     :begin
                                //Multiply an FP16 value by an integral power of 2, compare with
                                //the ldexp() function in C. Note that the S1 has a format of f16
                                //since floating point literal constants are interpreted as 16 bit
                                //value for this opcode.
                                //D.f16 = S0.f16 * (2 ** S1.i16).
                            end
            V_FMAC_LEGACY_F32:begin
                                //Multiply two single-precision values and accumulate the result
                                //with the destination. Follows DX9 rules where 0.0 times
                                //anything produces 0.0 (this is not IEEE compliant).
                                //D.f32 = S0.f32 * S1.f32 + S2.f32. // DX9 rules, 0.0 * x = 0.compliant 
                            end
            V_ASHRREV_I32   :begin
                                //Arithmetic shift right (preserve sign bit) with shift count in the first operand.
                                //D.i32 = S1.i32 >> S0[4:0]. 
                            end
            V_SUBREV_CO_CI_U32:begin
                                //Subtract the first unsigned integer from the second unsigned
                                //integer and then subtract a carry-in from VCC. Store the result
                                //and also save the carry-out to VCC. In VOP3 the VCC destination
                                //may be an arbitrary SGPR-pair, and the VCC source comes from the
                                //SGPR-pair at S2.u.
                                //D.u32 = S1.u32 - S0.u32 - VCC;
                                //VCC = S1.u32 + VCC > S0.u ? 1 : 0. 
                            end
            V_CVT_PKRTZ_F16_F32:begin
                                //Convert two single-precision floats into a packed FP16 result
                                //and round to zero (ignore the current rounding mode).
                                //This opcode is intended for use with 16-bit compressed exports.
                                //See V_CVT_F16_F32 for a version that respects the current
                                //rounding mode.
                                //D.f16_lo = f32_to_f16(S0.f32);
                                //D.f16_hi = f32_to_f16(S1.f32).
                                // Round-toward-zero regardless of current round mode setting in hardware.
                              end      
            V_PK_FMAC_F16    :begin
                                //Convert two single-precision floats into a packed FP16 result
                                //and round to zero (ignore the current rounding mode).
                                //This opcode is intended for use with 16-bit compressed exports.
                                //See V_CVT_F16_F32 for a version that respects the current
                                //rounding mode.
                                //D.f16_lo = f32_to_f16(S0.f32);
                                //D.f16_hi = f32_to_f16(S1.f32).
                                // Round-toward-zero regardless of current round mode setting in hardware.
                              end                      
        endcase
    end
    
endmodule
