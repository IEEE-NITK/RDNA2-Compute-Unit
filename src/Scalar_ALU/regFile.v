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
    output [63:0] EXEC_out,
    output [63:0] r0,
    output [63:0] r1,
    output VCCZ_out,
    output EXECZ_out,
    output SCC_out
    );
    reg [31:0] register [255:0];
    
    assign r0 = (!s0==8'hFF) ? {register[s0 +1], register[s0]}: {32'bx, register[s0]};
    assign r1 = (!s1==8'hFF)? {register[s1 + 1]+register[s1]}: {32'bx, register[s0]};
    assign VCCZ_out = register[8'hfb][0];
    assign SCC_out = register[8'hfc][0];
    assign EXECZ_out = register[8'hfd][0];
    assign EXEC_out = {register[8'h7f], register[8'h7e]};
    
    //assigning constant values 
    // positive ingtegers
  
  
    //negative integers
    
    
    //writing data to registers      
    always @ (posedge clock)
    begin
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
       //VCC
       register[8'hfb] <= {30'b0, VCCZ_in};
       //SCC
       register[8'hfc] <= {30'b0, SCC_in};
       //EXECZ
       register[8'hfd] <= {30'b0, EXECZ_in};
       //exec
       if(EXECZ_in) register[8'h7f] <=EXEC_in; 
    end
endmodule
