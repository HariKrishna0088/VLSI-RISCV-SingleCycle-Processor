//=============================================================================
// Module: register_file
// Description: 32 x 32-bit Register File for RISC-V
// Author: Daggolu Hari Krishna
//
// Features:
//   - 32 general-purpose registers (x0-x31)
//   - x0 is hardwired to zero
//   - Dual read ports, single write port
//   - Write on positive clock edge
//=============================================================================

module register_file (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        reg_write,   // Write enable
    input  wire [4:0]  rs1_addr,    // Read address 1
    input  wire [4:0]  rs2_addr,    // Read address 2
    input  wire [4:0]  rd_addr,     // Write address
    input  wire [31:0] write_data,  // Data to write
    output wire [31:0] rs1_data,    // Read data 1
    output wire [31:0] rs2_data     // Read data 2
);

    reg [31:0] registers [0:31];
    integer i;

    // Read ports (combinational) — x0 always returns 0
    assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : registers[rs2_addr];

    // Write port (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end else begin
            if (reg_write && rd_addr != 5'd0) begin
                registers[rd_addr] <= write_data;
            end
        end
    end

endmodule
