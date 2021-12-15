`timescale 1ns / 1ps
module float_adder_test;

reg[31:0] A;
reg[31:0] B;
wire[31:0] out;

float_adder_32 test(.A(A), .B(B), .out(out));

initial
begin

    #(10);
    A = 32'b01111111100000000000000000000000;
    B = 31'b0;
    $display("A = %d, B = %d, out %d", A, B, out);

end

endmodule