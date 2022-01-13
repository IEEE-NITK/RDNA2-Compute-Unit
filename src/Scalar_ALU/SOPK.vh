`ifndef _SOPK_vh
`define _SOPK_vh

//opcodes for SOPK
localparam S_MOVK_I32 = 5'b00000;
localparam S_VERSION = 5'b00001;
localparam S_CMOVK_I32 = 5'b00010;
localparam S_CMPK_EQ_I32 = 5'b00011;
localparam S_CMPK_LG_I32 = 5'b00100;
localparam S_CMPK_GT_I32 = 5'b00101;
localparam S_CMPK_GE_I32 = 5'b00110;
localparam S_CMPK_LT_I32 = 5'b00111;
localparam S_CMPK_LE_I32 = 5'b01000;
localparam S_CMPK_EQ_U32 = 5'b01001;
localparam S_CMPK_LG_U32 = 5'b01010;
localparam S_CMPK_GT_U32 = 5'b01011;
localparam S_CMPK_GE_U32 = 5'b01100;
localparam S_CMPK_LT_U32 = 5'b01101;
localparam S_CMPK_LE_U32 = 5'b01110;
localparam S_ADDK_I32 = 5'b01111;
localparam S_MULK_I32 = 5'b10000;
localparam S_GETREG_B32 = 5'b10010;
localparam S_SETREG_B32 = 5'b10011;
localparam S_SETREG_IMM32_B32 = 5'b10101;
localparam S_CALL_B64 = 5'b10110;
localparam S_WAITCNT_VSCNT = 5'b10111;
localparam S_WAITCNT_VMCNT = 5'b11000;
localparam S_WAITCNT_EXPCNT = 5'b11001;
localparam S_WAITCNT_LGKMCNT = 5'b11010;
localparam S_SUBVECTOR_LOOP_BEGIN = 5'b11011;
localparam S_SUBVECTOR_LOOP_END = 5'b11100;

`endif