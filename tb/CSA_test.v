`timescale 1ns / 1ps

module CSA_test;

reg[1:0] A;
reg[1:0] B;
wire[1:0] Sum;
wire Cout;

CSA temp(.A(A), .B(B), .Sum(Sum), .Cout(Cout));

initial
begin
    #(10);
    A = 2'b10;
    B = 2'b01;
    
    #(10);
    A = 2'b11;
    B = 2'b01;
    
    #(10);
    A = 2'b01;
    B = 2'b10;
    
    #(10);
    A = 2'b00;
    B = 2'b01;
    
    #(10);
    A = 2'b01;
    B = 2'b01;    
    
    #(10);
    A = 2'b01;
    B = 2'b11;
    
    #(10);
    A = 2'b00;
    B = 2'b00;
end

endmodule
