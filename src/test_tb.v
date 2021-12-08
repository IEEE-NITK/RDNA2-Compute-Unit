`timescale 1ns / 1ps

module test_tb;
`include "Vdefines.sv"

reg[31:0] test;
wire[31:0] boop;

temp_test m(.test(test),
            .boop(boop));
               
initial
begin
    test = pos_inf_32; 
end

endmodule
