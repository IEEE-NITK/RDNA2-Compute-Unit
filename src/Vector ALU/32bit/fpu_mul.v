
`timescale 1ns/100ps

module fpu_mul #(
	parameter BIT_WIDTH					= 32,			// 32, 64, 128
	// Don't touch 
	parameter EXP_WIDTH					= ( BIT_WIDTH == 32 ) ?  8 : ( BIT_WIDTH == 64 ) ? 11 :  15 ,  
	parameter SGN_WIDTH					= ( BIT_WIDTH == 32 ) ? 24 : ( BIT_WIDTH == 64 ) ? 53 : 113 ,
	parameter SIGN_POS					= BIT_WIDTH - 1 , 
	parameter EXP_SPOS					= BIT_WIDTH - 2 , 
	parameter EXP_EPOS					= SGN_WIDTH - 1 , 
	parameter BIAS						= (2 ** (EXP_WIDTH-1)) - 1   
)(    
	input		[2:0]					i_mode,
	input		[BIT_WIDTH-1:0]			i_inputA,
	input		[BIT_WIDTH-1:0]			i_inputB,
	output 		[BIT_WIDTH-1:0]			o_output,
	output 								o_inexact
);
	
	wire								signA ;
	wire		[EXP_WIDTH-1:0]			expA  ;
	wire		[SGN_WIDTH-1:0]			mantissaA ;
	wire								signB ;
	wire		[EXP_WIDTH-1:0]			expB  ;
	wire		[SGN_WIDTH-1:0]			mantissaB ;
	reg			[2+EXP_WIDTH-1:0]		expT0 ;
	reg			[EXP_WIDTH-1:0]			expT1 ;
	wire								signO ;
	wire		[EXP_WIDTH-1:0]			expO  ;
	wire		[SGN_WIDTH-2:0]			mantissaO ;
	reg			[EXP_WIDTH:0]			temp_exp0 ;
	reg			[EXP_WIDTH -1:0]		temp_exp1 ;
	wire		[2*SGN_WIDTH-1:0]		temp_mantissa0 ; // after multiplication
	reg			[SGN_WIDTH :0]	    	temp_mantissa1 ; // before rounding
	reg 		[SGN_WIDTH :0]		    round_sum; // using SGN_WIDTH+1  to find the overflow and hidden bit => overflow + hidden + 23
	reg									stickyBit ;
	wire 								inexact_flag;	
	reg 								normalization;		// using a flag to show which one is overflowed in normalization to add into exponent	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////Separating exponents , signs and mantissa of each input//////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	assign signA 		= i_inputA[BIT_WIDTH-1] ;
	assign expA  		= i_inputA[EXP_SPOS:EXP_EPOS] ;
	assign mantissaA 	= ( i_inputA[BIT_WIDTH-2:0] == 0 ) ? {(SGN_WIDTH){1'b0}} : {1'b1,i_inputA[SGN_WIDTH-2:0]} ;
	assign signB 		= i_inputB[BIT_WIDTH-1] ;     	
	assign expB  		= i_inputB[EXP_SPOS:EXP_EPOS] ;  	
	assign mantissaB 	= ( i_inputB[BIT_WIDTH-2:0] == 0 ) ? {(SGN_WIDTH){1'b0}} : {1'b1,i_inputB[SGN_WIDTH-2:0]} ;   
	

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////    			Assign Sign output and mantissa			//////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	// assigning the sign of multiplication
	assign signO = signA ^ signB;


	// Multipying 
	assign temp_mantissa0 = (mantissaA * mantissaB);


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////    			Normalization    	//////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	

always@(*)begin
		if (temp_mantissa0[2*SGN_WIDTH - 1] == 1'b1) begin // normalizarion of 3.f
			normalization  = 1'b1;
			temp_mantissa1 =   temp_mantissa0  [2*SGN_WIDTH - 1: SGN_WIDTH - 2] >> 1;
			stickyBit      = | temp_mantissa0  [ SGN_WIDTH - 1 : 0];
		end
		else if (temp_mantissa0[2*SGN_WIDTH - 1] == 1'b0) begin // normalizarion of 1.f
			normalization  = 1'b0;
			temp_mantissa1 =   temp_mantissa0 [2*SGN_WIDTH - 1: SGN_WIDTH - 2];
			stickyBit	   = | temp_mantissa0 [ SGN_WIDTH - 2 : 0];
		end
	end




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////    			Rounding			//////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	

	
	// [2*SGN_WIDTH-1: SGN_WIDTH - 2] 25 bit
	//assign temp_mantissa1 = temp_mantissa0 [2*SGN_WIDTH - 1: SGN_WIDTH - 2];  // before rounding 
	// finding sticky bit
	//assign stickyBit = | temp_mantissa0[ SGN_WIDTH - 2 : 0];


	// Rounding
	always@(*)begin
		case(i_mode)
			
			3'b001 : begin // 1 : RoundTiesToAway
				if(signO == 1)begin
					if(temp_mantissa1[0] && stickyBit)begin
						round_sum = temp_mantissa1[SGN_WIDTH  : 1] + 1;
					end
				end
				else if(signO == 0)begin
					if(temp_mantissa1[0])begin
						round_sum = temp_mantissa1[SGN_WIDTH  : 1] + 1;
					end
				end
				else begin
						round_sum = temp_mantissa1[SGN_WIDTH  : 1];
				end
			end
			3'b010 : begin // 2 : RoundTowardPositive
				if(signO == 0)begin
					if(temp_mantissa1[0] || stickyBit)begin
					round_sum = temp_mantissa1[SGN_WIDTH  : 1] + 1;
					end
				end
				else if(signO == 1)begin
					round_sum = temp_mantissa1[SGN_WIDTH  : 1];
				end
			end
			3'b011 : begin // 3 : RoundTowardNegative
				if(signO == 1)begin
					if(temp_mantissa1[0] || stickyBit)begin
					round_sum = temp_mantissa1[SGN_WIDTH  : 1] + 1;
					end
				end
				else if(signO == 0)begin
					round_sum = temp_mantissa1[SGN_WIDTH  : 1];
				end
			end
			3'b100 : begin // 4 : RoundTowardZero
					round_sum = temp_mantissa1[SGN_WIDTH : 1];	
				end
			default : begin // 0 : RoundTiesToEven => default value
				if(temp_mantissa1[0] == 1'b1 && (stickyBit == 1'b1 || temp_mantissa1[1] == 1'b1)) begin
					round_sum = temp_mantissa1[SGN_WIDTH  : 1] + 1;
				end
				else begin
					round_sum = temp_mantissa1[SGN_WIDTH  : 1];
				end
			end
		endcase 
	end

	assign inexact_flag = (stickyBit | temp_mantissa1[0] );

	assign mantissaO = round_sum[SGN_WIDTH -2 : 0]; // removing hiden bit and overflow bit => 23 bit 


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// 						Clipping					//////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	reg flag;
	// before & after clipping  ( compounder adder)
	always@(*)begin
		flag = 1'b0;
		if (normalization == 1'b1)begin
				if(round_sum[SGN_WIDTH ] == 1)begin 								 // check to see if rounding was overflowed
					temp_exp1 = (expA + expB - BIAS + 1 + 1);
					temp_exp0 = (expA + expB - BIAS + 1 + 1);	 // it has extra bit
					if((expA + expB  + 2'b10) >= ({(EXP_WIDTH){1'b1}} + BIAS))begin 	     // if the result overflows we cant have exponent 255
						flag = 1'b1;
						temp_exp1 = {(EXP_WIDTH){1'b1}};
					end
					else if((expA + expB  + 1) < BIAS)begin 	    				 // if the result underflows
						flag = 1'b1;
						temp_exp1 = {(EXP_WIDTH){1'b0}};
				end
				
				end
				else if(round_sum[SGN_WIDTH ] == 0) begin
					temp_exp1 = (expA + expB - BIAS + 1);
					temp_exp0 = (expA + expB - BIAS + 1); // it has extra bit
					if((expA + expB + 1 ) >= ({(EXP_WIDTH){1'b1}} + BIAS))begin 		     // if the result overflows
						flag = 1'b1;
						temp_exp1 = {(EXP_WIDTH){1'b1}};
					end

					else if((expA + expB + 1 ) < BIAS)begin 	    					 // if the result underflows
						flag = 1'b1;
						temp_exp1 = {(EXP_WIDTH){1'b0}};
				end
			end
		end
		else if(round_sum[SGN_WIDTH ] == 1)begin 								 // check to see if rounding was overflowed
				temp_exp1 = (expA + expB - BIAS + 1);
				temp_exp0 = (expA + expB - BIAS + 1);	 // it has extra bit
				if((expA + expB  + 1) >= ({(EXP_WIDTH){1'b1}} + BIAS))begin 	     // if the result overflows we cant have exponent 255
					flag = 1'b1;
					temp_exp1 = {(EXP_WIDTH){1'b1}};
				end
				else if((expA + expB  + 1) < BIAS)begin 	    				 // if the result underflows
					flag = 1'b1;
					temp_exp1 = {(EXP_WIDTH){1'b0}};
			end
			
		end
		else if(round_sum[SGN_WIDTH ] == 0) begin
				temp_exp1 = (expA + expB - BIAS);
				temp_exp0 = (expA + expB - BIAS); // it has extra bit
				if((expA + expB ) >= ({(EXP_WIDTH){1'b1}} + BIAS))begin 		     // if the result overflows
					flag = 1'b1;
					temp_exp1 = {(EXP_WIDTH){1'b1}};
				end

				else if((expA + expB ) < BIAS)begin 	    					 // if the result underflows
					flag = 1'b1;
					temp_exp1 = {(EXP_WIDTH){1'b0}};
			end
		end


	end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// 						Assigning the Out puts        		 /////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	assign expO = temp_exp1; // assigning the exponent
 
	assign o_inexact = (inexact_flag | flag) ? 1 : 0; // assigning inexact out put *** this is including  inexact and overflow and underflow 

	assign o_output = {signO,expO,mantissaO}; // assigning each part

endmodule
