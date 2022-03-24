`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IEEE NITK
// Engineer: 
// 
// Create Date: 14.01.2022 03:27:44
// Design Name: Scalar ALU Unit
// Module Name: S_ALU
// Project Name: RDNA2 Compute Unit 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module S_ALU(
    instruction,
    clock
);
// Including Header files
    `include "SOP1.vh"
    `include "SOPK.vh"
    `include "scalars.vh "
// Input 64 bit Instruction. 
    input [31:0] instruction;
   input clock;
   
    wire [6:0] SDST;
    wire [7:0] SSRC1, SSRC0;
    wire [16:0] SIMM;
    wire [6:0] op;
    wire [7:0] SOP1_op;
    wire [7:0] SOPK_op;
    wire [6:0] SOPC_SOPP_op;
    
    integer i;
   
    assign op = instruction[29:23];
    assign SOP1_op = instruction[15:8];
    assign SOPK_op = instruction[27:23];
    assign SOPC_SOPP_op  = instruction[22:16];
    
    assign SDST = instruction[22:16];
    assign SSRC0 = instruction[7:0];
    assign SSRC1 = instruction[15:8];
    assign SIMM = instruction[15:0];
    
    //select lines s0 and s1 for reading reading values at r0 and r1.
    //select line w0 for writing value(wv) in the register file.
    reg [7:0]s0, s1, w0;
    reg [63:0] wv,  EXEC_in;
    reg en_w, VCCZ_in, en_64, SCC_in,  EXECZ_in;
    wire  [63:0] EXEC_out, r0, r1;
    wire  VCCZ_out, SCC_out, EXECZ_out;
    
    
    regFile regFile(
    .s0(s0), 
    .s1(s1),
    .w0(w0), 
    .wv(wv),
    .clock(clock), 
    .en_w(en_w),
    .r0(r0),
    .r1(r1),  
    .en_64(en_64),
    .VCCZ_in(VCCZ_in), 
    .VCCZ_out(VCCZ_out),
    .EXECZ_in(EXECZ_in), 
    .EXECZ_out (EXECZ_out),
    .SCC_in(SCC_in), 
    .SCC_out(SCC_out),
    .EXEC_in(EXEC_in ), 
    .EXEC_out(EXEC_out 
    ));
    
    wire [7:0] PC_IN, PC_OUT;
    wire SET_PC;
    Program_Counter PC(
    .PC_IN(PC_IN),
    .PC_OUT(PC_OUT),
    .SET_PC(SET_PC));
    
    always@(posedge clock)
    begin
    en_w =0; 
    en_64 =0;
    SET_PC =0;
    casex(op)
    //ALU operations for SOP1
        {SOP1}: begin
        casex(SOP1_op)
        S_MOV_B32: begin
                s0 = SSRC0;
                w0 = SDST;
                wv[31:0] = r0[31:0];
                en_w=1;
                end
        S_MOV_B64: begin
                s0 = SSRC0;
                w0 = SDST;
                wv = r0;
                en_64 = 1;
                en_w=1;
                end
        S_CMOV_B32: begin
                if(SCC_out) begin
                    s0 = SSRC0;
                    w0 = SDST;
                    wv[31:0] = r0[31:0];
                    en_w=1;
                    end
                end
        S_CMOV_B64: begin
                if(SCC_out) begin
                    s0 = SSRC0;
                    w0 = SDST;
                    wv = r0;
                    en_64 = 1;
                    en_w=1;
                    end
                end
        S_NOT_B32: begin
                s0 = SSRC0;
                w0 = SDST;
                wv[31:0] = ~r0[31:0];
                en_w=1;
                SCC_in = (wv[31:0]!=0);
                end
        S_NOT_B64: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv = ~r0;
                en_64 = 1;
                en_w = 1;
                SCC_in = (wv!=0);
                end
        S_WQM_B32: begin 
                //D[i] = (S0[(i & ~3):(i | 3)] != 0);
                s0 = SSRC0;
                w0 = SDST;
                //for(i=0; i <32; i=i+1) begin
                //    wv[i] =  (r0[(i & ~3):(i | 3)] != 0);
                //end
                en_w = 1;
                SCC_in = (wv[31:0]!=0);
                end
        S_WQM_B64: begin 
                // need to find another method for the loop since we cant have variable on both side of slice indexes.
                end
        S_BREV_B32: begin 
                s0 = SSRC0;
                w0 = SDST;
                for( i=0; i<32; i=i+1) begin
                    wv[i] = r0[31-i];
                    end
                en_w=1;
                end
        S_BREV_B64: begin 
                s0 = SSRC0;
                w0 = SDST;
                for( i=0; i<64; i=i+1) begin
                    wv[i] = r0[63-i];
                    end
                en_64 =1;
                en_w=1;
                end
        S_BCNT0_I32_B32: begin
                s0 = SSRC0;
                w0 = SDST;
                wv =0;
                for( i=0; i<32; i=i+1) begin
                    wv = wv + ((r0[i] == 0) ? 1:0);
                    end
                en_w=1;
                SCC_in = (wv!=0);
                end 
        S_BCNT0_I32_B64: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv =0;
                for( i=0; i<64; i=i+1) begin
                    wv = wv + ((r0[i] == 0) ? 1:0);
                    end
                //en_64 = 1;
                en_w= 1;
                SCC_in = (wv!=0);
                end 
        S_BCNT1_I32_B32: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv =0;
                for( i=0; i<32; i=i+1) begin
                    wv = wv + ((r0[i] == 1) ? 1:0);
                    end
                en_w=1;
                SCC_in = (wv!=0);
                end 
        S_BCNT1_I32_B64: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv =0;
                for( i=0; i<64; i=i+1) begin
                    wv = wv + ((r0[i] == 1) ? 1:0);
                    end
                //en_64 = 1;
                en_w= 1;
                SCC_in = (wv!=0);
                end 
        S_FF0_I32_B32: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv = -1;
                for( i=0; i<32; i=i+1) begin
                    if(r0[i]==0 && wv==-1) wv= i;
                    end
                en_w=1;
                end  
        S_FF0_I32_B64: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv = -1;
                for( i=0; i<64; i=i+1) begin
                    if(r0[i]==0 && wv==-1) wv= i;
                    end
                //en_64 = 1;
                en_w= 1;
                end 
        S_FF1_I32_B32: begin
                s0 = SSRC0;
                w0 = SDST;
                wv = -1;
                for( i=0; i<32; i=i+1) begin
                    if(r0[i]==1 && wv==-1) wv= i;
                    end
                en_w=1;
                end 
        S_FF1_I32_B64: begin
                s0 = SSRC0;
                w0 = SDST;
                wv = -1;
                for( i=0; i<64; i=i+1) begin
                    if(r0[i]==1 && wv==-1) wv= i;
                    end
                //en_64 = 1;
                en_w= 1;
                end  
        S_FLBIT_I32_B32: begin
                s0 = SSRC0;
                w0 = SDST;
                wv = -1;
                for( i=0; i<32; i=i+1) begin
                    if(r0[31-i]==1 && wv==-1) wv= i;
                    end
                wv = (wv!=-1) ? (wv-1):-1;
                en_w=1;
                end 
        S_FLBIT_I32_B64: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv = -1;
                for( i=0; i<64; i=i+1) begin
                    if(r0[63-i]==1 && wv==-1) wv= i;
                    end
                wv = (wv!=-1) ? (wv-1):-1;
                //en_64 = 1;
                en_w= 1;
                end 
        S_FLBIT_I32: begin
                s0 = SSRC0;
                w0 = SDST;
                wv = -1;
                for( i=1; i<32; i=i+1) begin
                    if(r0[31-i]!=r0[31] && wv==-1) wv= i;
                    end
                wv = (wv!=-1) ? (wv-1):-1;
                en_w=1;
                end 
        S_FLBIT_I32_I64: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv = -1;
                for( i=1; i<64; i=i+1) begin
                    if(r0[63-i]!=r0[63] && wv==-1) wv= i;
                    end
                wv = (wv!=-1) ? (wv-1):-1;
                //en_64 = 1;
                en_w= 1;
                end 
        S_SEXT_I32_I8: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv = {{24{r0[7]}}, r0[7:0]};
                en_w = 1;
                end 
        S_SEXT_I32_I16: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv = {{16{r0[15]}}, r0[15:0]};
                en_w = 1;
                end 
        S_BITSET0_B32: begin 
                s0 = SSRC0;
                w0 = SDST;
                s1 = SDST;
                wv = s1;
                wv[s0[4:0]]=0;
                en_w = 1;
                end 
        S_BITSET0_B64: begin 
                s0 = SSRC0;
                w0 = SDST;
                s1 = SDST;
                wv = s1;
                wv[s0[5:0]]=0;
                en_64 = 1;
                en_w = 1;
                end  
        S_BITSET1_B32: begin 
                s0 = SSRC0;
                w0 = SDST;
                s1 = SDST;
                wv = s1;
                wv[s0[4:0]]=1;
                en_w = 1;
                end 
        S_BITSET1_B64: begin 
                s0 = SSRC0;
                w0 = SDST;
                s1 = SDST;
                wv = s1;
                wv[s0[5:0]]=1;
                en_64 = 1;
                en_w = 1;
                end 
        S_GETPC_B64: begin 
                w0 = SDST;
                wv = PC_IN + 4;
                en_64 = 1;
                en_w = 1;
                end 
        S_SETPC_B64: begin 
                s0 = SSRC0;
                PC_IN = r0[7:0];
                SET_PC = 1;
                end 
        S_SWAPPC_B64: begin 
                s0 = SSRC0;
                w0 = SDST;
                wv = PC_IN + 4;
                en_64 = 1;
                en_w = 1;
                PC_IN = r0[7:0];
                SET_PC = 1;
                end 
        S_RFE_B64: begin 
                
                end 
        S_AND_SAVEEXEC_B64: begin 
                
                end 
        

        endcase 
        end
    //ALU operations for SOPP
    {SOPP}:begin
        casex(SOPC_SOPP_op)
        
        endcase
    end
    //ALU operations for SOPC
    {SOPC}:begin
        casex(SOPC_SOPP_op)
        
        endcase
    end
    //ALU operations for SOPK
    {SOPK, 3'bxxx}:begin
        casex(SOPK_op)
        
        endcase
    end
    //ALU operations for SOP2
    
    endcase 
    end
    //disabling write enabled
    always @ (negedge clock)
    begin
    en_w <=0;
    end
endmodule
