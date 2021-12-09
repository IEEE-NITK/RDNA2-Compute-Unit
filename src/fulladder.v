`timescale 1ns / 1ps

module fulladder(
    input wire A,
    input wire B,
    input wire Cin,
    output reg Sum,
    output reg Cout
    );
    
    assign Sum = A^B^Cin;
    assign Cout = (A & B) | (B & Cin) | (A & Cin);
    
endmodule
