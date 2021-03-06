`timescale 1ns / 1ps

module test_tb;
`include "trial.vh"

reg[31:0] test2;
wire[31:0] boop2;

temp_test m(.test(test2),
            .boop(boop2));
               
initial
begin
    test2 = 32'b0; 
    #(10);
    test2 = pos_inf_32;
end

endmodule
