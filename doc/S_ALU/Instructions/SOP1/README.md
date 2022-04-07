# Scalar ALU Opcodes Description

### S_MOV_B32
Move data to an SGPR.
D.u = S0.u.

### S_MOV_B64
Move data to an SGPR.
  D.u64 = S0.u64.

### S_CMOV_B32
Conditionally move data to an SGPR when scalar condition code is
true.
  if(SCC) then
  D.u = S0.u;
  endif.

### S_CMOV_B64 
Conditionally move data to an SGPR when scalar condition code is
true.
  if(SCC) then
  D.u64 = S0.u64;
  endif.

### S_NOT_B32
Bitwise negation.
  D = ~S0;
  SCC = (D != 0)


### S_NOT_B64
Bitwise negation.
  D = ~S0;
  SCC = (D != 0).

### S_WQM_B32
Computes whole quad mode for an active/valid mask. If any pixel
in a quad is active, all pixels of the quad are marked active.
  for i in 0 ... opcode_size_in_bits - 1 do
  D[i] = (S0[(i & ~3):(i | 3)] != 0);
  endfor;
  SCC = (D != 0).

  
### S_WQM_B64
Computes whole quad mode for an active/valid mask. If any pixel
in a quad is active, all pixels of the quad are marked active.
  for i in 0 ... opcode_size_in_bits - 1 do
  D[i] = (S0[(i & ~3):(i | 3)] != 0);
  endfor;
  SCC = (D != 0).

### S_BREV_B32
Reverse bits.
  D.u[31:0] = S0.u[0:31].

### S_BREV_B64
Reverse bits.
  D.u64[63:0] = S0.u64[0:63].
  
### S_BCNT0_I32_B32 
Count number of bits that are zero.
  D = 0;
  for i in 0 ... opcode_size_in_bits - 1 do
  D += (S0[i] == 0 ? 1 : 0)
  endfor;
  SCC = (D != 0).
Functional examples:
S_BCNT0_I32_B32(0x00000000) => 32
S_BCNT0_I32_B32(0xcccccccc) => 16
S_BCNT0_I32_B32(0xffffffff) => 0


### S_BCNT0_I32_B64
Count number of bits that are zero.
  D = 0;
  for i in 0 ... opcode_size_in_bits - 1 do
  D += (S0[i] == 0 ? 1 : 0)
  endfor;
  SCC = (D != 0).
Functional examples:
S_BCNT0_I32_B32(0x00000000) => 32
S_BCNT0_I32_B32(0xcccccccc) => 16
S_BCNT0_I32_B32(0xffffffff) => 0


### S_BCNT1_I32_B32
Count number of bits that are one.
  D = 0;
  for i in 0 ... opcode_size_in_bits - 1 do
  D += (S0[i] == 1 ? 1 : 0)
  endfor;
  SCC = (D != 0).
Functional examples:
S_BCNT1_I32_B32(0x00000000) => 0
S_BCNT1_I32_B32(0xcccccccc) => 16
S_BCNT1_I32_B32(0xffffffff) => 32


### S_BCNT1_I32_B64 
Count number of bits that are one.
  D = 0;
  for i in 0 ... opcode_size_in_bits - 1 do
  D += (S0[i] == 1 ? 1 : 0)
  endfor;
  SCC = (D != 0).
Functional examples:
S_BCNT1_I32_B32(0x00000000) => 0
S_BCNT1_I32_B32(0xcccccccc) => 16
S_BCNT1_I32_B32(0xffffffff) => 32


### S_FF0_I32_B32 
Returns the bit position of the first zero from the LSB (least
significant bit), or -1 if there are no zeros.
  D.i = -1; // Set if no zeros are found
  for i in 0 ... opcode_size_in_bits - 1 do // Search from LSB
  if S0[i] == 0 then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FF0_I32_B32(0xaaaaaaaa) => 0
S_FF0_I32_B32(0x55555555) => 1
S_FF0_I32_B32(0x00000000) => 0
S_FF0_I32_B32(0xffffffff) => 0xffffffff
S_FF0_I32_B32(0xfffeffff) => 16


### S_FF0_I32_B64
Returns the bit position of the first zero from the LSB (least
significant bit), or -1 if there are no zeros.
  D.i = -1; // Set if no zeros are found
  for i in 0 ... opcode_size_in_bits - 1 do // Search from LSB
  if S0[i] == 0 then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FF0_I32_B32(0xaaaaaaaa) => 0
S_FF0_I32_B32(0x55555555) => 1
S_FF0_I32_B32(0x00000000) => 0
S_FF0_I32_B32(0xffffffff) => 0xffffffff
S_FF0_I32_B32(0xfffeffff) => 16


### S_FF1_I32_B32
Returns the bit position of the first zero from the LSB (least
significant bit), or -1 if there are no zeros.
  D.i = -1; // Set if no zeros are found
  for i in 0 ... opcode_size_in_bits - 1 do // Search from LSB
  if S0[i] == 0 then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FF0_I32_B32(0xaaaaaaaa) => 0
S_FF0_I32_B32(0x55555555) => 1
S_FF0_I32_B32(0x00000000) => 0
S_FF0_I32_B32(0xffffffff) => 0xffffffff
S_FF0_I32_B32(0xfffeffff) => 16


### S_FF0_I32_B64
Returns the bit position of the first zero from the LSB (least
significant bit), or -1 if there are no zeros.
  D.i = -1; // Set if no zeros are found
  for i in 0 ... opcode_size_in_bits - 1 do // Search from LSB
  if S0[i] == 0 then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FF0_I32_B32(0xaaaaaaaa) => 0
S_FF0_I32_B32(0x55555555) => 1
S_FF0_I32_B32(0x00000000) => 0
S_FF0_I32_B32(0xffffffff) => 0xffffffff
S_FF0_I32_B32(0xfffeffff) => 16


### S_FF1_I32_B32
Returns the bit position of the first one from the LSB (least
significant bit), or -1 if there are no ones.
  D.i = -1; // Set if no ones are found
  for i in 0 ... opcode_size_in_bits - 1 do // Search from LSB
  if S0[i] == 1 then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FF1_I32_B32(0xaaaaaaaa) => 1
S_FF1_I32_B32(0x55555555) => 0
S_FF1_I32_B32(0x00000000) => 0xffffffff
S_FF1_I32_B32(0xffffffff) => 0
S_FF1_I32_B32(0x00010000) => 16


### S_FF1_I32_B64
Returns the bit position of the first one from the LSB (least
significant bit), or -1 if there are no ones.
  D.i = -1; // Set if no ones are found
  for i in 0 ... opcode_size_in_bits - 1 do // Search from LSB
  if S0[i] == 1 then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FF1_I32_B32(0xaaaaaaaa) => 1
S_FF1_I32_B32(0x55555555) => 0
S_FF1_I32_B32(0x00000000) => 0xffffffff
S_FF1_I32_B32(0xffffffff) => 0
S_FF1_I32_B32(0x00010000) => 16

### S_FLBIT_I32_B32
Counts how many zeros before the first one starting from the MSB
(most significant bit). Returns -1 if there are no ones.
  D.i = -1; // Set if no ones are found
  for i in 0 ... opcode_size_in_bits - 1 do
  // Note: search is from the MSB
  if S0[opcode_size_in_bits - 1 - i] == 1 then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FLBIT_I32_B32(0x00000000) => 0xffffffff
S_FLBIT_I32_B32(0x0000cccc) => 16
S_FLBIT_I32_B32(0xffff3333) => 0
S_FLBIT_I32_B32(0x7fffffff) => 1
S_FLBIT_I32_B32(0x80000000) => 0
S_FLBIT_I32_B32(0xffffffff) => 0


### S_FLBIT_I32_B64
Counts how many zeros before the first one starting from the MSB
(most significant bit). Returns -1 if there are no ones.
  D.i = -1; // Set if no ones are found
  for i in 0 ... opcode_size_in_bits - 1 do
  // Note: search is from the MSB
  if S0[opcode_size_in_bits - 1 - i] == 1 then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FLBIT_I32_B32(0x00000000) => 0xffffffff
S_FLBIT_I32_B32(0x0000cccc) => 16
S_FLBIT_I32_B32(0xffff3333) => 0
S_FLBIT_I32_B32(0x7fffffff) => 1
S_FLBIT_I32_B32(0x80000000) => 0
S_FLBIT_I32_B32(0xffffffff) => 0


### S_FLBIT_I32
Counts how many bits in a row (from MSB to LSB) are the same as
the sign bit. Returns -1 if all bits are the same.
  D.i = -1; // Set if all bits are the same
  for i in 1 ... opcode_size_in_bits - 1 do
  // Note: search is from the MSB
  if S0[opcode_size_in_bits - 1 - i] != S0[opcode_size_in_bits
- 1] then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FLBIT_I32(0x00000000) => 0xffffffff
S_FLBIT_I32(0x0000cccc) => 16
S_FLBIT_I32(0xffff3333) => 16
S_FLBIT_I32(0x7fffffff) => 1
S_FLBIT_I32(0x80000000) => 1
S_FLBIT_I32(0xffffffff) => 0xffffffff


### S_FLBIT_I32_I64
Counts how many bits in a row (from MSB to LSB) are the same as
the sign bit. Returns -1 if all bits are the same.
  D.i = -1; // Set if all bits are the same
  for i in 1 ... opcode_size_in_bits - 1 do
  // Note: search is from the MSB
  if S0[opcode_size_in_bits - 1 - i] != S0[opcode_size_in_bits
- 1] then
  D.i = i;
  break for;
  endif;
  endfor.
Functional examples:
S_FLBIT_I32(0x00000000) => 0xffffffff
S_FLBIT_I32(0x0000cccc) => 16
S_FLBIT_I32(0xffff3333) => 16
S_FLBIT_I32(0x7fffffff) => 1
S_FLBIT_I32(0x80000000) => 1
S_FLBIT_I32(0xffffffff) => 0xffffffff


### S_SEXT_I32_I8
Sign extension of a signed byte.
  D.i = signext(S0.i[7:0]).
  
### S_SEXT_I32_I16
Sign extension of a signed short.
  D.i = signext(S0.i[15:0]).
  
### S_BITSET0_B32
Set a specific bit to zero.
  D.u[S0.u[4:0]] = 0.
  
### S_BITSET0_B64
Set a specific bit to zero.
  D.u64[S0.u[5:0]] = 0.
  
### S_BITSET1_B32
Set a specific bit to one.
  D.u[S0.u[4:0]] = 1.
  
### S_BITSET1_B64
Set a specific bit to one.
  D.u64[S0.u[5:0]] = 1.
  
### S_GETPC_B64
Save current program location. Destination receives the byte
address of the next instruction. Note that this instruction is
always 4 bytes in size.
  D.u64 = PC + 4.
  
### S_SETPC_B64
Jump to a new location. S0.u64 is a byte address of the
instruction to jump to.
  PC = S0.u64.
  
### S_SWAPPC_B64
Save current program location and jump to a new location. S0.u64
is a byte address of the instruction to jump to. Destination
receives the byte address of the instruction immediately following
the SWAPPC instruction. Note that this instruction is always 4
bytes.
  D.u64 = PC + 4;
  PC = S0.u64.







 






    
  
  
           
  

  
  
  
