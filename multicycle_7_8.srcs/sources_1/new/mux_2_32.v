`timescale 1ns / 1ps


module mux_2_32(i0,i1,s,out);

input [31:0] i0,i1;
input s;
output reg [31:0] out;

always@(*) begin
if(s==0)
    out=i0;
else
    out=i1;
end

endmodule