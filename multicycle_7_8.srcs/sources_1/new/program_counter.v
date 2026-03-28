`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 04:18:42 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(clk,PCWrite,PCWriteCond,zero, addr,next_addr);

input PCWrite;
input PCWriteCond;
input zero;
input clk;
input  [31:0] next_addr;
output reg [31:0] addr;

wire control;
assign control = (zero & PCWriteCond) | PCWrite;

always@(control) begin 
    addr = next_addr;
end

endmodule
