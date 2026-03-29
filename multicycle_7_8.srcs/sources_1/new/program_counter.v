`timescale 1ns / 1ps

module program_counter(clk, rst, PCWrite, PCWriteCond, PCWriteCondNEQ, zero, next_addr, addr);

input  clk, rst;
input  PCWrite;
input  PCWriteCond;     // branch if equal    (zero == 1)
input  PCWriteCondNEQ;  // branch if not equal (zero == 0)
input  zero;
input  [31:0] next_addr;
output reg [31:0] addr;

wire pc_enable;
assign pc_enable = PCWrite
                 | (PCWriteCond    &  zero)
                 | (PCWriteCondNEQ & ~zero);

always @(posedge clk or posedge rst) begin
    if (rst)          addr <= 32'h00000000;
    else if (pc_enable) addr <= next_addr;
end

endmodule