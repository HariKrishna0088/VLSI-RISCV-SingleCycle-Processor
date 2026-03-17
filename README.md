<p align="center">
  <img src="https://img.shields.io/badge/Architecture-RISC--V-darkgreen?style=for-the-badge&logo=riscv&logoColor=white" alt="RISC-V"/>
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" alt="Verilog"/>
  <img src="https://img.shields.io/badge/Type-Single%20Cycle-orange?style=for-the-badge" alt="Single Cycle"/>
  <img src="https://img.shields.io/badge/ISA-RV32I-red?style=for-the-badge" alt="RV32I"/>
</p>

# ðŸ–¥ï¸ RISC-V Single-Cycle Processor â€” Verilog HDL

> A complete 32-bit RISC-V single-cycle processor implementing the RV32I base integer instruction set, designed from scratch in Verilog HDL with modular architecture and comprehensive testbench.

---

## ðŸ“‹ Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Supported Instructions](#-supported-instructions)
- [Module Hierarchy](#-module-hierarchy)
- [Datapath Diagram](#-datapath-diagram)
- [File Structure](#-file-structure)
- [Simulation Guide](#-simulation-guide)
- [Test Program](#-test-program)
- [Applications](#-applications)
- [Author](#-author)

---

## ðŸ” Overview

This project implements a **32-bit RISC-V single-cycle processor** based on the **RV32I** base integer instruction set architecture. Every instruction executes in a single clock cycle, making this design ideal for understanding processor fundamentals.

### Key Highlights
- ðŸ—ï¸ **9 Modular Components** â€” Clean separation of concerns
- ðŸ“ **15+ Instructions** â€” R-type, I-type, S-type, B-type
- ðŸ”„ **Complete Datapath** â€” PC â†’ IMEM â†’ RegFile â†’ ALU â†’ DMEM â†’ WriteBack
- âœ… **Verified** â€” Self-checking testbench with automated PASS/FAIL
- ðŸ“Š **VCD Waveform** â€” Full pipeline visibility for debugging
- ðŸŽ¯ **Pre-loaded Test Program** â€” Arithmetic, load/store, and branch testing

---

## ðŸ—ï¸ Architecture

```
                              RISC-V SINGLE-CYCLE PROCESSOR
    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
    â”‚                                                                     â”‚
    â”‚   â”Œâ”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”          â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”          â”‚
    â”‚   â”‚ PC â”‚â”€â”€â”€â–ºâ”‚ IMEM â”‚â”€â”€â”€â–ºâ”‚ CONTROL  â”‚          â”‚ ALU CTRL â”‚          â”‚
    â”‚   â””â”€â”€â”¬â”€â”˜    â””â”€â”€â”¬â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜          â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜          â”‚
    â”‚      â”‚         â”‚             â”‚                     â”‚                 â”‚
    â”‚   â”Œâ”€â”€â–¼â”€â”€â”      â”‚        â”Œâ”€â”€â”€â”€â–¼â”€â”€â”€â”€â”€â”          â”Œâ”€â”€â”€â–¼â”€â”€â”€â”€â”           â”‚
    â”‚   â”‚ +4  â”‚      â”‚        â”‚ RegFile  â”‚          â”‚  ALU   â”‚           â”‚
    â”‚   â””â”€â”€â”¬â”€â”€â”˜      â”‚        â”‚ 32x32bit â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â–ºâ”‚ 32-bit â”œâ”€â”€â”       â”‚
    â”‚      â”‚         â”‚        â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜          â””â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â”‚       â”‚
    â”‚   â”Œâ”€â”€â–¼â”€â”€â”€â”€â”€â”€â”  â”‚             â”‚                     â”‚       â”‚       â”‚
    â”‚   â”‚  MUX    â”‚â—„â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€ Branch â”€â”€â”€â”€â”€â”€â”€â”€â”˜       â”‚       â”‚
    â”‚   â”‚ PC_NEXT â”‚  â”‚         â”Œâ”€â”€â”€â–¼â”€â”€â”€â”                    â”Œâ”€â”€â”€â–¼â”€â”€â”€â”  â”‚
    â”‚   â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â”‚         â”‚IMM GENâ”‚                    â”‚ DMEM  â”‚  â”‚
    â”‚                â”‚         â””â”€â”€â”€â”€â”€â”€â”€â”˜                    â””â”€â”€â”€â”¬â”€â”€â”€â”˜  â”‚
    â”‚                â”‚                                         â”‚       â”‚
    â”‚                â”‚              â”Œâ”€â”€â”€â”€â”€ WriteBack MUX â—„â”€â”€â”€â”€â”€â”˜       â”‚
    â”‚                â”‚              â”‚   (ALU Result / Mem Data)        â”‚
    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                     â”‚              â”‚
                Instruction     Write Data
                  [31:0]        to RegFile
```

---

## ðŸ“ Supported Instructions

### R-Type (Register-Register)
| Instruction | Operation | Description |
|:-----------:|:---------:|:------------|
| `ADD` | `rd = rs1 + rs2` | Addition |
| `SUB` | `rd = rs1 - rs2` | Subtraction |
| `AND` | `rd = rs1 & rs2` | Bitwise AND |
| `OR` | `rd = rs1 \| rs2` | Bitwise OR |
| `XOR` | `rd = rs1 ^ rs2` | Bitwise XOR |
| `SLL` | `rd = rs1 << rs2` | Shift Left Logical |
| `SRL` | `rd = rs1 >> rs2` | Shift Right Logical |
| `SRA` | `rd = rs1 >>> rs2` | Shift Right Arithmetic |
| `SLT` | `rd = (rs1 < rs2)` | Set Less Than (signed) |
| `SLTU` | `rd = (rs1 < rs2)` | Set Less Than (unsigned) |

### I-Type (Immediate)
| Instruction | Operation |
|:-----------:|:---------:|
| `ADDI` | `rd = rs1 + imm` |
| `LW` | `rd = MEM[rs1 + imm]` |

### S-Type (Store)
| Instruction | Operation |
|:-----------:|:---------:|
| `SW` | `MEM[rs1 + imm] = rs2` |

### B-Type (Branch)
| Instruction | Operation |
|:-----------:|:---------:|
| `BEQ` | `if (rs1 == rs2) PC += imm` |

---

## ðŸ§© Module Hierarchy

```
riscv_top
â”œâ”€â”€ program_counter      # 32-bit PC with synchronous reset
â”œâ”€â”€ instruction_memory   # 256x32-bit ROM with test program
â”œâ”€â”€ control_unit         # Main decoder (opcode â†’ control signals)
â”œâ”€â”€ register_file        # 32x32-bit dual-port register file (x0=0)
â”œâ”€â”€ imm_gen              # Immediate generator (I/S/B/U/J types)
â”œâ”€â”€ alu_control          # ALU operation decoder (funct3/funct7)
â”œâ”€â”€ alu_32bit            # 32-bit ALU (10 operations)
â””â”€â”€ data_memory          # 256x32-bit RAM for load/store
```

---

## ðŸ“ File Structure

```
VLSI-RISCV-SingleCycle-Processor/
â”œâ”€â”€ src/
â”‚   â”œâ”€â”€ program_counter.v      # Program Counter
â”‚   â”œâ”€â”€ instruction_memory.v   # Instruction ROM
â”‚   â”œâ”€â”€ register_file.v        # 32x32 Register File
â”‚   â”œâ”€â”€ alu_32bit.v            # 32-bit ALU
â”‚   â”œâ”€â”€ alu_control.v          # ALU Control Decoder
â”‚   â”œâ”€â”€ control_unit.v         # Main Control Unit
â”‚   â”œâ”€â”€ imm_gen.v              # Immediate Generator
â”‚   â”œâ”€â”€ data_memory.v          # Data RAM
â”‚   â””â”€â”€ riscv_top.v            # Top-Level Integration
â”œâ”€â”€ testbench/
â”‚   â””â”€â”€ riscv_tb.v             # Self-Checking Testbench
â”œâ”€â”€ docs/
â”œâ”€â”€ .gitignore
â”œâ”€â”€ LICENSE
â””â”€â”€ README.md
```

---

## ðŸš€ Simulation Guide

### Using Icarus Verilog

```bash
# Compile all modules + testbench
iverilog -o riscv_sim \
    src/program_counter.v \
    src/instruction_memory.v \
    src/register_file.v \
    src/alu_32bit.v \
    src/alu_control.v \
    src/control_unit.v \
    src/imm_gen.v \
    src/data_memory.v \
    src/riscv_top.v \
    testbench/riscv_tb.v

# Run simulation
vvp riscv_sim

# View waveforms
gtkwave riscv_tb.vcd
```

### Expected Output

```
================================================================
   RISC-V SINGLE-CYCLE PROCESSOR TESTBENCH
   Author: Daggolu Hari Krishna
================================================================

--- Register File Verification ---

[PASS] x1 = 5  (0x00000005)
[PASS] x2 = 10 (0x0000000a)
[PASS] x3 = 15 (0x0000000f)
[PASS] x4 = 5  (0x00000005)
[PASS] x5 = 0  (0x00000000)
[PASS] x6 = 15 (0x0000000f)
[PASS] x7 = 15 (0x0000000f)

--- Memory Verification ---

[PASS] MEM[0] = 15

--- Branch Verification ---

[PASS] x9 = 42 (0x0000002a)

================================================================
  TEST SUMMARY: 9 PASSED, 0 FAILED
================================================================
  >>> ALL TESTS PASSED â€” PROCESSOR WORKS CORRECTLY! <<<
```

---

## ðŸ§ª Test Program

The instruction memory is pre-loaded with an assembly test program:

```asm
# RISC-V Test Program (RV32I)
# Tests: Arithmetic, Logic, Load/Store, Branch

ADDI x1, x0, 5       # x1 = 5
ADDI x2, x0, 10      # x2 = 10
ADD  x3, x1, x2      # x3 = 15 (5 + 10)
SUB  x4, x2, x1      # x4 = 5  (10 - 5)
AND  x5, x1, x2      # x5 = 0  (0101 & 1010 = 0000)
OR   x6, x1, x2      # x6 = 15 (0101 | 1010 = 1111)
SW   x3, 0(x0)        # MEM[0] = 15
LW   x7, 0(x0)        # x7 = MEM[0] = 15
BEQ  x1, x4, +8       # Branch to ADDI x9 (x1==x4==5)
ADDI x8, x0, 99       # SKIPPED by branch
ADDI x9, x0, 42       # x9 = 42 (branch target)
```

---

## ðŸ’¡ Applications

- ðŸŽ“ **Computer Architecture** â€” Learn processor design hands-on
- ðŸ”¬ **FPGA Prototyping** â€” Deploy on Xilinx/Intel FPGAs
- ðŸ­ **SoC Design** â€” Foundation for multi-core processor design
- ðŸ“š **Academic Research** â€” Extend with pipeline, cache, or peripherals

---

## ðŸ”® Future Enhancements

- [ ] 5-stage pipeline (IF â†’ ID â†’ EX â†’ MEM â†’ WB)
- [ ] Hazard detection and forwarding unit
- [ ] Branch prediction unit
- [ ] Cache memory (L1 I-Cache, D-Cache)
- [ ] CSR (Control and Status Registers) support
- [ ] Interrupt controller

---

## ðŸ‘¨â€ðŸ’» Author

**Daggolu Hari Krishna**
B.Tech ECE | JNTUA College of Engineering, Kalikiri

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/contacthari88/)
[![Email](https://img.shields.io/badge/Email-Contact-red?style=flat-square&logo=gmail)](mailto:haridaggolu@gmail.com)
[![GitHub](https://img.shields.io/badge/GitHub-Profile-black?style=flat-square&logo=github)](https://github.com/HariKrishna0088)
[![GitHub](https://img.shields.io/badge/GitHub-Harikrishna__08-black?style=flat-square&logo=github)](https://github.com/Harikrishna_08)

---

<p align="center">
  â­ If you found this project helpful, please give it a star! â­
</p>
