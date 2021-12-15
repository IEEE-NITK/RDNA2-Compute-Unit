//This is a template file

`ifndef DEFINES_V
`define DEFINES_V

//==================  Opcodes usable with OPSEL (VOP3)==================
 
`define V_MAD_I16           =64'b0
`define V_FMA_F16           =64'b0
`define V_ALIGNBIT_B32      =64'b0
`define V_ALIGNBIT_B32      =64'b0
`define V_DIV_FIXUP_F16     =64'b0

//======

`define V_INTERP_P2_F16         =64'b0
`define V_CVT_PKNORM_I16_F16    =64'b0
`define V_CVT_PKNORM_U16_F16    =64'b0
`define V_MAD_U32_U16           =64'b0
`define V_MAD_I32_I16           =64'b0
`define V_MIN3_{F16, I16, U16}  =64'b0
`define V_MAX3_{F16, I16, U16}  =64'b0
`define V_MED3_{F16, I16, U16}  =64'b0
`define V_PACK_F16              =64'b0

//======

`define V_ADD_NC_U16        =64'b0
`define V_SUB_NC_U16        =64'b0
`define V_MUL_LO_U16        =64'b0
`define V_LSHLREV_B16       =64'b0
`define V_LSHRREV_B16       =64'b0
`define V_ASHRREV_I16       =64'b0
`define V_MAX_U16           =64'b0
`define V_MAX_I16           =64'b0
`define V_MIN_U16           =64'b0
`define V_MIN_I16           =64'b0

//====================================================================

//================== VOP3 Opcodes ====================================

`define V_ADD_LSHL_U32          =64'b0
`define V_ADD3_U32              =64'b0
`define V_AND_OR_B32            =64'b0
`define V_BFE_{U32 , I32 }      =64'b0
`define V_BFI_B32               =64'b0
`define V_CUBEID_F32            =64'b0
`define V_CUBEMA_F32            =64'b0
`define V_CUBESC_F32            =64'b0
`define V_CUBETC_F32            =64'b0
`define V_CVT_PK_U8_F32         =64'b0
`define V_DIV_FIXUP_{F16,F32,F64}         =64'b0
`define V_DIV_FMAS_{F32,F64}    =64'b0
`define V_DIV_SCALE_{F32,F64}   =64'b0
`define V_FMA_{ F16, F32, F64}  =64'b0
`define V_LERP_U8               =64'b0
`define V_LSHL_ADD_U32          =64'b0
`define V_LSHL_OR_B32           =64'b0
`define V_MAD_{I16,U16}         =64'b0
`define V_MAD64_{U64_U32,I64_I32} =64'b0  //represents `define V_MAD_{U64_U32,I64_I32} =64'b0
`define V_MAD_I32_I24           =64'b0
`define V_MAD_U32_U24           =64'b0
`define V_MAX3F_{F32,I32,U32}    =64'b0  //represents `define V_MAX3_{F32,I32,U32}    =64'b0
`define V_MED3F_{F32,I32,U32}    =64'b0  //represents `define V_MED3_{F32,I32,U32}    =64'b0
`define V_MIN3F_{F32,I32,U32}    =64'b0  //represents `define V_MIN3_{F32,I32,U32}    =64'b0
`define V_MQSAD_PK_U16_U8       =64'b0
`define V_MQSAD_PK_U32_U8       =64'b0
`define V_MSAD_U8               =64'b0
`define V_MULLIT_F32            =64'b0
`define V_OR3_B32               =64'b0
`define V_PERM_B32              =64'b0
`define V_PERMLANE16_B32        =64'b0
`define V_PERMLANEX16_B32       =64'b0
`define V_QSAD_PK_U16_U8        =64'b0
`define V_SAD_{U8, HI_U8, U16,U32}        =64'b0
`define V_TRIG_PREOP_F64        =64'b0
`define V_XAD_U32               =64'b0
`define V_XOR3_B32              =64'b0

//====================================================================

//================== VOP3P Opcodes ===================================

`define V_DOT2_F32_F16          =64'b0
`define V_DOT2_I32_I16          =64'b0
`define V_DOT2_U32_U16          =64'b0
`define V_DOT4_I32_I8           =64'b0
`define V_DOT4_U32_U8           =64'b0
`define V_DOT8_I32_I4           =64'b0
`define V_DOT8_U32_U4           =64'b0

//====================================================================

//================== VOP3 - 1-2 operand opcodes ======================

`define V_INTERP_P2_F32         =64'b0
`define V_LSHLREV_{B16, B64}    =64'b0
`define V_LSHRREV_{B16, B64}    =64'b0
`define V_MAX_{U16, I16, F64}   =64'b0
`define V_MBCNT_HI_U32_B32      =64'b0
`define V_MBCNT_LO_U32_B32      =64'b0
`define V_MIN_ {U16, I16, F64}  =64'b0
`define V_MUL_F64               =64'b0
`define V_MUL_HI_{I32,U32}      =64'b0
`define V_MUL_LO_{U16, U32}     =64'b0
`define V_PACK_B32_F16          =64'b0
`define V_SUB_CO_U32            =64'b0
`define V_SUB_NC_{I32, U16, I16}     =64'b0
`define V_SUBREV_CO_U32         =64'b0
`define V_WRITELANE_B32         =64'b0

//====================================================================

`endif