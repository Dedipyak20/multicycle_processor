`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 04:07:56 PM
// Design Name: 
// Module Name: tb_single_cycle
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


module tb_single_cycle();

reg[31:0] address;

main u(address);

initial begin 
    address=0;
    #10
    address=4;
    $finish;
end

endmodule
