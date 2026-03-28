`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 04:14:24 PM
// Design Name: 
// Module Name: data_memory
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


module data_memory(addr,write_data_mem,mem_write,mem_read,read_data);

input [31:0] addr,write_data_mem;
output [31:0] read_data;
input mem_write,mem_read;

always@(*) begin
    if(mem_write ==0 && mem_read ==0)
    begin 
    end
end

endmodule
