//=============================================================================
// Module: control_unit
// Description: Main Control Unit for RISC-V Single-Cycle Processor
// Author: Daggolu Hari Krishna
//
// Decodes the opcode field and generates control signals for the datapath.
//=============================================================================

module control_unit (
    input  wire [6:0] opcode,
    output reg        reg_write,    // Write enable for register file
    output reg        mem_read,     // Read enable for data memory
    output reg        mem_write,    // Write enable for data memory
    output reg        mem_to_reg,   // 1: write memory data to reg, 0: write ALU result
    output reg        alu_src,      // 1: ALU source B = immediate, 0: rs2
    output reg        branch,       // Branch instruction flag
    output reg [1:0]  alu_op        // ALU operation type (passed to ALU control)
);

    always @(*) begin
        // Default: all control signals deasserted
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        mem_to_reg = 1'b0;
        alu_src    = 1'b0;
        branch     = 1'b0;
        alu_op     = 2'b00;

        case (opcode)
            // R-type: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
            7'b0110011: begin
                reg_write = 1'b1;
                alu_op    = 2'b10;
            end

            // I-type ALU: ADDI, ANDI, ORI, XORI, SLTI, SLTIU, SLLI, SRLI, SRAI
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b10;
            end

            // Load: LW
            7'b0000011: begin
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                alu_src    = 1'b1;
                mem_to_reg = 1'b1;
                alu_op     = 2'b00;
            end

            // Store: SW
            7'b0100011: begin
                mem_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b00;
            end

            // Branch: BEQ
            7'b1100011: begin
                branch = 1'b1;
                alu_op = 2'b01;
            end

            default: begin
                // NOP — all signals remain at default (0)
            end
        endcase
    end

endmodule
