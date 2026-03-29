`timescale 1ns / 1ps
module tb_multicycle();

reg clk;
reg rst;

main u1(.clk(clk), .rst(rst));

wire [31:0] reg2  = u1.f1.memory_regfile[2];
wire [31:0] reg4  = u1.f1.memory_regfile[4];
wire [31:0] reg7  = u1.f1.memory_regfile[7];
wire [31:0] reg8  = u1.f1.memory_regfile[8];
wire [31:0] reg9  = u1.f1.memory_regfile[9];

wire [31:0] pc    = u1.addr;
wire [31:0] alu_r = u1.alu_result;
wire        zflag = u1.zero;
wire [3:0]  state = u1.d1.state;

initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    rst = 1;
    #25;
    rst = 0;
    #500;
    $finish;
end

initial begin
    $monitor("Time=%0t | PC=%0h | state=%0d | reg2=%0h | reg4=%0h | reg7=%0h | zero=%b",
             $time, pc, state, reg2, reg4, reg7, zflag);
end

endmodule