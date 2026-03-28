`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 03:49:31 PM
// Design Name: 
// Module Name: registers
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


module registers(clk,rs,rt,write_register,write_reg_data,r1,r2,regwrite);

input clk;
input [31:0] write_reg_data;
input [4:0] rs,rt,write_register;
input regwrite;
output [31:0] r1,r2;
reg [31:0] memory_regfile [0:31];



    assign r1 = memory_regfile[rs];
    assign r2 = memory_regfile[rt];
    
    always@(clk) begin
    if(regwrite==1) begin
            memory_regfile[write_register]<=write_reg_data;
        end 
    
end

endmodule
