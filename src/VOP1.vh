`ifndef _VOP1_vh
localparam _VOP1_vh

localparam V_BFREV_B32				=64'b0
localparam V_CEIL_{F16,F32,F64}			=64'b0
localparam V_CLREXCP				=64'b0
localparam V_COS_{F16,F32}				=64'b0
localparam V_CVT_{I32,U32,F16,F64}_F32		=64'b0
localparam V_CVT_{I32,U32}_F64			=64'b0
localparam V_CVT_{U16,I16}_F16			=64'b0
localparam V_CVT_F16_{U16, I16} 			=64'b0
localparam V_CVT_F32_{I32,U32,F16,F64}		=64'b0
localparam V_CVT_F32_UBYTE{0,1,2,3} 		=64'b0
localparam V_CVT_F64_{I32,U32}			=64'b0
localparam V_CVT_FLR_I32_F32			=64'b0
localparam V_CVT_NORM_I16_F16			=64'b0
localparam V_CVT_NORM_U16_F16			=64'b0
localparam V_CVT_OFF_F32_I4			=64'b0
localparam V_CVT_RPI_I32_F32			=64'b0
localparam V_EXP_{F16,F32}				=64'b0
localparam V_FFBH_{U32,I32}			=64'b0
localparam V_FFBL_B32				=64'b0
localparam V_FLOOR_{F16,F32, F64}			=64'b0
localparam V_FRACT_{F16,F32,F64}			=64'b0
localparam V_FREXP_EXP_I16_F16			=64'b0
localparam V_FREXP_EXP_I32_F32 			=64'b0
localparam V_FREXP_EXP_I32_F64			=64'b0
localparam V_FREXP_MANT_{F16,F32,F64} 		=64'b0
localparam V_LOG_{F16,F32}				=64'b0
localparam V_MOV_B32 				=64'b0
localparam V_MOV_FED_B32 				=64'b0
localparam V_MOVREL{S,D,SD,SD_2}_B32		=64'b0
localparam V_NOP					=64'b0
localparam V_NOT_B32 				=64'b0
localparam V_PIPEFLUSH				=64'b0
localparam V_RCP_{F16,F32,F64}			=64'b0
localparam V_RCP_IFLAG_F32 			=64'b0
localparam V_READFIRSTLANE_B32 			=64'b0
localparam V_RNDNE_{F16,F32,F64}			=64'b0
localparam V_RSQ_{F16,F32,F64}			=64'b0
localparam V_SAT_PK_U8_I16				=64'b0
localparam V_SIN_ {F16,F32} 			=64'b0
localparam V_SQRT_{F16,F32,F64} 			=64'b0
localparam V_SWAP_B32				=64'b0
localparam V_SWAPREL_B32 				=64'b0
localparam V_TRUNC_{F16,F32,F64} 			=64'b0

`endif
