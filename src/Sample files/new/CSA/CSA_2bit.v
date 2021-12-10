//Carry Save Adder

`timescale 1ns / 1ps

module CSA(
    input wire[1:0] A,
    input wire[1:0] B,
    output wire[1:0] Sum,
    output wire Cout
    );

wire[2:0] temp_c2, temp_sum1, temp_c1;

assign temp_sum1[2] = 1'b0;
assign temp_c1[0] = 1'b0;

fulladder temp_bit0(.A(A[0]), .B(B[0]), .Cin(1'b0), .Sum(temp_sum1[0]), .Cout(temp_c1[1]));
fulladder temp_bit1(.A(A[1]), .B(B[1]), .Cin(1'b0), .Sum(temp_sum1[1]), .Cout(temp_c1[2]));

//fulladder bit0(.A(temp_sum1[0]), .B(1'b0), .Cin(1'b0), .Sum(temp_sum2[0]), .Cout(temp_c2[0]));
//fulladder bit1(.A(temp_sum1[1]), .B(temp_c1[0]), .Cin(temp_c2[0]), .Sum(temp_sum2[1]), .Cout(temp_c2[1]));
//fulladder bit2(.A(1'b0), .B(temp_c1[1]), .Cin(temp_c2[1]), .Sum(temp_sum2[2]), .Cout(temp_c2[2]));

fulladder bit0(.A(temp_sum1[0]), .B(1'b0), .Cin(1'b0), .Sum(Sum[0]), .Cout(temp_c2[0]));
fulladder bit1(.A(temp_sum1[1]), .B(temp_c1[1]), .Cin(temp_c2[0]), .Sum(Sum[1]), .Cout(temp_c2[1]));
fulladder bit2(.A(1'b0), .B(temp_c1[2]), .Cin(temp_c2[1]), .Sum(Cout), .Cout(temp_c2[2]));
   
endmodule
