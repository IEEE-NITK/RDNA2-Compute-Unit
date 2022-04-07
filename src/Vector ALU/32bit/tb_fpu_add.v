
`timescale 1ns/100ps

module tb_fpu_add( ) ;
    
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
		i_operation	= 0				;	
		i_inputA	= 32'h404ccccd  ;
		i_inputB	= 32'h40966666  ;
		r_output	= 32'h40fccccc  ;
		r_exeption	= 5'h1         	;
		#5 
		cnt			= 1				;
		i_mode		= 0				;	
		i_operation	= 0				;
		i_inputA	= 32'hc04ccccd  ;
		i_inputB	= 32'h40966666  ;
		r_output	= 32'h3fbffffe  ;
		r_exeption	= 5'h0          ;
		#5 
		cnt			= 2				;
		i_mode		= 0				;	
		i_operation	= 0		     	;
		i_inputA	= 32'h3ff33333  ;
		i_inputB	= 32'hc1066666  ;
		r_output	= 32'hc0cfffff  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 3				;
		i_mode		= 0				;	
		i_operation	= 1		        ;
		i_inputA	= 32'h3ff33333  ;
		i_inputB	= 32'hc1066666  ;
		r_output	= 32'h4124cccc  ;
		r_exeption	= 5'h1          ;
		#5 
		cnt			= 4				;
		i_mode		= 0				;	
		i_operation	= 1				;
		i_inputA	= 32'h40e9999a  ;
		i_inputB	= 32'h40e99999  ;
		r_output	= 32'h35000000  ;
		r_exeption	= 5'h0          ;
		#5 
		cnt			= 5				;
		i_mode		= 0				;	
		i_operation	= 0		   		;
		i_inputA	= 32'h7f7ffffe  ;
		i_inputB	= 32'h73800000  ;
		r_output	= 32'h7f7fffff  ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 6				;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h3f800000  ;
		i_inputB	= 32'h3f800000  ;
		r_output	= 32'h40000000  ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 7				;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h80000000  ;
		i_inputB	= 32'h80000000  ;
		r_output	= 32'h80000000  ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 8				;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h0         ;
		i_inputB	= 32'h0         ;
		r_output	= 32'h0         ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 9				;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h0         ;
		i_inputB	= 32'h80000000  ;
		r_output	= 32'h0         ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 10			;
		i_mode		= 0				;	
		i_operation	= 1		        ;
		i_inputA	= 32'h40e9999a  ;
		i_inputB	= 32'h40e9999a  ;
		r_output	= 32'h0         ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 11			;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h40e9999a  ;
		i_inputB	= 32'hC0e9999a  ;
		r_output	= 32'h0         ;
		r_exeption	= 5'h0          ;
		#5 
		cnt			= 12			;
		i_mode		= 0				;	
		i_operation	= 1				;	
		i_inputA	= 32'h34578901  ;
		i_inputB	= 32'h80000000  ;
		r_output	= 32'h34578901  ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 13			;
		i_mode		= 0				;	
		i_operation	= 1		        ;
		i_inputA	= 32'h0         ;
		i_inputB	= 32'h54578901  ;
		r_output	= 32'hD4578901  ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 14			;
		i_mode		= 0				;	
		i_operation	= 1		        ;
		i_inputA	= 32'h0b800001  ;
		i_inputB	= 32'h0b800004  ;
		r_output	= 32'h80c00000  ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 15			;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h0b800002  ;
		i_inputB	= 32'h0b800008  ;
		r_output	= 32'h0c000005  ;
		r_exeption	= 5'h0          ;
		#5 
		cnt			= 16			;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h7f7ffffe  ;
		i_inputB	= 32'h73000000  ;
		r_output	= 32'h7f7ffffe  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 17			;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h7f7ffffe  ;
		i_inputB	= 32'h73000001  ;
		r_output	= 32'h7f7fffff  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 18			;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h7f7fffff  ;
		i_inputB	= 32'h73000000  ;
		r_output	= 32'h7f800000  ;
		r_exeption	= 5'h11         ;
		#5 
		cnt			= 19			;
		i_mode		= 0				;	
		i_operation	= 0				;
		i_inputA	= 32'h7f7fffff  ;
		i_inputB	= 32'h73800001  ;
		r_output	= 32'h7f800000  ;
		r_exeption	= 5'h11         ;
		#5                           
		cnt			= 20			;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h7f7fff6e  ;
		i_inputB	= 32'h7f6ff84c  ;
		r_output	= 32'h7f800000  ;
		r_exeption	= 5'h11         ;
		#5                           
		cnt			= 21			;
		i_mode		= 0				;	
		i_operation	= 0		        ;
		i_inputA	= 32'hff800000  ;
		i_inputB	= 32'h3ff0a3d6  ;
		r_output	= 32'hff800000  ;
		r_exeption	= 5'h11         ;
		#5                           
		cnt			= 22			;
		i_mode		= 0				;	
		i_operation	= 1		        ;
		i_inputA	= 32'hff800000  ;
		i_inputB	= 32'h7f800000  ;
		r_output	= 32'hff800000  ;
		r_exeption	= 5'h11         ;
		#5 
		cnt			= 23			;
		i_mode		= 0				;	
		i_operation	= 0				;
		i_inputA	= 32'h3f800003  ;
		i_inputB	= 32'hbf800004  ;
		r_output	= 32'hb4000000  ;
		r_exeption	= 5'h0          ;
		#5                           
		cnt			= 24			;
		i_mode		= 0				;	
		i_operation	= 1		        ;
		i_inputA	= 32'h00800000  ;
		i_inputB	= 32'h00800001  ;
		r_output	= 32'h80000000  ;
		r_exeption	= 5'h9          ;
		#5                           
		cnt			= 25			;
		i_mode		= 0				;	
		i_operation	= 1		        ;
		i_inputA	= 32'h7f800000  ;
		i_inputB	= 32'h7f800000  ;
		r_output	= 32'h7fc00000  ;
		r_exeption	= 5'h2          ;
		#5                           
		cnt			= 26			;
		i_mode		= 0				;	
		i_operation	= 1		        ;
		i_inputA	= 32'h0fd22000  ;
		i_inputB	= 32'h7fc00000  ;
		r_output	= 32'h7fc00000  ;
		r_exeption	= 5'h2          ;
		#5                           
		cnt			= 27			;
		i_mode		= 1				;	
		i_operation	= 0		        ;
		i_inputA	= 32'hff7ffffe  ;
		i_inputB	= 32'hf3000000  ;
		r_output	= 32'hff7ffffe  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 28			;
		i_mode		= 1				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h7f7ffffe  ;
		i_inputB	= 32'h73000001  ;
		r_output	= 32'h7f7fffff  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 29			;
		i_mode		= 2				;	
		i_operation	= 0		        ;
		i_inputA	= 32'hff7ffffe  ;
		i_inputB	= 32'hf3000000  ;
		r_output	= 32'hff7ffffe  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 30			;
		i_mode		= 2				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h7f7ffffe  ;
		i_inputB	= 32'h73000001  ;
		r_output	= 32'h7f7fffff  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 31			;
		i_mode		= 3				;	
		i_operation	= 0		        ;
		i_inputA	= 32'hff7ffffe  ;
		i_inputB	= 32'hf3000000  ;
		r_output	= 32'hff7fffff  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 32			;
		i_mode		= 3				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h7f7ffffe  ;
		i_inputB	= 32'h73000001  ;
		r_output	= 32'h7f7ffffe  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 33			;
		i_mode		= 4				;	
		i_operation	= 0		        ;
		i_inputA	= 32'hff7ffffe  ;
		i_inputB	= 32'hf3000000  ;
		r_output	= 32'hff7ffffe  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 34			;
		i_mode		= 4				;	
		i_operation	= 0		        ;
		i_inputA	= 32'h7f7ffffe  ;
		i_inputB	= 32'h73000001  ;
		r_output	= 32'h7f7ffffe  ;
		r_exeption	= 5'h1          ;
		#5                           
		cnt			= 35			;
		i_mode		= 0				;	
		i_operation	= 1		        ;
		i_inputA	= 32'h0c800000  ;
		i_inputB	= 32'h0c7fffff  ;
		r_output	= 32'h00800000  ;
		r_exeption	= 5'h0          ;
		#5                           
		i_valid		= 0 			;
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
			$display ("ERROR %d",cnt-1) ;
		end else if ( rd_output[30:0] != 31'h7fc00000 && ( o_output != rd_output || o_exeption != rd_exeption ) ) begin
			error 	<= 1'b1 ;
			$display ("ERROR %d",cnt-1) ;
		end else begin
			error 	<= 1'b0 ;
		end
	end
	
endmodule
    
