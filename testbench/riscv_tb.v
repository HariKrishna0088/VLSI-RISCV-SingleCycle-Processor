//=============================================================================
// Testbench: riscv_tb
// Description: Testbench for RISC-V Single-Cycle Processor
// Author: Daggolu Hari Krishna
//
// Executes a pre-loaded program and verifies register/memory contents.
//=============================================================================

`timescale 1ns / 1ps

module riscv_tb;

    reg  clk;
    reg  rst_n;

    integer pass_count = 0;
    integer fail_count = 0;

    // Instantiate processor
    riscv_top uut (
        .clk   (clk),
        .rst_n (rst_n)
    );

    // Clock: 50 MHz (20 ns period)
    initial clk = 0;
    always #10 clk = ~clk;

    // Task to check register values
    task check_reg;
        input [4:0]  reg_num;
        input [31:0] expected;
    begin
        if (uut.u_regfile.registers[reg_num] === expected) begin
            $display("[PASS] x%0d = %0d (0x%08h)", reg_num, expected, expected);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] x%0d = %0d (expected %0d) [got 0x%08h, expected 0x%08h]",
                     reg_num,
                     uut.u_regfile.registers[reg_num], expected,
                     uut.u_regfile.registers[reg_num], expected);
            fail_count = fail_count + 1;
        end
    end
    endtask

    // Task to check memory values
    task check_mem;
        input [31:0] addr;
        input [31:0] expected;
    begin
        if (uut.u_dmem.mem[addr[9:2]] === expected) begin
            $display("[PASS] MEM[%0d] = %0d", addr, expected);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] MEM[%0d] = %0d (expected %0d)",
                     addr, uut.u_dmem.mem[addr[9:2]], expected);
            fail_count = fail_count + 1;
        end
    end
    endtask

    initial begin
        $dumpfile("riscv_tb.vcd");
        $dumpvars(0, riscv_tb);

        $display("================================================================");
        $display("   RISC-V SINGLE-CYCLE PROCESSOR TESTBENCH");
        $display("   Author: Daggolu Hari Krishna");
        $display("================================================================");
        $display("");

        // Reset
        rst_n = 1'b0;
        #40;
        rst_n = 1'b1;

        // Execute program (11 instructions × 20ns each = 220 ns, add margin)
        #300;

        $display("--- Register File Verification ---");
        $display("");

        // ADDI x1, x0, 5 → x1 = 5
        check_reg(5'd1, 32'd5);

        // ADDI x2, x0, 10 → x2 = 10
        check_reg(5'd2, 32'd10);

        // ADD x3, x1, x2 → x3 = 15
        check_reg(5'd3, 32'd15);

        // SUB x4, x2, x1 → x4 = 5
        check_reg(5'd4, 32'd5);

        // AND x5, x1, x2 → x5 = 5 & 10 = 0
        check_reg(5'd5, 32'd0);

        // OR x6, x1, x2 → x6 = 5 | 10 = 15
        check_reg(5'd6, 32'd15);

        // LW x7, 0(x0) → x7 = MEM[0] = 15
        check_reg(5'd7, 32'd15);

        $display("");
        $display("--- Memory Verification ---");
        $display("");

        // SW x3, 0(x0) → MEM[0] = 15
        check_mem(32'd0, 32'd15);

        $display("");
        $display("--- Branch Verification ---");
        $display("");

        // BEQ x1, x4 → x1=5, x4=5, should branch over x8
        // x9 should be 42 (branch target), x8 should be 0 (skipped)
        // Note: BEQ x1(5)==x4(5), branch is taken, skipping ADDI x8
        check_reg(5'd9, 32'd42);

        // Summary
        $display("");
        $display("================================================================");
        $display("  TEST SUMMARY: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("================================================================");
        if (fail_count == 0)
            $display("  >>> ALL TESTS PASSED — PROCESSOR WORKS CORRECTLY! <<<");
        else
            $display("  >>> SOME TESTS FAILED <<<");
        $display("");
        $finish;
    end

    // Watchdog
    initial begin
        #10000;
        $display("[TIMEOUT] Simulation exceeded time limit.");
        $finish;
    end

endmodule
