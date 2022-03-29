
`timescale 1ns/100ps

module fpu_top #(
	parameter BIT_WIDTH					= 32			// 32, 64, 128
)(  
	input								clk,
	input								rst_n,
	
	input		[2:0]					i_mode,			// 0 : RoundTiesToEven
														// 1 : RoundTiesToAway
														// 2 : RoundTowardPositive 
														// 3 : RoundTowardNegative
 														// 4 : RoundTowardZero  
	input		[1:0]					i_operation,	// 00 : ADD, 01 : SUB, 10 : MUL , 11 : DIV
	input								i_valid,
	input		[BIT_WIDTH-1:0]			i_inputA,
	input		[BIT_WIDTH-1:0]			i_inputB,
	output 		[BIT_WIDTH-1:0]			o_output,
	output 		[4:0]					o_exeption		// [4] overflow , [3] underflow, [2] division by zero, [1] invalid operation, [0] inexact	
);
	
	wire		[BIT_WIDTH-1:0]			add_out 	;
	//wire		[BIT_WIDTH-1:0]			sub_out 	;
	wire		[BIT_WIDTH-1:0]			mul_out 	;
	
	wire								add_inexact	;
	//wire								sub_inexact	;
	wire								mul_inexact	;


	fpu_add #(BIT_WIDTH) A_fpu_add(  
		.i_mode		( i_mode		),
		.i_operation( i_operation[0]),
		.i_inputA   ( i_inputA      ),
		.i_inputB   ( i_inputB      ),
		.o_output   ( add_out	    ),
		.o_inexact	( add_inexact	)
	);
	
	fpu_mul #(BIT_WIDTH) A_fpu_mul(  
		.i_mode		( i_mode		),
		.i_inputA   ( i_inputA      ),
		.i_inputB   ( i_inputB      ),
		.o_output   ( mul_out	    ),
		.o_inexact	( mul_inexact	)
	);
	
	fpu_exception #(BIT_WIDTH) A_fpu_exception (  
		.clk			( clk			),	    
		.rst_n      	( rst_n         ),
		.i_valid    	( i_valid       ),
		.i_operation	( i_operation   ),
		.i_inputA   	( i_inputA      ),
		.i_inputB   	( i_inputB      ),
		.i_add_out  	( add_out	    ),
		.i_sub_out  	( add_out	    ),
		.i_mul_out  	( mul_out     	),
		.i_add_inexact	( add_inexact	),
		.i_sub_inexact	( add_inexact   ),
		.i_mul_inexact	( mul_inexact   ),
		.o_output   	( o_output      ),
		.o_exeption		( o_exeption	)
	);
	
			
endmodule
