`ifndef _floats_vh
`define _floats_vh

//Vector instruction constants
localparam VINTERP  =6'b110010;
localparam VOPC     =6'b111110;
localparam VOP3     =6'b110101;

//32 bit constants for floating point numbers
localparam pos_inf_32   =32'b01111111100000000000000000000000;
localparam neg_inf_32   =32'b11111111100000000000000000000000;
localparam nan_exp_32   =8'b11111111;
localparam denorm_32    =8'b00000000;

//64 bit constants for floating point numbers
//localparam pos_inf_64   ={1'b0, 11'b11111111111, 52'b0};
//localparam neg_inf_64   ={1'b1, 11'b11111111111, 52'b0};
//localparam nan_exp_64   =11'b11111111111;
//localparam denorm_64    =11'b00000000000;

`endif
