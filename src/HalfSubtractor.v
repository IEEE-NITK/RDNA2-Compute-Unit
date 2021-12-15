`timescale 1ns / 1ps

module HalfSubtractor(
    input A,
    input B,
    output D,
    output Bout
    );
	 
xor(D,A,B);
and(Bout,~A,B);

endmodule