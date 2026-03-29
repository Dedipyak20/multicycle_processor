`timescale 1ns / 1ps

module control_decoder(clk, rst, control,
    IorD, regdst, ALUSrcA, ALUSrcB,
    PCWrite, PCWriteCond, PCWriteCondNEQ, PCSource,
    IRWrite, memread, memtoreg, aluop, memwrite, regwrite);

input  clk, rst;
input  [5:0] control;       // opcode

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
output reg PCWriteCond;     // branch-if-equal  (fires when zero=1)
output reg PCWriteCondNEQ;  // branch-if-not-eq (fires when zero=0)
output reg [1:0] PCSource;

// ── FSM states 
reg [3:0] state, next_state;

parameter IF         = 4'd0;
parameter ID         = 4'd1;
parameter EX_LS      = 4'd2;   // address calc for LW/SW
parameter MEM_LW     = 4'd3;
parameter WB_LW      = 4'd4;   // writeback for LW
parameter MEM_SW     = 4'd5;
parameter EX_R       = 4'd6;   // execute R-type (incl. NAND)
parameter WB_R       = 4'd7;
parameter EX_BRANCH  = 4'd8;   // BEQ execute
parameter EX_BNEQ    = 4'd9;   // BNEQ execute  ← new
parameter EX_JMP     = 4'd10;
parameter EX_ADDI    = 4'd11;  // ADDI execute  ← new
parameter WB_ADDI    = 4'd12;  // ADDI writeback ← new

// ── Opcodes 
parameter LW   = 6'b100011;
parameter SW   = 6'b101011;
parameter R    = 6'b000000;
parameter BEQ  = 6'b000100;
parameter BNEQ = 6'b000101;  // ← new (was missing)
parameter JMP  = 6'b000010;  // ← fixed (was 000001)
parameter ADDI = 6'b001000;  // ← new

// ── State register 
always@(posedge clk or posedge rst) begin
    if (rst) state <= IF;
    else     state <= next_state;
end

// ── Next-state logic 
always@(*) begin
    case(state)
        IF:  next_state = ID;
        ID:  case(control)
                 LW:   next_state = EX_LS;
                 SW:   next_state = EX_LS;
                 R:    next_state = EX_R;
                 BEQ:  next_state = EX_BRANCH;
                 BNEQ: next_state = EX_BNEQ;
                 JMP:  next_state = EX_JMP;
                 ADDI: next_state = EX_ADDI;
                 default: next_state = IF;
             endcase
        EX_LS:   next_state = (control == LW) ? MEM_LW : MEM_SW;
        MEM_LW:  next_state = WB_LW;
        WB_LW:   next_state = IF;
        MEM_SW:  next_state = IF;
        EX_R:    next_state = WB_R;
        WB_R:    next_state = IF;
        EX_BRANCH: next_state = IF;
        EX_BNEQ:   next_state = IF;
        EX_JMP:    next_state = IF;
        EX_ADDI:   next_state = WB_ADDI;
        WB_ADDI:   next_state = IF;
        default:   next_state = IF;
    endcase
end

// ── Output logic (Moore) 
always@(*) begin
    // defaults - all off
    IorD=0; memread=0; memwrite=0; IRWrite=0;
    regdst=0; regwrite=0; ALUSrcA=0; ALUSrcB=2'b00;
    memtoreg=0; aluop=2'b00;
    PCWrite=0; PCWriteCond=0; PCWriteCondNEQ=0; PCSource=2'b00;

    case(state)
        // ── Fetch 
        IF: begin
            memread  = 1;
            IRWrite  = 1;
            ALUSrcA  = 0;        // PC
            ALUSrcB  = 2'b01;   // +4
            aluop    = 2'b00;   // ADD
            PCWrite  = 1;
            PCSource = 2'b00;   // ALU result (PC+4)
        end

        // ── Decode / register read 
        ID: begin
            ALUSrcA = 0;
            ALUSrcB = 2'b11;    // sign-extended immediate << 2 (branch target pre-calc)
            aluop   = 2'b00;
        end

        // ── LW / SW address calculation 
        EX_LS: begin
            ALUSrcA = 1;        // reg A
            ALUSrcB = 2'b10;    // sign-extended immediate
            aluop   = 2'b00;   // ADD
        end

        // ── LW memory read 
        MEM_LW: begin
            memread = 1;
            IorD    = 1;        // address from ALUout
        end

        // ── LW writeback 
        WB_LW: begin
            regdst   = 0;       // destination = rt
            regwrite = 1;
            memtoreg = 1;       // data from MDR
        end

        // ── SW memory write 
        MEM_SW: begin
            memwrite = 1;
            IorD     = 1;
        end

        // ── R-type execute (ADD/SUB/AND/OR/NAND)
        EX_R: begin
            ALUSrcA = 1;        // reg A
            ALUSrcB = 2'b00;   // reg B
            aluop   = 2'b10;   // use funct field
        end

        // ── R-type writeback 
        WB_R: begin
            regdst   = 1;       // destination = rd
            regwrite = 1;
            memtoreg = 0;       // data from ALUout
        end

        // ── ADDI execute 
        EX_ADDI: begin
            ALUSrcA = 1;        // reg A (rs)
            ALUSrcB = 2'b10;   // sign-extended immediate
            aluop   = 2'b00;   // ADD
        end

        // ── ADDI writeback 
        WB_ADDI: begin
            regdst   = 0;       // destination = rt
            regwrite = 1;
            memtoreg = 0;       // data from ALUout (not memory)
        end

        //── BEQ execute 
        EX_BRANCH: begin
            ALUSrcA      = 1;       // reg A
            ALUSrcB      = 2'b00;  // reg B
            aluop        = 2'b01;  // SUB
            PCWriteCond  = 1;      // write PC if zero=1
            PCSource     = 2'b01; // branch target (ALUout)
        end

        // BNEQ execute 
        EX_BNEQ: begin
            ALUSrcA         = 1;
            ALUSrcB         = 2'b00;
            aluop           = 2'b01;  // SUB
            PCWriteCondNEQ  = 1;      // write PC if zero=0
            PCSource        = 2'b01;
        end

        //Jump 
        EX_JMP: begin
            PCWrite  = 1;
            PCSource = 2'b10;   // jump address
        end
    endcase
end

endmodule