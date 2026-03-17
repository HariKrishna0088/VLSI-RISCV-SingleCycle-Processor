//=============================================================================
// Module: program_counter
// Description: 32-bit Program Counter for RISC-V Processor
// Author: Daggolu Hari Krishna
//=============================================================================

module program_counter (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] pc_next,
    output reg  [31:0] pc
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc <= 32'h0000_0000;
        else
            pc <= pc_next;
    end

endmodule
