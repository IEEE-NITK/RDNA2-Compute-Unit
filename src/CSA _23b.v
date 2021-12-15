//Carry Save Adder

`timescale 1ns / 1ps

module CSA_23b(
    input wire[22:0] A,
    input wire[22:0] B,
    output wire[22:0] Sum,
    output wire Cout
    );

wire[32:0] temp_c2, temp_sum1, temp_c1;

assign temp_sum1[23] = 1'b0;
assign temp_c1[0] = 1'b0;

genvar i;
generate
    for (i=0; i<=22; i=i+1)
    begin
        fulladder temp_bit(.A(A[i]), .B(B[i]), .Cin(1'b0), .Sum(temp_sum1[i]), .Cout(temp_c1[(i+1)]));
    end
    
    fulladder bit0(.A(temp_sum1[0]), .B(1'b0), .Cin(1'b0), .Sum(Sum[0]), .Cout(temp_c2[0]));
    
    for (i=1;i<=22;i = i+1)
    begin
        fulladder bit1(.A(temp_sum1[i]), .B(temp_c1[i]), .Cin(temp_c2[(i-1)]), .Sum(Sum[i]), .Cout(temp_c2[i]));
    end
    
    fulladder bit32(.A(1'b0), .B(temp_c1[32]), .Cin(temp_c2[22]), .Sum(Cout), .Cout(temp_c2[32]));
endgenerate
   
endmodule
