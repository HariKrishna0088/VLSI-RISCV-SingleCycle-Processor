<p align="center">
  <img src="https://img.shields.io/badge/Architecture-RISC--V-darkgreen?style=for-the-badge&logo=riscv&logoColor=white" alt="RISC-V"/>
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" alt="Verilog"/>
  <img src="https://img.shields.io/badge/Type-Single%20Cycle-orange?style=for-the-badge" alt="Single Cycle"/>
  <img src="https://img.shields.io/badge/ISA-RV32I-red?style=for-the-badge" alt="RV32I"/>
</p>

# 🖥️ RISC-V Single-Cycle Processor — Verilog HDL

> A complete 32-bit RISC-V single-cycle processor implementing the RV32I base integer instruction set, designed from scratch in Verilog HDL with modular architecture and comprehensive testbench.

---

## 📋 Table of Contents

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

## 🔍 Overview

This project implements a **32-bit RISC-V single-cycle processor** based on the **RV32I** base integer instruction set architecture. Every instruction executes in a single clock cycle, making this design ideal for understanding processor fundamentals.

### Key Highlights
- 🏗️ **9 Modular Components** — Clean separation of concerns
- 📝 **15+ Instructions** — R-type, I-type, S-type, B-type
- 🔄 **Complete Datapath** — PC → IMEM → RegFile → ALU → DMEM → WriteBack
- ✅ **Verified** — Self-checking testbench with automated PASS/FAIL
- 📊 **VCD Waveform** — Full pipeline visibility for debugging
- 🎯 **Pre-loaded Test Program** — Arithmetic, load/store, and branch testing

---

## 🏗️ Architecture

```
                              RISC-V SINGLE-CYCLE PROCESSOR
    ┌─────────────────────────────────────────────────────────────────────┐
    │                                                                     │
    │   ┌────┐    ┌──────┐    ┌──────────┐          ┌──────────┐          │
    │   │ PC │───►│ IMEM │───►│ CONTROL  │          │ ALU CTRL │          │
    │   └──┬─┘    └──┬───┘    └────┬─────┘          └────┬─────┘          │
    │      │         │             │                     │                 │
    │   ┌──▼──┐      │        ┌────▼─────┐          ┌───▼────┐           │
    │   │ +4  │      │        │ RegFile  │          │  ALU   │           │
    │   └──┬──┘      │        │ 32x32bit ├─────────►│ 32-bit ├──┐       │
    │      │         │        └────┬─────┘          └────────┘  │       │
    │   ┌──▼──────┐  │             │                     │       │       │
    │   │  MUX    │◄─┼─────────────┼───── Branch ────────┘       │       │
    │   │ PC_NEXT │  │         ┌───▼───┐                    ┌───▼───┐  │
    │   └─────────┘  │         │IMM GEN│                    │ DMEM  │  │
    │                │         └───────┘                    └───┬───┘  │
    │                │                                         │       │
    │                │              ┌───── WriteBack MUX ◄─────┘       │
    │                │              │   (ALU Result / Mem Data)        │
    └────────────────┼──────────────┼──────────────────────────────────┘
                     │              │
                Instruction     Write Data
                  [31:0]        to RegFile
```

---

## 📝 Supported Instructions

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

## 🧩 Module Hierarchy

```
riscv_top
├── program_counter      # 32-bit PC with synchronous reset
├── instruction_memory   # 256x32-bit ROM with test program
├── control_unit         # Main decoder (opcode → control signals)
├── register_file        # 32x32-bit dual-port register file (x0=0)
├── imm_gen              # Immediate generator (I/S/B/U/J types)
├── alu_control          # ALU operation decoder (funct3/funct7)
├── alu_32bit            # 32-bit ALU (10 operations)
└── data_memory          # 256x32-bit RAM for load/store
```

---

## 📁 File Structure

```
VLSI-RISCV-SingleCycle-Processor/
├── src/
│   ├── program_counter.v      # Program Counter
│   ├── instruction_memory.v   # Instruction ROM
│   ├── register_file.v        # 32x32 Register File
│   ├── alu_32bit.v            # 32-bit ALU
│   ├── alu_control.v          # ALU Control Decoder
│   ├── control_unit.v         # Main Control Unit
│   ├── imm_gen.v              # Immediate Generator
│   ├── data_memory.v          # Data RAM
│   └── riscv_top.v            # Top-Level Integration
├── testbench/
│   └── riscv_tb.v             # Self-Checking Testbench
├── docs/
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🚀 Simulation Guide

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
  >>> ALL TESTS PASSED — PROCESSOR WORKS CORRECTLY! <<<
```

---

## 🧪 Test Program

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

## 💡 Applications

- 🎓 **Computer Architecture** — Learn processor design hands-on
- 🔬 **FPGA Prototyping** — Deploy on Xilinx/Intel FPGAs
- 🏭 **SoC Design** — Foundation for multi-core processor design
- 📚 **Academic Research** — Extend with pipeline, cache, or peripherals

---

## 🔮 Future Enhancements

- [ ] 5-stage pipeline (IF → ID → EX → MEM → WB)
- [ ] Hazard detection and forwarding unit
- [ ] Branch prediction unit
- [ ] Cache memory (L1 I-Cache, D-Cache)
- [ ] CSR (Control and Status Registers) support
- [ ] Interrupt controller

---

## 👨‍💻 Author

**Daggolu Hari Krishna**
B.Tech ECE | JNTUA College of Engineering, Kalikiri

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/harikrishnadaggolu)
[![Email](https://img.shields.io/badge/Email-Contact-red?style=flat-square&logo=gmail)](mailto:haridaggolu@gmail.com)
[![GitHub](https://img.shields.io/badge/GitHub-Harikrishna__08-black?style=flat-square&logo=github)](https://github.com/Harikrishna_08)

---

<p align="center">
  ⭐ If you found this project helpful, please give it a star! ⭐
</p>
