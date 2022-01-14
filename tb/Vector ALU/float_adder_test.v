`timescale 1ns / 1ps
module float_adder_test;

reg[31:0] A;
reg[31:0] B;
wire[31:0] out;
wire NaN_flag;
wire overflow_flag;

float_adder_32 test(.A(A), .B(B), .out(out), .NaN_flag(NaN_flag), .overflow_flag(overflow_flag));

initial
begin

    #(10);
    A = 32'b01111111100000000000000000000000;
    B = 32'b0;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b11111111100000000000000000000000;
    B = 32'b0;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b11111111100000000000000000000000;
    B = 32'd1555;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    B = 32'b01111111100000000000000000000000;
    A = 32'b0;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    B = 32'b11111111100000000000000000000000;
    A = 32'b0;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    B = 32'b11111111100000000000000000000000;
    A = 32'd1555;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b11111111100000000000000000000000;
    B = 32'b01111111100000000000000000000000;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b11111111100000000000000000000000;
    B = 32'b11111111100000000000000000000000;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b01111111100000000000000000000000;
    B = 32'b01111111100000000000000000000000;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b01111111100000000000000000000000;
    B = 32'b11111111100000000000000000000000;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'd1;
    B = 32'd2;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b00000001100000000000000000000000;
    B = 32'b00000000100000000000000000000000;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b00000010100000000000000000000000;
    B = 32'b00000001100000000000000000000000;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b00000001100000000000000000000000;
    B = 32'b00000001100000000000000000000000;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b00000001100000000000000000000000;
    B = 32'b00000011100000000000000000000000;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b00000011000000000000000000000001;
    B = 32'b00010011100000000000000000000000;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b00000001000000000000000000000000;
    B = 32'b00000010000000000000000000000100;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    $display("sign test started");
    
    #(10);
    A = 32'b10000001000000000110000000000000;
    B = 32'b00000010000000000100000000000100;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b00000001000000000110000000000000;
    B = 32'b10000010000000000100000000000100;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
    
    #(10);
    A = 32'b10000001000000000110000000000000;
    B = 32'b10000010000000000100000000000100;
    #(10);
    $display("A = %d, B = %d, out = %d, Nan_flag = %d, overflow = %d", A, B, out, NaN_flag, overflow_flag);
end

endmodule