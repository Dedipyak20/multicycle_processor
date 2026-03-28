`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 03:58:06 PM
// Design Name: 
// Module Name: alu_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_control(alu_control_instr,aluop,alu_sel);

input [5:0] alu_control_instr;
input [1:0] aluop;
output reg [2:0] alu_sel;

always@(*) begin 
    case(aluop)
        2'b00: alu_sel=3'b010; //add_lw
        2'b10: begin 
                case(alu_control_instr)
                    6'b100000: alu_sel = 3'b010; //and
                    6'b100101: alu_sel = 3'b001; //or
                endcase
        end
    endcase
    
end



endmodule
