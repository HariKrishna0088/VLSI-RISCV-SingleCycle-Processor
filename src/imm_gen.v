//=============================================================================
// Module: imm_gen
// Description: Immediate Value Generator for RISC-V
// Author: Daggolu Hari Krishna
//
// Generates sign-extended 32-bit immediate values from instruction encoding.
// Supports I-type, S-type, B-type, U-type, and J-type formats.
//=============================================================================

module imm_gen (
    input  wire [31:0] instruction,
    output reg  [31:0] imm_out
);

    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            // I-type: ADDI, LW, JALR
            7'b0010011, 7'b0000011, 7'b1100111:
                imm_out = {{20{instruction[31]}}, instruction[31:20]};

            // S-type: SW
            7'b0100011:
                imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // B-type: BEQ, BNE, BLT, BGE, BLTU, BGEU
            7'b1100011:
                imm_out = {{19{instruction[31]}}, instruction[31], instruction[7],
                           instruction[30:25], instruction[11:8], 1'b0};

            // U-type: LUI, AUIPC
            7'b0110111, 7'b0010111:
                imm_out = {instruction[31:12], 12'b0};

            // J-type: JAL
            7'b1101111:
                imm_out = {{11{instruction[31]}}, instruction[31], instruction[19:12],
                           instruction[20], instruction[30:21], 1'b0};

            default:
                imm_out = 32'd0;
        endcase
    end

endmodule
