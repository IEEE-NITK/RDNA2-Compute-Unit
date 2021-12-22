`timescale 1ns / 1ps

module RightShiftv2(
    input [23:0] A,
    input [7:0] amt,
    output [23:0] out
    );

assign out = A >> amt;

endmodule
