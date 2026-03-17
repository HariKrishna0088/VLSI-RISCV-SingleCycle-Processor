//=============================================================================
// Module: data_memory
// Description: Read/Write Data Memory for RISC-V Processor
// Author: Daggolu Hari Krishna
//
// 256 x 32-bit data memory (1KB)
// Supports LW (Load Word) and SW (Store Word)
//=============================================================================

module data_memory (
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

    reg [31:0] mem [0:255];
    integer i;

    // Word-aligned access
    wire [7:0] word_addr = addr[9:2];

    // Synchronous write
    always @(posedge clk) begin
        if (mem_write)
            mem[word_addr] <= write_data;
    end

    // Asynchronous read
    assign read_data = mem_read ? mem[word_addr] : 32'd0;

    // Initialize memory to zero
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'd0;
    end

endmodule
