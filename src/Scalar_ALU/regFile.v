`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IEEE NITK
// Engineer: Utkarsh M
// 
// Create Date: 01/26/2022 06:25:58 PM
// Design Name: register file for Scalar ALU
// Module Name: regFile
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


module regFile(
    input [7:0] s0,
    input [7:0] s1,
    input [7:0] w0,
    input [63:0] wv,
    input clock,
    input en_w,
    input en_64,
    input VCCZ_in,
    input EXECZ_in,
    input  SCC_in,
    input [63:0] EXEC_in,
    output reg [63:0] EXEC_out,
    output reg  [63:0] r0,
    output reg[63:0] r1,
    output reg VCCZ_out,
    output reg EXECZ_out,
    output reg SCC_out
    );
    reg [31:0] register [255:0];
    always @ (posedge clock)
    begin
        if(!s0==8'hFF) begin
        r0 <= {register[s0 +1], register[s0]};
        end else begin
        r0 <= {32'bx, register[s0]};
        end
        if(!s1==8'hFF) begin
        r1 <= {register[s1 + 1]+register[s1]};
        end else begin
        r0 <= {32'bx, register[s0]};
        end
        //writing write value to register except for read only values.
        if(en_w && (!(w0==8'h7d || (w0>=8'h80&&w0<=8'he8)|| (w0>=8'hF0 && w0<=8'hf8)))) begin
            if(en_64) begin
            {register[w0+1], register[w0]} <= wv;
            end 
            else begin
            register[w0] <= wv[31:0];
            end
        end
        
       //reading and writing VCCZ, SCC, and EXECZ.
       VCCZ_out <= register[8'hfb][0];
       register[8'hfb] <= {30'b0, VCCZ_in};
       SCC_out <= register[8'hfc][0];
       register[8'hfc] <= {30'b0, SCC_in};
       EXECZ_out <= register[8'hfd][0];
       register[8'hfd] <= {30'b0, EXECZ_in};
       //handling exec
       EXEC_out <= {register[8'h7f], register[8'h7e]};
       if(EXECZ_in) register[8'h7f] <=EXEC_in; 
    end
endmodule
