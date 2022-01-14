`ifndef _SOP1_vh
`define _SOP1_vh

//opcodes for SOP1
localparam S_MOV_B32 = 8'b00000011; 
localparam S_MOV_B64 = 8'b00000100; 
localparam S_CMOV_B32 = 8'b00000101; 
localparam S_CMOV_B64 = 8'b00000110; 
localparam S_NOT_B32 = 8'b00000111;

localparam S_NOT_B64 = 8'b00001000; 
localparam S_WQM_B32  = 8'b00001001; 
localparam S_WQM_B64 = 8'b00001010; 
localparam S_BREV_B32 = 8'b00001011; 
localparam S_BREV_B64  = 8'b00001100; 
localparam S_BCNT0_I32_B32 = 8'b00001101; 
localparam S_BCNT0_I32_B64  = 8'b00001110;
localparam S_BCNT1_I32_B32  = 8'b00001111; 

localparam S_BCNT1_I32_B64  = 8'b00010000; 
localparam S_FF0_I32_B32  = 8'b00010001; 
localparam S_FF0_I32_B64  = 8'b00010010; 
localparam S_FF1_I32_B32 = 8'b00010011; 
localparam S_FF1_I32_B64 = 8'b00010100; 
localparam S_FLBIT_I32_B32 = 8'b00010101; 
localparam S_FLBIT_I32_B64 = 8'b00010110;

localparam S_FLBIT_I32 = 8'b00010111; 
localparam S_FLBIT_I32_I64  = 8'b00011000; 
localparam S_SEXT_I32_I8 = 8'b00011001; 
localparam S_SEXT_I32_I16 = 8'b00011010; 
localparam S_BITSET0_B32 = 8'b00011011; 
localparam S_BITSET0_B64 = 8'b00011100; 
localparam S_BITSET1_B32 = 8'b00011101; 
localparam S_BITSET1_B64 = 8'b00011110; 
localparam S_GETPC_B64 = 8'b00011111; 

localparam S_SETPC_B64 = 8'b00100000; 
localparam S_SWAPPC_B64 = 8'b00100001; 
localparam S_RFE_B64 = 8'b00100010; 
localparam S_AND_SAVEEXEC_B64 = 8'b00100100; 
localparam S_OR_SAVEEXEC_B64 = 8'b00100101; 
localparam S_XOR_SAVEEXEC_B64 = 8'b00100110; 
localparam S_ANDN2_SAVEEXEC_B64 = 8'b00100111; 
localparam S_ORN2_SAVEEXEC_B64 = 8'b00101000;

localparam S_NAND_SAVEEXEC_B64 = 8'b00101001; 
localparam S_NOR_SAVEEXEC_B64 = 8'b00101010; 
localparam S_XNOR_SAVEEXEC_B64 = 8'b00101011; 
localparam S_QUADMASK_B32 = 8'b00101100; 
localparam S_QUADMASK_B64 = 8'b00101101; 
localparam S_MOVRELS_B32 = 8'b00101110; 
localparam S_MOVRELS_B64 = 8'b00101111; 
localparam S_MOVRELD_B32 = 8'b00110000; 
localparam S_MOVRELD_B64 = 8'b00110001;

localparam S_ABS_I32 = 8'b00110100; 
localparam S_ANDN1_SAVEEXEC_B64 = 8'b00110111; 
localparam S_ORN1_SAVEEXEC_B64 = 8'b00111000; 
localparam S_ANDN1_WREXEC_B64 = 8'b00111001; 
localparam S_ANDN2_WREXEC_B64 = 8'b00111010; 
localparam S_BITREPLICATE_B64_B32 = 8'b00111011; 
localparam S_AND_SAVEEXEC_B32 = 8'b00111100; 
localparam S_OR_SAVEEXEC_B32 = 8'b00111101; 
localparam S_XOR_SAVEEXEC_B32 = 8'b00111110; 
localparam S_ANDN2_SAVEEXEC_B32 = 8'b00111111; 

localparam S_ORN2_SAVEEXEC_B32 = 8'b01000000; 
localparam S_NAND_SAVEEXEC_B32 = 8'b01000001; 
localparam S_NOR_SAVEEXEC_B32 = 8'b01000010; 
localparam S_XNOR_SAVEEXEC_B32 = 8'b01000011; 
localparam S_ANDN1_SAVEEXEC_B32 = 8'b01000100; 
localparam S_ORN1_SAVEEXEC_B32 = 8'b01000101; 
localparam S_ANDN1_WREXEC_B32 = 8'b01000110; 
localparam S_ANDN2_WREXEC_B32 = 8'b01000111; 
localparam S_MOVRELSD_2_B32 = 8'b01001001; 



`endif