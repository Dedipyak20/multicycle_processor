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
    input [31:0] mem_data,
    output [31:0] write_reg_data
    );
    
    assign write_reg_data = mem_data;
    
endmodule
