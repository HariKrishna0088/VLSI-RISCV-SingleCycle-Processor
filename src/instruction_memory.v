//=============================================================================
// Module: instruction_memory
// Description: Read-only instruction memory for RISC-V processor
// Author: Daggolu Hari Krishna
//
// 256 x 32-bit instruction memory (1KB)
// Word-addressed using pc[9:2]
//=============================================================================

module instruction_memory (
    input  wire [31:0] addr,
    output wire [31:0] instruction
);

    reg [31:0] mem [0:255]; // 256 words of 32-bit instructions

    // Word-aligned read (address bits [9:2] select the word)
    assign instruction = mem[addr[9:2]];

    // Pre-load test program
    initial begin
        // Program: Simple arithmetic and memory test
        //
        // ADDI x1, x0, 5      -> x1 = 5
        // ADDI x2, x0, 10     -> x2 = 10
        // ADD  x3, x1, x2     -> x3 = 15
        // SUB  x4, x2, x1     -> x4 = 5
        // AND  x5, x1, x2     -> x5 = x1 & x2
        // OR   x6, x1, x2     -> x6 = x1 | x2
        // SW   x3, 0(x0)      -> MEM[0] = 15
        // LW   x7, 0(x0)      -> x7 = MEM[0] = 15
        // BEQ  x1, x4, +8     -> branch if x1 == x4 (both 5, should branch)
        // ADDI x8, x0, 99     -> x8 = 99 (skipped if branch taken)
        // ADDI x9, x0, 42     -> x9 = 42 (branch target)

        mem[0]  = 32'h00500093; // ADDI x1, x0, 5
        mem[1]  = 32'h00A00113; // ADDI x2, x0, 10
        mem[2]  = 32'h002081B3; // ADD  x3, x1, x2
        mem[3]  = 32'h40110233; // SUB  x4, x2, x1
        mem[4]  = 32'h0020F2B3; // AND  x5, x1, x2
        mem[5]  = 32'h0020E333; // OR   x6, x1, x2
        mem[6]  = 32'h00302023; // SW   x3, 0(x0)
        mem[7]  = 32'h00002383; // LW   x7, 0(x0)
        mem[8]  = 32'h00408463; // BEQ  x1, x4, +8
        mem[9]  = 32'h06300413; // ADDI x8, x0, 99
        mem[10] = 32'h02A00493; // ADDI x9, x0, 42
    end

endmodule
