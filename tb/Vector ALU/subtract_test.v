`timescale 1ns / 1ps
module subtract_test;

reg[7:0] A;
reg[7:0] B;
wire[7:0] diff;
wire Borrow;

subtractor_8b temp(.A(A), .B(B), .diff(diff), .Borrow(Borrow));

initial
begin
    #(10);
    A = 8'b10;
    B = 8'b01;
    $display("A = %d, B = %d, diff = %d, Borrow = %d", A, B, diff, Borrow);
    
    #(10);
    A = 8'b10;
    B = 8'b10;
    $display("A = %d, B = %d, diff = %d, Borrow = %d", A, B, diff, Borrow);
    
    #(10);
    A = 8'hFF;
    B = 8'b00;
    $display("A = %d, B = %d, diff = %d, Borrow = %d", A, B, diff, Borrow);
    
    #(10);
    A = 8'hFF;
    B = 8'b01;
    $display("A = %d, B = %d, diff = %d, Borrow = %d", A, B, diff, Borrow);
    
    #(10);
    A = 8'hFF;
    B = 8'b10;
    $display("A = %d, B = %d, diff = %d, Borrow = %d", A, B, diff, Borrow);
    
    #(10);
    A = 8'h00;
    B = 8'hFF;
    $display("A = %d, B = %d, diff = %d, Borrow = %d", A, B, diff, Borrow);
    
    #(10);
    A = 8'b110;
    B = 8'b1111;
    $display("A = %d, B = %d, diff = %d, Borrow = %d", A, B, diff, Borrow);
    
end

endmodule
