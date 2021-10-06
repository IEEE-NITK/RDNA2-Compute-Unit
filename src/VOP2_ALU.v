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
        endcase
    end
    
endmodule
