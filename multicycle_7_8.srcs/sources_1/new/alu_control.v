`timescale 1ns / 1ps

module alu_control(alu_control_instr, aluop, alu_sel);

input  [5:0] alu_control_instr;  // funct field from instruction
input  [1:0] aluop;
output reg [2:0] alu_sel;

always@(*) begin
    alu_sel = 3'b011; // default: ADD
    case(aluop)
        2'b00: alu_sel = 3'b011; // ADD  - used by LW, SW, ADDI
        2'b01: alu_sel = 3'b010; // SUB  - used by BEQ / BNEQ
        2'b10: begin              // R-type: decode funct field
                case(alu_control_instr)
                    6'b100000: alu_sel = 3'b011; // ADD
                    6'b100010: alu_sel = 3'b010; // SUB
                    6'b100100: alu_sel = 3'b000; // AND
                    6'b100101: alu_sel = 3'b001; // OR
                    6'b100111: alu_sel = 3'b100; // NAND  ← new
                    default:   alu_sel = 3'b011;
                endcase
               end
        default: alu_sel = 3'b011;
    endcase
end

endmodule