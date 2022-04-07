This module is made to implement the program counter.

The program counter (PC) is a byte address pointing to the next instruction to execute.
When a wavefront is created, the PC is initialized to the first instruction in the program.
The PC interacts with three instructions:
S_GET_PC, S_SET_PC, S_SWAP_PC. 

These transfer the PC to, and from, an even-aligned SGPR pair.
Branches jump to (PC_of_the_instruction_after_the_branch + offset). 
