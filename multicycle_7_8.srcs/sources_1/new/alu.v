`timescale 1ns / 1ps

module alu(a, b, alu_control_instr, res, zero);
input  [31:0] a, b;
input  [2:0]  alu_control_instr;
output reg [31:0] res;
output zero;

always@(*) begin
    case(alu_control_instr)
        3'b000: res = a & b;        // AND
        3'b001: res = a | b;        // OR
        3'b010: res = a - b;        // SUB (used by BEQ/BNEQ)
        3'b011: res = a + b;        // ADD (used by ADDI, LW, SW)
        3'b100: res = ~(a & b);     // NAND
        default: res = 32'b0;
    endcase
end

assign zero = (res == 32'b0);

endmodule