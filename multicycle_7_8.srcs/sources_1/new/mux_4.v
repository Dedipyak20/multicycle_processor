`timescale 1ns / 1ps


module mux_4(i0,i1,i2,i3,s,out);

input [31:0] i0,i1,i2,i3;
input [1:0] s;
output reg [31:0] out;

always@(*) begin
    case(s)
        2'b00: out = i0;
        2'b01: out = i1;
        2'b10: out = i2;
        2'b11: out = i3;
    endcase
end

endmodule