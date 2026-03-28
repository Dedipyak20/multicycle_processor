`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2026 03:08:16 PM
// Design Name: 
// Module Name: tb_multicycle
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


module tb_multicycle();

reg clk;
reg rst;
reg [31:0] addr;
main u1(clk,rst,addr);

initial begin
    clk=0;
    forever #10 clk=~clk;
end

initial begin 
    rst=0;
    #5
    rst=1;
    addr = 32'b0;
end

endmodule
