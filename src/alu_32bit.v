//=============================================================================
// Module: alu_32bit
// Description: 32-bit ALU for RISC-V Processor
// Author: Daggolu Hari Krishna
//
// ALU Control:
//   4'b0000 - ADD
//   4'b0001 - SUB
//   4'b0010 - AND
//   4'b0011 - OR
//   4'b0100 - XOR
//   4'b0101 - SLL (Shift Left Logical)
//   4'b0110 - SRL (Shift Right Logical)
//   4'b0111 - SRA (Shift Right Arithmetic)
//   4'b1000 - SLT (Set Less Than, signed)
//   4'b1001 - SLTU (Set Less Than, unsigned)
//=============================================================================

module alu_32bit (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_control,
    output reg  [31:0] alu_result,
    output wire        zero_flag
);

    assign zero_flag = (alu_result == 32'd0);

    always @(*) begin
        case (alu_control)
            4'b0000: alu_result = a + b;                              // ADD
            4'b0001: alu_result = a - b;                              // SUB
            4'b0010: alu_result = a & b;                              // AND
            4'b0011: alu_result = a | b;                              // OR
            4'b0100: alu_result = a ^ b;                              // XOR
            4'b0101: alu_result = a << b[4:0];                        // SLL
            4'b0110: alu_result = a >> b[4:0];                        // SRL
            4'b0111: alu_result = $signed(a) >>> b[4:0];              // SRA
            4'b1000: alu_result = ($signed(a) < $signed(b)) ? 1 : 0;  // SLT
            4'b1001: alu_result = (a < b) ? 1 : 0;                    // SLTU
            default: alu_result = 32'd0;
        endcase
    end

endmodule
