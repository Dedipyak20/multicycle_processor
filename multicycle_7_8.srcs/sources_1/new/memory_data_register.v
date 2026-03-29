`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2026 04:15:55 PM
// Design Name: 
// Module Name: memory_data_register
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


module memory_data_register(
    input clk,
    input rst,
    input [31:0] mem_data,
    output reg [31:0] write_reg_data
    );
    
    always@(posedge clk or posedge rst) begin
        if (rst) write_reg_data <= 32'b0;
        else     write_reg_data <= mem_data;
    end
    
endmodule