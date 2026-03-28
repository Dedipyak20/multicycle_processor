`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 04:43:16 PM
// Design Name: 
// Module Name: alu
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


module alu(a,b ,alu_control_instr,res,zero);
input [31:0]a,b;
input [2:0]alu_control_instr;
output reg [31:0]res;
output reg zero;


always@(*) begin
    case(alu_control_instr)
        3'b000:res=a&b;
        3'b001:res=a|b;
        3'b010:res=a-b;
        3'b011:res=a+b;
    endcase
    
    assign zero = (res==0);
    
end



endmodule
