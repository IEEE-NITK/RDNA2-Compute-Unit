`ifndef _SOPC_vh
`define _SOPC_vh

//opcodes for SOPC
localparam S_CMP_EQ_I32 =8'b00000000
localparam S_CMP_LG_I32 =8'b00000001
localparam S_CMP_GT_I32  =8'b00000010
localparam S_CMP_GE_I32=8'b00000011
localparam S_CMP_LT_I32 =8'b00000100
localparam S_CMP_LE_I32 =8'b00000101
localparam S_CMP_EQ_U32 =8'b00000110
localparam S_CMP_LG_U32 =8'b00000111
localparam S_CMP_GT_U32 =8'b00001000
localparam S_CMP_GE_U32 =8'b00001001
localparam S_CMP_LT_U32 =8'b00001010
localparam S_CMP_LE_U32 =8'b00001011
localparam S_BITCMP0_B32 =8'b00001100
localparam S_BITCMP1_B32 =8'b00010010
localparam S_BITCMP0_B64 =8'b00001110
localparam S_BITCMP1_B64 =8'b00001111
localparam S_CMP_EQ_U64 =8'b00010010
localparam S_CMP_LG_U64 =8'b00010011


`endif
