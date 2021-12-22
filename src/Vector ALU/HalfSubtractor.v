`timescale 1ns / 1ps

module HalfSubtractor(
    input wire A,
    input wire B,
    output reg D,
    output reg Bout
    );
	 
always @(*)
begin
    D <= A^B;
    Bout <= (~A) & B;
end

endmodule