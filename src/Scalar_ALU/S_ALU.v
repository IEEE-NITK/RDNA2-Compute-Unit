`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IEEE NITK
// Engineer: 
// 
// Create Date: 14.01.2022 03:27:44
// Design Name: Scalar ALU Unit
// Module Name: S_ALU
// Project Name: RDNA2 Compute Unit 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module S_ALU(
    instruction,
    clock
);
// Including Header files
    `include "scalars.vh"
    `include "SOP1.vh"
    `include "SOPK.vh"
// Input 64 bit Instruction. 
    input [31:0] instruction;
   input clock;
   
    wire [6:0] SDST;
    wire [7:0] SSRC1, SSRC0;
    wire [16:0] SIMM;
    wire [6:0] op;
    wire [7:0] SOP1_op;
    wire [7:0] SOPK_op;
    wire [6:0] SOPC_SOPP_op;
    
    assign op = instruction[29:23];
    assign SOP1_op = instruction[15:8];
    assign SOPK_op = instruction[27:23];
    assign SOPC_SOPP_op  = instruction[22:16];
    
    assign SDST = instruction[22:16];
    assign SSRC0 = instruction[7:0];
    assign SSRC1 = instruction[15:8];
    assign SIMM = instruction[15:0];
    
    //select lines s0 and s1 for reading reading values at r0 and r1.
    //select line w0 for writing value(wv) in the register file.
    reg [7:0]s0, s1, w0;
    reg [63:0] wv,  EXEC_in;
    reg en_w, VCCZ_in, en_64, SCC_in,  EXECZ_in;
    wire  [63:0] EXEC_out, r0, r1;
    wire  VCCZ_out, SCC_out, EXECZ_out;
    regFile regFile(.s0(s0), .s1(s1),
                              .w0(w0), .wv(wv),
                               .clock(clock), .en_w(en_w),
                                .r0(r0), .r1(r1),  .en_64(en_64),
                                .VCCZ_in(VCCZ_in), .VCCZ_out(VCCZ_out),
                                .EXECZ_in(EXECZ_in), .EXECZ_out (EXECZ_out),
                                .SCC_in(SCC_in), .SCC_out(SCC_out),
                                .EXEC_in(EXEC_in ), .EXEC_out(EXEC_out 
                                ));
    
    always@(posedge clock)
    begin
    casex(op)
    //ALU operations for SOP1
        {SOP1}: begin
        casex(SOP1_op)
        S_MOV_B32: begin
            
            end
        
        endcase 
        end
    //ALU operations for SOPP
    {SOPP}:begin
        casex(SOPC_SOPP_op)
        
        endcase
    end
    //ALU operations for SOPC
    {SOPC}:begin
        casex(SOPC_SOPP_op)
        
        endcase
    end
    //ALU operations for SOPK
    {SOPK, 3'bxxx}:begin
        casex(SOPK_op)
        
        endcase
    end
    //ALU operations for SOP2
    
    endcase 
    end
    //disabling write enabled
    always @ (negedge clock)
    begin
    en_w <=0;
    end
endmodule
