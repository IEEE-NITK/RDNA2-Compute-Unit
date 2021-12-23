//Carry Save Adder

`timescale 1ns / 1ps

module CSA_24b(
    input wire[23:0] A,
    input wire[23:0] B,
    output wire[23:0] Sum,
    output wire Cout
    );

wire[24:0] temp_c2, temp_sum1, temp_c1;

assign temp_sum1[24] = 1'b0;
assign temp_c1[0] = 1'b0;

genvar i;
generate
    for (i=0; i<=23; i=i+1)
    begin
        fulladder temp_bit(.A(A[i]), .B(B[i]), .Cin(1'b0), .Sum(temp_sum1[i]), .Cout(temp_c1[(i+1)]));
    end
    
    fulladder bit0(.A(temp_sum1[0]), .B(1'b0), .Cin(1'b0), .Sum(Sum[0]), .Cout(temp_c2[0]));
    
    for (i=1;i<=23;i = i+1)
    begin
        fulladder bit1(.A(temp_sum1[i]), .B(temp_c1[i]), .Cin(temp_c2[(i-1)]), .Sum(Sum[i]), .Cout(temp_c2[i]));
    end
    
    fulladder bit24(.A(1'b0), .B(temp_c1[24]), .Cin(temp_c2[23]), .Sum(Cout), .Cout(temp_c2[24]));
endgenerate
   
endmodule
