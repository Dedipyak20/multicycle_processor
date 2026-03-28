`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2026 04:22:32 PM
// Design Name: 
// Module Name: mux
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


module mux(i0,i1,s,out);

input [4:0] i0,i1;
input s;
output reg[4:0] out;

always@(*) begin
 if(s==0) assign out = i0;
 else if(s==1) assign out = i1;
end

endmodule