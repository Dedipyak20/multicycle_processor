`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 04:19:25 PM
// Design Name: 
// Module Name: main
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


module main(
input clk,
input rst,
input [31:0] addr
);



wire [4:0] rs,rt,rd;
wire [5:0] control;
wire [15:0] imm_out;
wire [5:0] alu_control_instr;


wire IorD;
wire memread;
wire memwrite;
wire IRWrite;
wire regdst;
wire regwrite;
wire ALUSrcA;
wire [1:0] ALUSrcB;
wire memtoreg;
wire [1:0] aluop;
wire PCWrite;
wire PCWriteCond;
wire [1:0] PCSource;
control_decoder d1(clk,rst,control,IorD,regdst,ALUSrcA,ALUSrcB,PCWrite,PCWriteCond,PCSource,IRWrite,memread,memtoreg,aluop,memwrite,regwrite);


wire zero;
wire [31:0] next_addr;
program_counter a1(clk,PCWrite,PCWriteCond,zero,addr,next_addr);
//zero

wire [31:0] mem_address;
reg [31:0] aluout;
mux_2_32 aa(addr,aluout,IorD,mem_address);
//aluout

wire [31:0] mem_data;
wire [31:0] alu2;
instruction_memory b2(memread,memwrite,mem_address,alu2,mem_data);
//write_mem_data

wire [31:0] mdr_out;
memory_data_register aa1(mem_data,mdr_out);
//write_reg_data

wire [25:0] jump_address_bits;
instruction_decoder c1(clk,IRWrite,mdr_out,control,rs,rt,rd,imm_out,alu_control_instr,jump_address_bits);

wire [4:0] write_register;
mux c2(rt,rd,regdst,write_register);

wire [31:0] write_reg_data;
mux_2_32 d2(aluout,mdr_out,memtoreg,write_reg_data);

wire [31:0] r1,r2;
registers f1(clk,rs,rt,write_register,write_reg_data,r1,r2,regwrite);

wire [31:0] alu1;
mux_2_32 f2(next_addr,r1,ALUSrcA,alu1);

wire [31:0] sign_extend;
wire [31:0] sign_shift;

mux_4 f3(r2,4,sign_extend,sign_shift,ALUSrcB,alu2);

wire [2:0] alu_sel;
alu_control h1(alu_control_instr,aluop,alu_sel);


wire [31:0] alu_result;
alu h2(alu1,alu2 ,alu_sel,alu_result,zero);

always@(posedge clk) begin
    aluout=alu_result;
end

wire [31:0] jump_address;
shift_left_2 h3(jump_address_bits,next_addr,jump_address);


mux_4 h4(alu_result,aluout,jump_address,1'b0,PCSource,next_addr);

sign_extend h5(imm_out,sign_extend);

shift_left_32 h6(sign_extend,sign_shift);


endmodule
