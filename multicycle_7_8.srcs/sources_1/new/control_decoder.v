`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 03:32:38 PM
// Design Name: 
// Module Name: control_decoder
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


module control_decoder(clk,rst,control,IorD,regdst,ALUSrcA,ALUSrcB,PCWrite,PCWriteCond,PCSource,IRWrite,memread,memtoreg,aluop,memwrite,regwrite);

input clk;
input rst;
input [5:0] control; //opcode
output reg IorD;
output reg memread;
output reg memwrite;
output reg IRWrite;
output reg regdst;
output reg regwrite;
output reg ALUSrcA;
output reg [1:0] ALUSrcB;
output reg memtoreg;
output reg [1:0] aluop;
output reg PCWrite;
output reg PCWriteCond;
output reg [1:0] PCSource;

reg [3:0] state,next_state;

parameter IF = 4'b0000;
parameter ID = 4'b0001;
parameter EX_LS = 4'b0010;
parameter MEM_LW = 4'b0011;
parameter WB = 4'b0100;
parameter MEM_SW = 4'b0101;
parameter EX_R = 4'b0110;
parameter WB_R = 4'b0111;
parameter EX_BRANCH = 4'b1000;
parameter EX_JMP = 4'b1001;

parameter LW = 6'B100011;
parameter SW = 6'B101011;
parameter R = 6'B000000;
parameter BEQ = 6'B000100;
parameter JMP = 6'b000001; //check


always@(posedge clk or posedge rst) begin 
    //fetch
    if(rst) state= IF;
    else state = next_state;
    
end

always@(*) begin
    case(state)
    IF: next_state=ID;
    ID: case(control)
        LW: next_state = EX_LS;
        SW: next_state = EX_LS;
        R: next_state = EX_R;
        BEQ: next_state = EX_BRANCH;
        JMP: next_state = EX_JMP;
        default: next_state= IF;
        endcase
    EX_LS: case(control)
            LW: next_state = MEM_LW;
            SW: next_state = MEM_SW;
            default: next_state= IF;
            endcase
    MEM_LW: next_state = WB;
    MEM_SW: next_state = IF;
    EX_R: next_state= WB_R;
    WB_R: next_state= IF;
    EX_BRANCH: next_state = IF;
    EX_JMP:next_state = IF;
          
    endcase    
end

always@(*) begin
    IorD=0;memread=0;memwrite=0;IRWrite=0;regdst=0;regwrite=0;ALUSrcA=0;ALUSrcB=2'b00;
    memtoreg=0;aluop=2'b00;PCWrite=0;PCSource=2'b00;
    
    case(state)
    IF: 
        begin
        memread=1;
        IRWrite=1;
        ALUSrcA=0;
        ALUSrcB=2'b01;
        aluop= 2'b00;
        PCWrite=1;
        PCSource=2'b00;
        end
        
    ID:
       begin 
       ALUSrcA=0;
       ALUSrcB=2'b01;
       aluop= 2'b00;
       end
    
    EX_LS: 
        begin 
            ALUSrcA=1;
            ALUSrcB=2'b10;
            aluop= 2'b00;
        end
    MEM_LW:
        begin
            memread=1;
            IorD=1;
        end
    WB:
    begin
        regdst=0;
        regwrite=1;
        memtoreg=1;
    end
    MEM_SW:
            begin
                memwrite=1;
                IorD=1;
            end
    
    EX_R:
    begin 
                ALUSrcA=1;
                ALUSrcB=2'b00;
                aluop= 2'b10;
            end
    WB_R:
    begin
            regdst=1;
            regwrite=1;
            memtoreg=0;
        end
    EX_BRANCH:
    begin 
                ALUSrcA=1;
                ALUSrcB=2'b00;
                aluop= 2'b01;
                PCWrite=1;
                PCSource=2'b01;
            end
    EX_JMP:
        begin
            PCWrite=1;
            PCSource=2'b10;
        end
        
     endcase
end




endmodule
