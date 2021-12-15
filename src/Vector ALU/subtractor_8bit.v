`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module subtractor_8b(

    input [7:0] A,
    input [7:0] B,
    output [7:0] diff,
    output Borrow
    );
	 
wire [7:0] w;

HalfSubtractor H1(A[0],B[0],diff[0],w[0]);
FullSubtractor F1(A[1],B[1],w[0],diff[1],w[1]);
FullSubtractor F2(A[2],B[2],w[1],diff[2],w[2]);
FullSubtractor F3(A[3],B[3],w[2],diff[3],w[3]);
FullSubtractor F4(A[4],B[4],w[3],diff[4],w[4]);
FullSubtractor F5(A[5],B[5],w[4],diff[5],w[5]);
FullSubtractor F6(A[6],B[6],w[5],diff[6],w[6]);
FullSubtractor F7(A[7],B[7],w[6],diff[7],w[7]);

assign Borrow=w[7];

endmodule