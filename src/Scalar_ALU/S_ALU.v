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
    instruction
);
// Including Header files
    `include "scalars.vh"
    `include "SOP1.vh"
    `include "SOPK.vh"
// Input 64 bit Instruction. 
    input [31:0] instruction;
   
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
    
    always@(instruction)
    begin
    casex(op)
    //ALU operations for SOP1
        {SOP1}: begin
        casex(SOP1_op)
        
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
endmodule
