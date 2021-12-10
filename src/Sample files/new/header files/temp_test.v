`timescale 1ns / 1ps

module temp_test(
input wire[31:0] test,
output reg[31:0] boop
    );
   
    always @(*)
    begin
        boop = test;
    end
endmodule
