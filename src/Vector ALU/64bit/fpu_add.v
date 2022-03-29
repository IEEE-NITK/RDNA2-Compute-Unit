`timescale 1ns/100ps

module fpu_add #(
	parameter BIT_WIDTH					= 64,			// 32, 64, 128
	// Don't touch 
	parameter EXP_WIDTH					= ( BIT_WIDTH == 32 ) ?  8 : ( BIT_WIDTH == 64 ) ? 11 :  15 ,  
	parameter SGN_WIDTH					= ( BIT_WIDTH == 32 ) ? 24 : ( BIT_WIDTH == 64 ) ? 53 : 113 ,
	parameter SIGN_POS					= BIT_WIDTH - 1 , 
	parameter EXP_SPOS					= BIT_WIDTH - 2 , 
	parameter EXP_EPOS					= SGN_WIDTH - 1 , 
	parameter BIAS						= (2 ** (EXP_WIDTH-1)) - 1   
)(      
	input		[2:0]					i_mode,
	input								i_operation,	// [0] : add , [1] : sub
	input		[BIT_WIDTH-1:0]			i_inputA,
	input		[BIT_WIDTH-1:0]			i_inputB,
	output reg 		[BIT_WIDTH-1:0]			o_output,
	output								o_inexact
);
	
	wire								signA;
	wire		[EXP_WIDTH-1:0]			expA;
	wire		[SGN_WIDTH-1:0]			mantissaA;
	wire								signB;
	wire		[EXP_WIDTH-1:0]			expB;
	wire		[SGN_WIDTH-1:0]			mantissaB;
	reg 								signO;
	wire		[EXP_WIDTH-1:0]			expO;
	wire		[SGN_WIDTH-2:0]			mantissaO; // output mantissa diesnt have hidden bit

	reg			[SGN_WIDTH-1:0]			temp_mantissa1;     // after mux
	reg 		[SGN_WIDTH-1:0]			temp_mantissa2;		// after mux

	reg			[SGN_WIDTH + 2:0]		reg_temp_long_mantissa1; // out put after shift
	wire		[SGN_WIDTH + 2:0]		temp_long_mantissa1; 	 // after shift
	wire		[SGN_WIDTH + 2:0]		temp_long_mantissa2; 	 // after shift
	wire		[SGN_WIDTH + 2:0]		mantissa_b4_shifting;

	wire		[SGN_WIDTH + 3:0]		temp_sum;   // after addition
	wire		[SGN_WIDTH + 3:0]		temp2_sum;	// before lzd	
	wire		[SGN_WIDTH + 3:0]		temp3_out;	// after rl shifter	and removing the hidden bit
	reg			[SGN_WIDTH - 1:0]		round_sum;	//while rounding
	reg			[EXP_WIDTH - 1:0]		temp_expO; 		//before lzd
	reg			[EXP_WIDTH - 1:0]		temp2_expO; 		//before clipping
	reg			[EXP_WIDTH :0]			temp3_expO; // during clipping
	wire 								inexact_flag; // finding inexact during rounding
	wire		[EXP_WIDTH-1:0]			temp_long_exp1; // assigning temp exponent for addition part
	wire 		[SGN_WIDTH-1:0]			tem4_out; // final mantissa
	wire 								stickyBit;
	wire 								roundBit;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////Separating exponents , signs and mantissa of each input//////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	assign signA 		= i_inputA[BIT_WIDTH-1] ;
	assign expA  		= i_inputA[EXP_SPOS:EXP_EPOS] ;
	assign mantissaA 	= ( i_inputA[BIT_WIDTH-2:0] == 0 ) ? {(SGN_WIDTH){1'b0}} : {1'b1,i_inputA[SGN_WIDTH-2:0]} ;
	assign signB 		= i_inputB[BIT_WIDTH-1] ^ i_operation ;    	
	assign expB  		= i_inputB[EXP_SPOS:EXP_EPOS] ;  	
	assign mantissaB 	= ( i_inputB[BIT_WIDTH-2:0] == 0 ) ? {(SGN_WIDTH){1'b0}} : {1'b1,i_inputB[SGN_WIDTH-2:0]} ;  

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Calculating the Sign and Exp, Mantissa difference //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// calculating sign difference 32bit => sigDiff[23:0] same length as mantissa
	wire [SGN_WIDTH-1:0] sigDiff;
	assign sigDiff[SGN_WIDTH-1:0] = {1'b0,mantissaB[SGN_WIDTH-2:0]} + ~{1'b0,mantissaA[SGN_WIDTH-2:0]} + 1;

	// calculating exponent difference 32bit => expDiff[8:0] onebit longer than actual exponent 9 bits in the case of single precision
	wire [EXP_WIDTH:0] expDiff;
	assign expDiff[EXP_WIDTH:0] = {1'b0,expA} - {1'b0,expB};	

	// Finding the sign of output
	// 32 bit example (single presicion)
	// sign = (is same) ? (signdiff[23]) ? S2 : S1 : (expDiff[8]) ? S1 : S2;
	//assign signO 		= ( expA == expB ) ? sigDiff[SGN_WIDTH-1] ? signB : signA : expDiff[EXP_WIDTH] ? signB : signA;
	always@(*)begin
	 
		if ( expA == expB ) begin
		 		if (mantissaA > mantissaB) begin
		 			signO = signA;
		 		end
		  
				else if(mantissaA < mantissaB)begin
		 			signO = signB;
				end

				else if(mantissaA == mantissaB)begin
			 			if(signA == signB)begin
			 			signO = signA;
						end
						else begin
			 			signO = 1'b0;
						end
				end
		end
		else if({1'b0, expA} > {1'b0,expB})begin
			signO = signA;
		end
		else begin
			signO = signB;
		end
	end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// 						Shifting					//////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	

	// 1. First we find the larger and smaller number
	//mux_2to1 #(SGN_WIDTH)mux1(mantissaA, mantissaB, expDiff[EXP_WIDTH], temp_mantissa1a); // Choosing smaller number
	//mux_2to1 #(SGN_WIDTH)mux2(mantissaA, mantissaB, ~expDiff[EXP_WIDTH], temp_mantissa2a);  // Choosing larger number

	always@(*)begin

		if (expA == expB)begin
			if(signA !== signB && i_operation)begin
			temp_mantissa1 = mantissaB;
			temp_mantissa2 = mantissaA;
			end
			else begin
			temp_mantissa1 = mantissaA;
			temp_mantissa2 = mantissaB;
			end
		end
		else if(expA > expB)begin
			temp_mantissa1 = mantissaB;
			temp_mantissa2 = mantissaA;
		end
		else begin
			temp_mantissa1 = mantissaA;
			temp_mantissa2 = mantissaB;
		end

	end


	// 2. Then we find the exponent difference of those two numbers in step 1
	wire [EXP_WIDTH-1:0] temp_expDiff; // Number of required shifts
	// Also temp_expDiff shows the difference between the exponents.
	mux_2to1 #(EXP_WIDTH)mux3(expDiff[EXP_WIDTH-1:0], (~expDiff[EXP_WIDTH-1:0] + 1'b1), ~expDiff[EXP_WIDTH], temp_expDiff); 
	

	// 3. Shifting
	// We shift the selected number in step 1
	// Then we take out 27 bits
	// Then make sticky bits with the remainings
	// Out put of the shift is reg_temp_long_mantissa1 
	assign mantissa_b4_shifting = {temp_mantissa1,3'b000};
	always@(*)begin
	case (temp_expDiff[7:0])
		
			8'b0000_0000 : begin
				reg_temp_long_mantissa1 = mantissa_b4_shifting ;
				
			end
			8'b0000_0001 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 1);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[1:0];
			end
		 	8'b0000_0010 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 2);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[2:0];
			end
			8'b0000_0011 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 3);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[3:0];
			end
			8'b0000_0100 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 4);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[4:0];
			end
			8'b0000_0101 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 5);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[5:0];
			end
			8'b0000_0110 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 6);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[6:0];
			end
			8'b0000_0111 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 7);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[7:0];
			end
			8'b0000_1000 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 8);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[8:0];
			end
			8'b0000_1001 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 9);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[9:0];
			end
			8'b0000_1010 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 10);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[10:0];
			end
			8'b0000_1011 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 11);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[11:0];
			end
			8'b0000_1100 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 12);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[12:0];
			end
			8'b0000_1101 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 13);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[13:0];
			end
			8'b0000_1110 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 14);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[14:0];
			end
			8'b0000_1111 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 15);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[15:0];
			end
			8'b0001_0000 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 16);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[16:0];
			end
			8'b0001_0001 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 17);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[17:0];
			end
			8'b0001_0010 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 18);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[18:0];
			end
			8'b0001_0011 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 19);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[19:0];
			end
			8'b0001_0100 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 20);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[20:0];
			end
			8'b0001_0101 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 21);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[21:0];
			end
			8'b0001_0110 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 22);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[22:0];
			end
			8'b0001_0111 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 23);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[23:0];
			end
			8'b0001_1000 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 24);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[24:0];
			end
			8'b0001_1001 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 25);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[25:0];
			end
			8'b0001_1010 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 26);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[26:0];
			end
			8'b0001_1011 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 27);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[27:0];
			end
			8'b0001_1100 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 28);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[28:0];
			end
			8'b0001_1101 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 29);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[29:0];
			end
			8'b0001_1110 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 30);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[30:0];
			end
			8'b0001_1111 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 31);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[31:0];
			end
			8'b0010_0000 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 32);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[32:0];
			end
			8'b0010_0001 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 33);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[33:0];
			end
			8'b0010_0010 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 34);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[34:0];
			end
			8'b0010_0011 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 35);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[35:0];
			end
			8'b0010_0100 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 36);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[36:0];
			end
			8'b0010_0101 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 37);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[37:0];
			end
			8'b0010_0110 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 38);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[38:0];
			end
			8'b0010_0111 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 39);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[39:0];
			end
			8'b0010_1000 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 40);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[40:0];
			end
			8'b0010_1001 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 41);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[41:0];
			end
			8'b0010_1010 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 42);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[42:0];
			end
			8'b0010_1011 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 43);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[43:0];
			end
			8'b0010_1100 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 44);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[44:0];
			end
			8'b0010_1101 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 45);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[45:0];
			end
			8'b0010_1110 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 46);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[46:0];
			end
			8'b0010_1111 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 47);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[47:0];
			end
			8'b0011_0000 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 48);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[48:0];
			end
			8'b0011_0001 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 49);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[49:0];
			end
			8'b0011_0010 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 50);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[50:0];
			end
			8'b0011_0011 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 51);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[51:0];
			end
			8'b0011_0100 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 52);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[52:0];
			end
			8'b0011_0101 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 53);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[53:0];
			end
			8'b0011_0110 : begin
				reg_temp_long_mantissa1 = (mantissa_b4_shifting >> 54);
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[54:0];
			end
			default: begin
				reg_temp_long_mantissa1 [SGN_WIDTH + 2 : 1] = ({(SGN_WIDTH + 2){1'b0}});
				reg_temp_long_mantissa1[0] = | mantissa_b4_shifting[54:0];
			end
		 	    
		endcase
	end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// 						normalization & LZD         //////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	assign temp_long_exp1 = ( temp_mantissa1 == mantissaA ) ? mantissaA : mantissaB;
	assign temp_long_mantissa1 = reg_temp_long_mantissa1;
	// Shifting the larger 3 size to left to match the sizes
	assign temp_long_mantissa2 = {temp_mantissa2,3'b000};

	wire op;
	assign op = (signA == signB ) ? 1'b0 : 1'b1; // CHoosing ADD 0  SUB 1
	// Adder	 
	assign temp_sum = (op == 0)    ? ({1'b0,temp_long_mantissa1} + {1'b0,temp_long_mantissa2} ) : (
					  (temp_long_exp1 == 0) ? ({1'b0,temp_long_mantissa1} + (~{1'b0,temp_long_mantissa2} + 1) ) : (
					   ({1'b0,temp_long_mantissa2} + (~{1'b0,temp_long_mantissa1} + 1))));

	wire select;
	assign select = ((temp_expDiff == {(EXP_WIDTH){1'b0}}) &&(~(sigDiff[SGN_WIDTH-1])) && (i_operation))  ? 1 : 0;
	mux_2to1 #(SGN_WIDTH + 4)mux4({2'b0,sigDiff[SGN_WIDTH-2:0],3'b0}, temp_sum, select, temp2_sum);

	wire [EXP_WIDTH-1:0] cnt_temp; // counting leading zero
	lzd #(SGN_WIDTH + 4,EXP_WIDTH)lzd0 (temp2_sum,cnt_temp);

	// case1) cnt_temp = 0, in this case, one bit right shift is needed
	// case2) cnt_temp = 1, in this case, no shift is needed
	// case3) cnt_temp > 1, in this case, (cnt_temp-1) left shift is needed
	wire dir; // dir 1 : left shift, 0 : right shift => to make the hidden bit
	wire [EXP_WIDTH-1:0] cnt1;
	wire [EXP_WIDTH-1:0] cnt;
	assign dir = (cnt_temp == 0) ? 1'b0 : ( // this is  3.f
				 (cnt_temp == 1) ? 1'b0 : 1'b1 );
	assign cnt1 = (cnt_temp == 0) ? {{(EXP_WIDTH - 1){1'b0}} , 1'b1} : (
				 (cnt_temp == 1) ? {(EXP_WIDTH){1'b0}} : (cnt_temp - 1'b1));
	assign cnt = (cnt1 > SGN_WIDTH) ? SGN_WIDTH : cnt1;
	// setting normalization flag
	// handling 3.f and 1.f
	assign normalization = (cnt_temp == 0) ? 1'b1 : 1'b0; 

	// rl shifter
	rl_shifter #(SGN_WIDTH + 4,EXP_WIDTH) rl_shift(temp2_sum,dir,cnt,temp3_out);
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// 						Rounding					//////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	

	assign tem4_out = {1'b0 , temp3_out[SGN_WIDTH + 1 : 3] };
	assign stickyBit = | temp3_out[1 : 0];
	assign roundBit = temp3_out[2];


	// Rounding
	always@(*)begin
			
			if (i_mode == 3'b001 ) begin // 1 : RoundTiesToAway
				if(signO == 1)begin
					if(roundBit && stickyBit)begin
						round_sum = tem4_out + 1'b1;
					end
					else begin
						round_sum = tem4_out;
					end
				end
				else if(signO == 0)begin
					if(roundBit)begin
						round_sum = tem4_out + 1'b1;
					end
					else begin
						round_sum = tem4_out;
					end	
				end
			end
			else if (i_mode == 3'b010) begin // 2 : RoundTowardPositive
				if(signO == 0)begin
					if(roundBit || stickyBit)begin
					round_sum = tem4_out + 1'b1;
					end
				end
				else if(signO == 1)begin
					round_sum = tem4_out;
				end
			end
			else if (i_mode == 3'b011) begin // 3 : RoundTowardNegative
				if(signO == 1)begin
					if(roundBit || stickyBit)begin
					round_sum = tem4_out + 1'b1;
					end
				end
				else if(signO == 0)begin
					round_sum = tem4_out;
				end
			end
			else if (i_mode == 3'b100) begin // 4 : RoundTowardZero
					round_sum = tem4_out;	
		
			end
			else begin // 0 : RoundTiesToEven => default value
				if(roundBit ==1'b1 && (stickyBit == 1'b1 || tem4_out[0] == 1'b1))begin
					round_sum = tem4_out + 1'b1;
				end
				else begin
					round_sum = tem4_out;
				end
			end
			
	end		 
	// set the inexact flag by finding the errors
	assign inexact_flag = (roundBit || stickyBit) ? 1 : 0;
	

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// 						Clipping					//////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		

	// Find the larger exponent
	//mux_2to1 #(EXP_WIDTH)mux5(expA, expB, expDiff[EXP_WIDTH], temp_expO);

	always@(*)begin
	 
		if ( expA == expB ) begin
		 	temp_expO	= expA;
				
		end
		else if({1'b0, expA} > {1'b0,expB})begin
			temp_expO	= expA;
		end
		else begin
			temp_expO	= expB;
		end
	end

	// before & after clipping  ( compounder adder)
	reg [EXP_WIDTH-1:0]  fn_cnt;
	reg flag;
	always@(*)begin
		flag = 1'b0;

		if(temp2_sum == 0  && cnt !== 0)begin // using this to avoid unwanted shifts
			fn_cnt = 0;
		end
		else begin
		fn_cnt = cnt;
		end

		if (normalization == 1'b1)begin
			if(round_sum[SGN_WIDTH - 1 ] == 1)begin 									// If over signal received from rounding
				temp3_expO = (temp_expO + 2);
				temp2_expO = temp3_expO[EXP_WIDTH-1 : 0]; 
				if(temp3_expO[EXP_WIDTH] || temp2_expO == {(EXP_WIDTH){1'b1}})begin 											// if the result overflows
					flag = 1'b1;
					temp2_expO = {(EXP_WIDTH){1'b1}};
					round_sum= 0;
				end
			end
			else if(round_sum[SGN_WIDTH - 1] == 0) begin 
				temp3_expO = (temp_expO + 1);											
				temp2_expO = temp3_expO[EXP_WIDTH-1 : 0]; 
				if(temp3_expO[EXP_WIDTH] || temp2_expO == {(EXP_WIDTH){1'b1}})begin 											// if the result overflows
					flag = 1'b1;
					temp2_expO = {(EXP_WIDTH){1'b1}};
					round_sum= 0;
				end
			end
		end

		else begin 

			if(round_sum[SGN_WIDTH - 1 ] == 1)begin 										// If over signal received from rounding
				temp3_expO = (temp_expO - fn_cnt + 1);
				temp2_expO = temp3_expO[EXP_WIDTH-1 : 0]; 
				if(temp3_expO[EXP_WIDTH])begin 												// if the result overflows
					flag = 1'b1;
					temp2_expO = {(EXP_WIDTH){1'b1}};
					round_sum= 0;
				end
			end
			else if(round_sum[SGN_WIDTH - 1 ] == 0) begin
				temp3_expO = (temp_expO - fn_cnt);  									// No over signal from Rounding
				temp2_expO = (temp_expO - fn_cnt); 	
				if ( fn_cnt == 0 )begin
					temp2_expO = temp_expO;
				end			
				 if((temp_expO < {1'b0,fn_cnt}))begin 											// if the result underflows
					flag = 1'b1;
					temp2_expO = {(EXP_WIDTH){1'b0}}; 
				end
			end
		end 
end// end of clipping


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// 					Assigning the Out puts        		 /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// assigning exponent 
	assign expO = temp2_expO;
	// clipping
	
reg check;
	// set mantissa
	assign mantissaO = round_sum[SGN_WIDTH-2 : 0];
always@(*)begin
check = 1'b1;

	if(temp2_sum == 0)begin
				if (signA && signB) begin
					o_output = {signA,{(EXP_WIDTH){1'b0}},{(SGN_WIDTH-1){1'b0}}};
				end
				else if (signA || signB) begin
					o_output = {signO,{(EXP_WIDTH){1'b0}},{(SGN_WIDTH-1){1'b0}}};
				end
				else begin
					o_output = 0;
				end
	end	
	else if(i_operation == 1'b1 && mantissaA == 0 && expA == 0) begin
			o_output = {signB,expB,mantissaB[SGN_WIDTH-2:0]};
			check = 0;
	end
	else begin
			o_output = {signO,expO,mantissaO};
	end
end

assign o_inexact = (inexact_flag | flag)&check ? 1 : 0; // using or to find the inexact exception flag
	
endmodule




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// 					Other Modules                		 /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module mux_2to1(a, b, sel, out);
	parameter W = 24;
	input [W-1:0] a;
	input [W-1:0] b;
	input sel;
	output [W-1:0] out;
	reg [W-1:0] out;

	always@(*) begin
		if (sel == 1'b1)
			out = a;
		else
			out = b;
	end
endmodule

module lzd(a, cnt);
	parameter W = 28;
	parameter Z = 8;
	input [W-1:0] a;
	output [Z-1:0] cnt; // The number of leading-zeros of input a.

	reg [Z-1:0] cnt;

	integer i;
	always@(*) begin
		i = W-1;
		cnt = {(Z-1){1'b0}};
		while (a[i] == 0) begin
			cnt = cnt + 1;
			i = i-1;
		end
	end
endmodule

module rl_shifter(a, dir, s, out);
	parameter W = 28;
	parameter Z = 8;
	input [W-1:0] a;
	input dir;
	input [Z-1:0] s; // Shift amount
	output reg [W-1:0] out;
	
	reg [W-1:0] temp_out;
	reg t;
	always@(*) begin
		if (dir == 1'b1)begin // left shift
			temp_out = a << s;
			out = temp_out[W-1:0];
		end
		else if (dir==1'b0) begin// right shift
			if (s == 0) begin
			temp_out = a;
			out = temp_out;
			end
			else if(s == 1'b1) begin
			t = | a[1:0];
			temp_out = {1'b0,a[W-1:1]};
			out = {temp_out[W-1:1],t};
			end
		end
	end

	
endmodule