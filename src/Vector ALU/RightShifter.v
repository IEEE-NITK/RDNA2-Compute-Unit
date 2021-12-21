`timescale 1ns / 1ps

module RightShifter(
    input [23:0] A,
    input [7:0] amt,
    output [23:0] out
    );
    

wire[22:0] temp[7:0];

genvar i,j;
generate
    //0th amt
    for (j=0; j<=22; j=j+1)
    begin
        mux21 mux(.input0(A[j]), .input1(A[j+1]), .sel(amt[0]), .out(temp[0][j]));
    end
    mux21 mux_24b_amt0(.input0(A[23]), .input1(1'b0), .sel(amt[0]), .out(temp[0][23]));
    
    //bits 1 to 7 of amt
    for (i=1; i<=7; i=i+1)
    begin
        for (j=0; j<=22; j=j+1)
        begin
            mux21 mux(.input0(temp[i-1][j]), .input1(temp[i-1][j+1]), .sel(amt[i]), .out(temp[i][j]));
        end
        mux21 mux(.input0(temp[i-1][23]), .input1(1'b0), .sel(amt[i]), .out(temp[i][23]));
    end
endgenerate

endmodule
