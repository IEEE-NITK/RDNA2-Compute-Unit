`timescale 1ns / 1ps

module RightShift 
#(  parameter BIT_SIZE = 24,
    parameter SHIFT_SIZE = 8)
(
    input [ BIT_SIZE-1:0] A,
    input [ SHIFT_SIZE-1:0] amt,
    output [ BIT_SIZE-1:0] out
    );

assign out = A >> amt;

endmodule
