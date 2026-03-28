`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2026 04:38:15 PM
// Design Name: 
// Module Name: mux_2_32
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


module mux_2_32(i0,i1,s,out);

input [31:0] i0,i1;
input s;
output reg [31:0] out;

always@(*) begin
if(s==0) begin 
    assign out=i0;
end
else if (s==1) begin
    assign out=i1;
end
end

endmodule