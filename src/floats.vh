`ifndef _floats_vh
`define _floats_vh

//Vector instruction constants
`define VINTERP       	 	6'b110010
`define VOPC                6'b111110
`define VOP3                6'b110101

//32 bit constants for floating point numbers
`define pos_inf_32          32'b01111111100000000000000000000000
`define neg_inf_32          {1'b1, 8'b11111111, 23'b00000000000000000000000}
`define nan_exp_32          8'b11111111
`define denorm_32           8'b00000000

//64 bit constants for floating point numbers
`define pos_inf_64          {1'b0, 11'b11111111111, 52'b0}
`define neg_inf_64          {1'b1, 11'b11111111111, 52'b0}
`define nan_exp_64          11'b11111111111
`define denorm_64           11'b00000000000

`endif
