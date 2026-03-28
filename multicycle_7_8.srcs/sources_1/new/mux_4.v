`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2026 04:35:42 PM
// Design Name: 
// Module Name: mux_4
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


module mux_4(i0,i1,i2,i3,s,out);

input [31:0] i0,i1,i2,i3;
input [1:0] s;
output reg [31:0] out;

always@(*) begin
    if(s==2'b00) assign out = i0;
    else if(s==2'b01) assign out = i1;
    else if(s==2'b10) assign out = i2;
    else if(s==2'b11) assign out = i3;
    
end

endmodule