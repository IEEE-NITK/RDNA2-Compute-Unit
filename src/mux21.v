`timescale 1ns / 1ps

module mux21(
    input input1,
    input input0,
    input sel,
    output out
    );
    
assign out = (input0 & (~sel)) | (input1 & sel);
    
endmodule
