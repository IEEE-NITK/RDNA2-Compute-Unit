`timescale 1ns / 1ps

module fulladder(
    input wire A,
    input wire B,
    input wire Cin,
    output reg Sum,
    output reg Cout
    );
    
    always @(*)
    begin
    Sum = A^B^Cin;
    Cout = (A & B) | (B & Cin) | (A & Cin);
    end
    
endmodule
