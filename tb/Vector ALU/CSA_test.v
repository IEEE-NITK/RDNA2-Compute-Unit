`timescale 1ns / 1ps

module CSA_test;

reg[31:0] A;
reg[31:0] B;
wire[31:0] Sum;
wire Cout;

CSA temp(.A(A), .B(B), .Sum(Sum), .Cout(Cout));

initial
begin
    #(10);
    A = 32'd10;
    B = 32'd01;
    #(10);
    $display("A = %d, B = %d, Sum = %d, Cout = %d", A, B, Sum, Cout);
    
    #(10);
    A = 32'd200;
    B = 32'd6969;
    #(10);
    $display("A = %d, B = %d, Sum = %d, Cout = %d", A, B, Sum, Cout);
    
    #(10);
    A = 32'hffffffff;
    B = 32'd01;
    #(10);
    $display("A = %d, B = %d, Sum = %d, Cout = %d", A, B, Sum, Cout);
    
end

endmodule
