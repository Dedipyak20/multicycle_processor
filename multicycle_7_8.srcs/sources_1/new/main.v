`timescale 1ns / 1ps

module main(
    input clk,
    input rst
);

// Instruction decode wires
wire [4:0]  rs, rt, rd;
wire [5:0]  control;
wire [15:0] imm_out;
wire [5:0]  alu_control_instr;

// Control signals
wire        IorD, memread, memwrite, IRWrite;
wire        regdst, regwrite, ALUSrcA;
wire [1:0]  ALUSrcB;
wire        memtoreg;
wire [1:0]  aluop;
wire        PCWrite, PCWriteCond, PCWriteCondNEQ;
wire [1:0]  PCSource;

control_decoder d1(
    .clk(clk), .rst(rst), .control(control),
    .IorD(IorD), .regdst(regdst), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
    .PCWrite(PCWrite), .PCWriteCond(PCWriteCond),
    .PCWriteCondNEQ(PCWriteCondNEQ), .PCSource(PCSource),
    .IRWrite(IRWrite), .memread(memread), .memtoreg(memtoreg),
    .aluop(aluop), .memwrite(memwrite), .regwrite(regwrite)
);

// Program Counter
wire        zero;
wire [31:0] next_addr;
wire [31:0] addr;

program_counter a1(
    .clk(clk), .rst(rst),
    .PCWrite(PCWrite), .PCWriteCond(PCWriteCond),
    .PCWriteCondNEQ(PCWriteCondNEQ),
    .zero(zero), .next_addr(next_addr), .addr(addr)
);

// Memory address mux (IorD)
wire [31:0] mem_address;
wire [31:0] aluout;
mux_2_32 aa(.i0(addr), .i1(aluout), .s(IorD), .out(mem_address));

// Combined Instruction / Data Memory
wire [31:0] mem_data;
wire [31:0] alu2;
instruction_memory b2(
    .memread(memread), .memwrite(memwrite),
    .address(mem_address), .write_data(alu2), .mem_data(mem_data)
);

// Memory Data Register
wire [31:0] mdr_out;
memory_data_register aa1(
    .clk(clk), .rst(rst), .mem_data(mem_data), .write_reg_data(mdr_out)
);

// Instruction Register / Decoder 
wire [25:0] jump_address_bits;
instruction_decoder c1(
    .clk(clk), .IRWrite(IRWrite), .instr(mdr_out),
    .control(control), .rs(rs), .rt(rt), .rd(rd),
    .imm(imm_out), .alu_control_instr(alu_control_instr),
    .jump_address_bits(jump_address_bits)
);

//  Write-register mux: rt (I-type/ADDI/LW) vs rd (R-type)
wire [4:0] write_register;
mux c2(.i0(rt), .i1(rd), .s(regdst), .out(write_register));

// Write-data mux: ALUout vs MDR 
wire [31:0] write_reg_data;
mux_2_32 d2(.i0(aluout), .i1(mdr_out), .s(memtoreg), .out(write_reg_data));

// Register File
wire [31:0] r1, r2;
registers f1(
    .clk(clk), .rs(rs), .rt(rt),
    .write_register(write_register), .write_reg_data(write_reg_data),
    .r1(r1), .r2(r2), .regwrite(regwrite)
);

// A / B pipeline registers 
reg [31:0] A_reg, B_reg;
always @(posedge clk or posedge rst) begin
    if (rst) begin A_reg <= 32'b0; B_reg <= 32'b0; end
    else     begin A_reg <= r1;    B_reg <= r2;    end
end

// ALU source A mux: PC vs A 
wire [31:0] alu1;
mux_2_32 f2(.i0(addr), .i1(A_reg), .s(ALUSrcA), .out(alu1));

// Sign-extend immediate and shift 
wire [31:0] signextend_out;
wire [31:0] sign_shift;
sign_extend  h5(.number(imm_out),        .extended_number(signextend_out));
shift_left_32 h6(.in(signextend_out),    .out(sign_shift));

// ALU source B mux: B / 4 / sign-ext / shifted 
//   ALUSrcB: 00=B, 01=4, 10=sign-ext imm, 11=sign-ext<<2
mux_4 f3(
    .i0(B_reg), .i1(32'd4), .i2(signextend_out), .i3(sign_shift),
    .s(ALUSrcB), .out(alu2)
);

//ALU Control 
wire [2:0] alu_sel;
alu_control h1(
    .alu_control_instr(alu_control_instr),
    .aluop(aluop), .alu_sel(alu_sel)
);

// ALU 
wire [31:0] alu_result;
alu h2(.a(alu1), .b(alu2), .alu_control_instr(alu_sel),
       .res(alu_result), .zero(zero));

// ALUout pipeline register 
reg [31:0] aluout_reg;
always @(posedge clk or posedge rst) begin
    if (rst) aluout_reg <= 32'b0;
    else     aluout_reg <= alu_result;
end
assign aluout = aluout_reg;

// Jump address 
wire [31:0] jump_address;
shift_left_2 h3(
    .number(jump_address_bits), .next_addr(addr),
    .jump_address(jump_address)
);

// PC source mux 
//   00=ALU result (PC+4), 01=ALUout (branch), 10=jump address
wire [31:0] pc_src3 = 32'h00000000;
mux_4 h4(
    .i0(alu_result), .i1(aluout), .i2(jump_address), .i3(pc_src3),
    .s(PCSource), .out(next_addr)
);

endmodule