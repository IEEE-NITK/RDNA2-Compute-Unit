
`timescale 1ns/100ps

module tb_fpu_mul( ) ;
    
	reg clk   ;
	reg rst_n ;
	
	reg				i_valid		;	
	reg		[2:0]	i_mode		;
	reg		[1:0]	i_operation	;	// [0] : add , [1] : sub
	reg		[31:0]	i_inputA	;
	reg		[31:0]	i_inputB	;
	wire	[31:0]	o_output	;
	wire	[4:0]	o_exeption	;
	reg		[31:0]	r_output	;
	reg		[4:0]	r_exeption	;
	reg		[31:0]	rd_output	;
	reg		[4:0]	rd_exeption	;
	reg		[5:0]	cnt			;
	reg				error		;

	initial begin
		rst_n		= 0 ;
		clk 		= 1 ;
		#10 
		rst_n		= 1 ;
	end

	always begin
		#2.5 clk 	<= ~clk ;
	end
	
	initial begin
		i_valid		= 0 			;
		#20 
		i_valid		= 1 			;
		cnt			= 0				;
		i_mode		= 0				;	
		i_operation	= 2				;	
		i_inputA	= 32'h404ccccd  ;
		i_inputB	= 32'h40966666  ;
		r_output	= 32'h4170a3d7  ;
		r_exeption	= 5'h1         	;
		#5 
		cnt			= 1				;
		i_mode		= 0				;	
		i_operation	= 2				;
		i_inputA	= 32'hfe9eef6e  ;
		i_inputB	= 32'h5abc884c  ;
		r_output	= 32'hff800000  ;
		r_exeption	= 5'h11         ;
		#5 
		cnt			= 2				;
		i_mode		= 0				;	
		i_operation	= 2		     	;
		i_inputA	= 32'h7f7fffff  ;
		i_inputB	= 32'h3fffffff  ;
		r_output	= 32'h7f800000  ;
		r_exeption	= 5'h11         ;
		#5                           
		cnt			= 3				;
		i_mode		= 0				;	
		i_operation	= 2		        ;
		i_inputA	= 32'h80809c4e  ;
		i_inputB	= 32'h80800e5f  ;
		r_output	= 32'h00000000  ;
		r_exeption	= 5'h9          ;
		#5 
		cnt			= 4				;
		i_mode		= 0				;	
		i_operation	= 2				;
		i_inputA	= 32'h3f000fff  ;
		i_inputB	= 32'h00800fff  ;
		r_output	= 32'h00000000  ;
		r_exeption	= 5'h9          ;
		#5 
		cnt			= 5				;
		i_mode		= 0				;	
		i_operation	= 2		   		;
		i_inputA	= 32'h00000000  ;
		i_inputB	= 32'h7f800000  ;
		r_output	= 32'h7fc00000  ;
		r_exeption	= 5'h2          ;
		#5                           
		cnt			= 6				;
		i_mode		= 0				;	
		i_operation	= 2		        ;
		i_inputA	= 32'h0fd22000  ;
		i_inputB	= 32'h7fc00000  ;
		r_output	= 32'h7fc00000  ;
		r_exeption	= 5'h2          ;
		#5                           
		cnt			= 7				;
		i_mode		= 0				;	
		i_operation	= 2		        ;
		i_inputA	= 32'h3fffffff  ;
		i_inputB	= 32'h3fa00000  ;
		r_output	= 32'h401fffff  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 8				;
		i_mode		= 0				;	
		i_operation	= 2		        ;
		i_inputA	= 32'h00000000  ;
		i_inputB	= 32'h3fa00000  ;
		r_output	= 32'h00000000  ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 9				;
		i_mode		= 0				;	
		i_operation	= 2		        ;
		i_inputA	= 32'h3f800000  ;
		i_inputB	= 32'hBf800000  ;
		r_output	= 32'hBf800000  ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 10			;
		i_mode		= 0				;	
		i_operation	= 2		        ;
		i_inputA	= 32'h3f80eeff  ;
		i_inputB	= 32'h3f800010  ;
		r_output	= 32'h3f80ef0f  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 11			;
		i_mode		= 1				;	
		i_operation	= 2		        ;
		i_inputA	= 32'h3f80eeff  ;
		i_inputB	= 32'h3f800010  ;
		r_output	= 32'h3f80ef0f  ;
		r_exeption	= 5'h1          ;
		#5 
		cnt			= 12			;
		i_mode		= 2				;	
		i_operation	= 2				;	
		i_inputA	= 32'h3f80eeff  ;
		i_inputB	= 32'h3f800010  ;
		r_output	= 32'h3f80ef10  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 13			;
		i_mode		= 3				;	
		i_operation	= 2		        ;
		i_inputA	= 32'h3f80eeff  ;
		i_inputB	= 32'h3f800010  ;
		r_output	= 32'h3f80ef0f  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 14			;
		i_mode		= 4				;	
		i_operation	= 2		        ;
		i_inputA	= 32'h3f80eeff  ;
		i_inputB	= 32'h3f800010  ;
		r_output	= 32'h3f80ef0f  ;
		r_exeption	= 5'h1          ;		
	end

	fpu_top #(32) A_fpu_top(  
		.clk		( clk			),		      
		.rst_n      ( rst_n         ),
		.i_mode		( i_mode		),
		.i_operation( i_operation	),
		.i_valid	( i_valid		),
		.i_inputA   ( i_inputA      ),
		.i_inputB   ( i_inputB     	),
		.o_output   ( o_output    	),
		.o_exeption	( o_exeption	)	
	);
	
	always@(posedge clk) begin
		rd_output	<= r_output ;
		rd_exeption	<= r_exeption ;
	end
	
	always@(posedge clk,negedge rst_n) begin
		if (!rst_n) begin
			error	<= 1'b0 ;
		end else if ( rd_output[30:0] == 31'h7fc00000 && (o_output[30:0] != rd_output[30:0] || o_exeption != rd_exeption )) begin
			error 	<= 1'b1 ;
			$display ("ERROR1 %d",cnt-1) ;
		end else if ( rd_output[30:0] != 31'h7fc00000 && ( o_output != rd_output || o_exeption != rd_exeption ) ) begin
			error 	<= 1'b1 ;
			$display ("ERROR2 %d",cnt-1) ;
		end else begin
			error 	<= 1'b0 ;
		end
	end
	
endmodule
    
