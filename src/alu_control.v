//=============================================================================
// Module: alu_control
// Description: ALU Control Unit for RISC-V Processor
// Author: Daggolu Hari Krishna
//
// Generates the 4-bit ALU control signal based on:
//   - alu_op from the main control unit
//   - funct3 and funct7 fields from the instruction
//=============================================================================

module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] alu_ctrl
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0000; // LW/SW: ADD for address calc
            2'b01: alu_ctrl = 4'b0001; // Branch: SUB for comparison
            2'b10: begin               // R-type / I-type
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_ctrl = 4'b0001; // SUB
                        else
                            alu_ctrl = 4'b0000; // ADD / ADDI
                    end
                    3'b001: alu_ctrl = 4'b0101; // SLL / SLLI
                    3'b010: alu_ctrl = 4'b1000; // SLT / SLTI
                    3'b011: alu_ctrl = 4'b1001; // SLTU / SLTIU
                    3'b100: alu_ctrl = 4'b0100; // XOR / XORI
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_ctrl = 4'b0111; // SRA / SRAI
                        else
                            alu_ctrl = 4'b0110; // SRL / SRLI
                    end
                    3'b110: alu_ctrl = 4'b0011; // OR / ORI
                    3'b111: alu_ctrl = 4'b0010; // AND / ANDI
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            default: alu_ctrl = 4'b0000;
        endcase
    end

endmodule
