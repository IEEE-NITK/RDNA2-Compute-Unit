`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IEEE-NITK
// Engineer: Utkarsh M
// 
// Create Date: 25.03.2022 12:29:29
// Design Name: 
// Module Name: Program_Counter
// Project Name: 
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


module Program_Counter(
    input SET_PC,
    input [7:0] PC_IN,
    input clock,
    output reg [7:0] PC_OUT
    );
    always @(posedge clock)begin
    if(SET_PC) PC_OUT <= PC_IN;
    end
endmodule
