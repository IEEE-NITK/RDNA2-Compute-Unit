//Carry Save Adder

`timescale 1ns / 1ps

module CSA(
    input wire A[1:0],
    input wire B[1:0],
    output reg Sum[1:0],
    output reg Cout[1:0]
    );
    
reg temp_sum[2:0];
reg temp_carry[2:0];

//fulladder bit0(.A(A), .B(B), .Sum(temp_sum[0]), .Cout(temp_carry[1]));
//fulladder bit1(.A(A), .B(B), .Sum(temp_sum[1]), .Cout(temp_carry[2]));

genvar i;
generate
for (i=0; i<=2; i = i +1)
begin
    fulladder bit_orig(.A(A), .B(B), .Sum(temp_sum[i]), .Cout(temp_carry[(i+1)]));
end
endgenerate

assign temp_carry[0] = 1'b0;
assign temp_sum[2] = 1'b0;


    
endmodule
