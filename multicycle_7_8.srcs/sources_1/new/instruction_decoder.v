`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 04:15:41 PM
// Design Name: 
// Module Name: instruction_decoder
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


module instruction_decoder(clk,IRWrite,instr,control,rs,rt,rd,imm,alu_control_instr,jump_address_bits);

input clk;
input IRWrite;
input [31:0] instr;
output [4:0] rs,rt,rd;
output [5:0] control;
output [15:0] imm;
output [5:0] alu_control_instr;
output [25:0]jump_address_bits;

reg [31:0] IR;

always@(posedge clk) begin 
    if (IRWrite) IR<=instr;
end

    assign  rs = IR[25:21];
    assign  rt = IR[20:16];
    assign  rd = IR[15:11];
    assign  control = IR[31:26];
    assign  imm = IR[15:0];
    assign alu_control_instr = IR[5:0];
    assign jump_address_bits = IR[25:0];

endmodule
