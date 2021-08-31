//This is a template file

`ifndef DEFINES_V
`define DEFINES_V

//==================  Opcodes usable with OPSEL (VOP3)==================
 
`define V_MAD_I16           64'b0
`define V_FMA_F16           64'b0
`define V_ALIGNBIT_B32      64'b0
`define V_ALIGNBIT_B32      64'b0
`define V_DIV_FIXUP_F16     64'b0

//======

`define V_INTERP_P2_F16         64'b0
`define V_CVT_PKNORM_I16_F16    64'b0
`define V_CVT_PKNORM_U16_F16    64'b0
`define V_MAD_U32_U16           64'b0
`define V_MAD_I32_I16           64'b0
`define V_MIN3_{F16, I16, U16}  64'b0
`define V_MAX3_{F16, I16, U16}  64'b0
`define V_MED3_{F16, I16, U16}  64'b0
`define V_PACK_F16              64'b0

//======

`define V_ADD_NC_U16        64'b0
`define V_SUB_NC_U16        64'b0
`define V_MUL_LO_U16        64'b0
`define V_LSHLREV_B16       64'b0
`define V_LSHRREV_B16       64'b0
`define V_ASHRREV_I16       64'b0
`define V_MAX_U16           64'b0
`define V_MAX_I16           64'b0
`define V_MIN_U16           64'b0
`define V_MIN_I16           64'b0

//====================================================================
`endif