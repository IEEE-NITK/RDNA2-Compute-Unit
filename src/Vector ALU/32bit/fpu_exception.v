
`timescale 1ns/100ps

module fpu_exception #(
	parameter BIT_WIDTH					= 32,			// 32, 64, 128
	// Don't touch 
	parameter EXP_WIDTH					= ( BIT_WIDTH == 32 ) ?  8 : ( BIT_WIDTH == 64 ) ? 11 :  15 ,  
	parameter SGN_WIDTH					= ( BIT_WIDTH == 32 ) ? 24 : ( BIT_WIDTH == 64 ) ? 53 : 113 , 
	parameter SIGN_POS					= BIT_WIDTH - 1 , 
	parameter EXP_SPOS					= BIT_WIDTH - 2 , 
	parameter EXP_EPOS					= SGN_WIDTH - 1 
)(      
	input								clk,
	input								rst_n,
	
	input								i_valid,
	input		[1:0]					i_operation,	// 00 : ADD, 01 : SUB, 10 : MUL , 11 : DIV
	input		[BIT_WIDTH-1:0]			i_inputA,
	input		[BIT_WIDTH-1:0]			i_inputB,
			
	input		[BIT_WIDTH-1:0]			i_add_out,
	input		[BIT_WIDTH-1:0]			i_sub_out,
	input		[BIT_WIDTH-1:0]			i_mul_out,
	
	input								i_add_inexact,
	input								i_sub_inexact,
	input								i_mul_inexact,

	output reg	[BIT_WIDTH-1:0]			o_output,
	output  	[4:0]					o_exeption	// [4] overflow , [3] underflow, [2] division by zero, [1] invalid operation, [0] inexact	

);
	reg			[4:0]					t_exeption	;
	reg									t_inexact  	;
	reg			[BIT_WIDTH-1:0]			t_mux_out  	;
	wire 								inputA_nan;
	wire 								inputB_nan;
	wire 								inputA_un;
	wire 								inputB_un;
	wire 								signA;
	assign inputA_nan =((i_inputA[EXP_SPOS:EXP_EPOS]	==	{(EXP_WIDTH){1'b1}}) &	(i_inputA[SGN_WIDTH-2:0]	!==	{(SGN_WIDTH-1){1'b0}})) ? 1 : 0;
	assign inputB_nan =((i_inputB[EXP_SPOS:EXP_EPOS]	==	{(EXP_WIDTH){1'b1}}) &	(i_inputB[SGN_WIDTH-2:0]	!==	{(SGN_WIDTH-1){1'b0}})) ? 1 : 0;

	assign inputA_un = ((i_inputA[EXP_SPOS:EXP_EPOS]	==	{(EXP_WIDTH){1'b1}}) &	(i_inputA[SGN_WIDTH-2:0]	==	{(SGN_WIDTH-1){1'b0}})) ? 1 : 0;
	assign inputB_un = ((i_inputB[EXP_SPOS:EXP_EPOS]	==	{(EXP_WIDTH){1'b1}}) &	(i_inputB[SGN_WIDTH-2:0]	==	{(SGN_WIDTH-1){1'b0}})) ? 1 : 0;

	assign signA 		= i_inputA[BIT_WIDTH-1] ;

	////////////////////////////////////////////////////////////////////////
	// OUTPUT MUX
	////////////////////////////////////////////////////////////////////////
	// output mux
	always@(*) begin

		case (i_operation)
		2'b10	:	t_mux_out			= i_mul_out ;
		2'b01	:	t_mux_out			= i_sub_out ;
		default	:	t_mux_out			= i_add_out ;
		endcase
	end
	
	always@(*) begin
		case (i_operation)
		2'b10	:	t_inexact			= i_mul_inexact ;
		2'b01	:	t_inexact			= i_sub_inexact ;
		default	:	t_inexact			= i_add_inexact ;
		endcase
	end
	


	////////////////////////////////////////////////////////////////////////
	///////////////////////////// Exception Control///////////////////////// 
	////////////////////////////////////////////////////////////////////////
	// [4] overflow , [3] underflow, [2] division by zero, [1] invalid operation, [0] inexact	
	//always@(posedge clk, negedge rst_n) begin
		always@(*) begin
	// if rst_n is active it means program is running so we use and gate to find that
	 t_exeption[0] = (t_inexact && rst_n) ? 1 : 0;
	 t_exeption[1] = ((i_operation == 2'b01) &&  inputA_un && inputB_un && signA ) ?  0 : // adding one infinity
	 				 ((i_operation == 2'b00 || i_operation == 2'b01) && ( inputA_un ^ inputB_un)) ? 0 : // adding one infinity
	 				 ((inputA_nan || inputB_nan || inputA_un || inputB_un)  && rst_n ) ? 1 : 0; // results Nan

	 t_exeption[2] = ((i_operation == 2'b11 && i_inputB == 0)  && rst_n)? 1 : 0; // divided by 0
	 t_exeption[3] = (((t_mux_out[EXP_SPOS:EXP_EPOS] == {(EXP_WIDTH){1'b0}}) && t_inexact) && rst_n )? 1 : 0; // underflow
	 t_exeption[4] = (((t_mux_out[EXP_SPOS:EXP_EPOS] == {(EXP_WIDTH){1'b1}}) && t_inexact)  && rst_n )? 1 : 0; // overflow
	 end
	 assign o_exeption = t_exeption;

	////////////////////////////////////////////////////////////////////////
	///////////////////////////////// OUTPUT//////////////////////////////// 
	////////////////////////////////////////////////////////////////////////
	
	always@(posedge clk, negedge rst_n) begin

	// Assigning the sign bit of output
	 o_output [BIT_WIDTH-1] = (!rst_n) ? 0 : (
	(t_exeption == 5'b00000) ? t_mux_out [BIT_WIDTH-1]: ( // inexact
	(t_exeption[1]) ? 0 : ( // invalid operation
	(t_exeption[2]) ? (i_inputA[SIGN_POS]): ( // division by zero
	(t_exeption[4]) ? t_mux_out[BIT_WIDTH-1]: ( // overflow
	(t_exeption[3]) ? t_mux_out[BIT_WIDTH-1] :( // underflow
	(t_exeption[0]) ? t_mux_out [BIT_WIDTH-1]: t_mux_out [BIT_WIDTH-1])))))); // inexact and default
	
	// Assigning the exponent bit of output
	 o_output [EXP_SPOS:EXP_EPOS] = (!rst_n) ? ({(EXP_WIDTH){1'b0}}) : (
	(t_exeption == 5'b00000) ? t_mux_out [EXP_SPOS:EXP_EPOS]: (
	(t_exeption[1]) ? {(EXP_WIDTH){1'b1}} : (
	(t_exeption[2]) ? {(EXP_WIDTH){1'b1}} : (
	(t_exeption[4]) ? {(EXP_WIDTH){1'b1}} : (
	(t_exeption[3]) ? {(EXP_WIDTH){1'b0}} : ( 
	(t_exeption[0]) ? t_mux_out [EXP_SPOS:EXP_EPOS] : t_mux_out [EXP_SPOS:EXP_EPOS]))))));

	// Assigning the mantissa bits of output
	 o_output [SGN_WIDTH-2:0] = (!rst_n) ? ({(SGN_WIDTH-1){1'b0}}) : (
	(t_exeption == 5'b00000) ? t_mux_out [SGN_WIDTH-2:0]: (
	(t_exeption[1]) ? {1'b1,{(SGN_WIDTH-2){1'b0}}} : (
	(t_exeption[2]) ? {(SGN_WIDTH-1){1'b0}}: (
	(t_exeption[4]) ? {(SGN_WIDTH-1){1'b0}}: (
	(t_exeption[3]) ? {(SGN_WIDTH-1){1'b0}} :(
	(t_exeption[0]) ? t_mux_out [SGN_WIDTH-2:0] : t_mux_out [SGN_WIDTH-2:0]))))));
	
	end
	
	
			
endmodule
