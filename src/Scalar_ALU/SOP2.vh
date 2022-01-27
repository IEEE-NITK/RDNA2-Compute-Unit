`ifndef _SOP2_vh
`define _SOP2_vh

//opcodes for SOP2
localparam S_ADD_U32 =8'b00000000
localparam  S_SUB_U32 =8'b00000001
localparam  S_ADD_I32 =8'b00000010
localparam S_SUB_I32 =8'b00000011
localparam S_ADDC_U32 =8'b00000100
localparam S_SUBB_U32 =8'b00000101
localparam S_MIN_I32 =8'b00000110
localparam S_MIN_U32 =8'b00000111
localparam S_MAX_I32 =8'b00001000
localparam S_MAX_U32 =8'b00001001
localparam S_CSELECT_B32 =8'b00001010
localparam S_CSELECT_B64 =8'b00001011
localparam	S_AND_B32 =8'b00001110
localparam S_AND_B64 =8'b00001111
localparam S_OR_B32	=8'b00010000
localparam S_OR_B64	=8'b00010001
localparam S_XOR_B32 =8'b00010010
localparam S_XOR_B64 =8'b00010011
localparam S_ANDN2_B32=8'b00010100	
localparam S_ANDN2_B64 =8'b00010101
localparam  S_ORN2_B32 =8'b00010110	
localparam S_ORN2_B64 =8'b00010111
localparam S_NAND_B32 =8'b00011000
localparam S_NAND_B64 =8'b00011001
localparam S_NOR_B32 =8'b00011010
localparam S_NOR_B64 =8'b00011011
localparam S_XNOR_B32 =8'b00011100
localparam S_XNOR_B64 =8'b00011101
localparam S_LSHL_B32 =8'b00011110
localparam S_LSHL_B64 =8'b00011111
localparam S_LSHR_B32 =8'b00100000
localparam S_LSHR_B64 =8'b00100001
localparam S_ASHR_I32 =8'b00100010	
localparam S_ASHR_I64 =8'b00100011
localparam S_BFM_B32 =8'b00100100
localparam S_BFM_B64 =8'b00100101
localparam 	S_MUL_I32 =8'b00100110
localparam S_BFE_U32 =8'b00100111	
localparam S_BFE_I32 =8'b00101000	
localparam S_BFE_U64 =8'b00101001
localparam S_BFE_I64 =8'b00101010
localparam  S_ABSDIFF_I32 =8'b00101100	
localparam S_LSHL1_ADD_U32 =8'b00101110
localparam S_LSHL2_ADD_U32 =8'b00101111	
localparam S_LSHL3_ADD_U32 =8'b00110000
localparam S_LSHL4_ADD_U32 =8'b00110001
localparam S_PACK_LL_B32_B16 =8'b00110010
localparam S_PACK_LH_B32_B16 =8'b00110011
localparam 	S_PACK_HH_B32_B16 =8'b00110100
localparam 	S_MUL_HI_U32 =8'b00110101
localparam 	S_MUL_HI_I32 =8'b00110110

`endif
