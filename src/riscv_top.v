//=============================================================================
// Module: riscv_top
// Description: RISC-V Single-Cycle Processor Top Module
// Author: Daggolu Hari Krishna
//
// Integrates all datapath components:
//   PC → Instruction Memory → Register File → ALU → Data Memory
//   Control Unit → ALU Control → Immediate Generator
//
// Supported Instructions (RV32I subset):
//   R-type: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
//   I-type: ADDI, ANDI, ORI, XORI, SLTI, SLTIU, SLLI, SRLI, SRAI, LW
//   S-type: SW
//   B-type: BEQ
//=============================================================================

module riscv_top (
    input  wire        clk,
    input  wire        rst_n
);

    // ==================== Internal Wires ====================

    // Program Counter
    wire [31:0] pc_current;
    wire [31:0] pc_plus4;
    wire [31:0] pc_branch;
    wire [31:0] pc_next;

    // Instruction
    wire [31:0] instruction;
    wire [6:0]  opcode;
    wire [4:0]  rd, rs1, rs2;
    wire [2:0]  funct3;
    wire [6:0]  funct7;

    // Control signals
    wire        reg_write;
    wire        mem_read;
    wire        mem_write;
    wire        mem_to_reg;
    wire        alu_src;
    wire        branch;
    wire [1:0]  alu_op;

    // ALU
    wire [3:0]  alu_ctrl;
    wire [31:0] alu_input_b;
    wire [31:0] alu_result;
    wire        zero_flag;

    // Register File
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] write_back_data;

    // Data Memory
    wire [31:0] mem_read_data;

    // Immediate
    wire [31:0] imm_value;

    // Branch decision
    wire        branch_taken;

    // ==================== Instruction Decode ====================
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    // ==================== PC Logic ====================
    assign pc_plus4   = pc_current + 32'd4;
    assign pc_branch  = pc_current + imm_value;
    assign branch_taken = branch & zero_flag;
    assign pc_next    = branch_taken ? pc_branch : pc_plus4;

    // ==================== ALU Input MUX ====================
    assign alu_input_b = alu_src ? imm_value : rs2_data;

    // ==================== Write-Back MUX ====================
    assign write_back_data = mem_to_reg ? mem_read_data : alu_result;

    // ==================== Module Instantiations ====================

    // Program Counter
    program_counter u_pc (
        .clk    (clk),
        .rst_n  (rst_n),
        .pc_next(pc_next),
        .pc     (pc_current)
    );

    // Instruction Memory
    instruction_memory u_imem (
        .addr       (pc_current),
        .instruction(instruction)
    );

    // Control Unit
    control_unit u_ctrl (
        .opcode    (opcode),
        .reg_write (reg_write),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src   (alu_src),
        .branch    (branch),
        .alu_op    (alu_op)
    );

    // Register File
    register_file u_regfile (
        .clk       (clk),
        .rst_n     (rst_n),
        .reg_write (reg_write),
        .rs1_addr  (rs1),
        .rs2_addr  (rs2),
        .rd_addr   (rd),
        .write_data(write_back_data),
        .rs1_data  (rs1_data),
        .rs2_data  (rs2_data)
    );

    // Immediate Generator
    imm_gen u_immgen (
        .instruction(instruction),
        .imm_out    (imm_value)
    );

    // ALU Control
    alu_control u_aluctrl (
        .alu_op  (alu_op),
        .funct3  (funct3),
        .funct7  (funct7),
        .alu_ctrl(alu_ctrl)
    );

    // ALU
    alu_32bit u_alu (
        .a          (rs1_data),
        .b          (alu_input_b),
        .alu_control(alu_ctrl),
        .alu_result (alu_result),
        .zero_flag  (zero_flag)
    );

    // Data Memory
    data_memory u_dmem (
        .clk       (clk),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .addr      (alu_result),
        .write_data(rs2_data),
        .read_data (mem_read_data)
    );

endmodule
