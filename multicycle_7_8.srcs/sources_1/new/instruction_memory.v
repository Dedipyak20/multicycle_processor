`timescale 1ns / 1ps

module instruction_memory(memread, memwrite, address, write_data, mem_data);

input  memread, memwrite;
input  [31:0] address;
input  [31:0] write_data;
output reg [31:0] mem_data;

reg [7:0] memory [0:255];

always@(*) begin
    if (memread) begin
        mem_data[31:24] = memory[address];
        mem_data[23:16] = memory[address+1];
        mem_data[15:8]  = memory[address+2];
        mem_data[7:0]   = memory[address+3];
    end else if (memwrite) begin
        memory[address]   = write_data[31:24];
        memory[address+1] = write_data[23:16];
        memory[address+2] = write_data[15:8];
        memory[address+3] = write_data[7:0];
    end
end

initial begin
    // Word 0 (addr 0):  ADDI reg2, reg1, 40   → 0x20220028
    memory[0]  = 8'h20; memory[1]  = 8'h22; memory[2]  = 8'h00; memory[3]  = 8'h28;

    // Word 1 (addr 4):  LW reg4, 8(reg3)      → 0x8C640008
    memory[4]  = 8'h8C; memory[5]  = 8'h64; memory[6]  = 8'h00; memory[7]  = 8'h08;

    // Word 2 (addr 8):  NAND reg7, reg5, reg6 → 0x00A63827
    memory[8]  = 8'h00; memory[9]  = 8'hA6; memory[10] = 8'h38; memory[11] = 8'h27;

    // Word 3 (addr 12): BNEQ reg8, reg9, 10   → 0x1509000A
    memory[12] = 8'h15; memory[13] = 8'h09; memory[14] = 8'h00; memory[15] = 8'h0A;
end

endmodule