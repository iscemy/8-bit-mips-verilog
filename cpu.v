`include "memory.v"
`include "alu.v"
`include "register_files.v"
`include "instruction_memory.v"
`include "control.v"

module cpu (
    rst,
    clk
);
/*
    i type instruction
    op      rs      rt      offset
    15:12   11:10   9:8     7:0

    r type instruction
    op      rs      rt      rd      reserved
    15:12   11:10    9:8     7:6     2:0
*/

input clk, rst;
wire regWrite, memWrite, regWriteDst, aluBSrcSel, memToReg, PCNSource;
wire [3:0] alu_control;
wire [1:0] reg_wr_addr3, reg_rd_addr2, reg_rd_addr1;
wire [7:0] reg_wr_d3, memOut;
wire [7:0] reg_rd_d2, reg_rd_d1, aluBInput;
wire [7:0] offsetSigned, aluResult, branchOffsetSigned, program_counter_n, PCPlus4, PCBranched;
wire [15:0] instruction;
wire [7:0] aluFlags;
reg [15:0] program_counter_c;


regfile register_file(clk, regWrite, reg_wr_addr3, reg_wr_d3, reg_rd_d2, reg_rd_addr2, reg_rd_d1, reg_rd_addr1);

assign reg_rd_addr1 = instruction[11:10];
assign reg_rd_addr2 = instruction[9:8];

assign offsetSigned = (instruction[7] == 0) ? {8'b00000000, instruction[7:0]} : {8'b11111111, instruction[7:0]};

control control_unit(instruction, alu_control, regWrite, memWrite, regWriteDst, aluBSrcSel, memToReg, PCNSource, aluFlags);

alu alu_unit(reg_rd_d1, aluBInput, aluResult, aluFlags, alu_control);
memory mem (clk, aluResult, reg_rd_d2, memWrite, memOut);

instruction_memory instrct_mem(program_counter_c, instruction,);

assign aluBInput = (aluBSrcSel) ? reg_rd_d2 : offsetSigned; // 0 adding offset to A i type
assign reg_wr_d3 = (memToReg) ? memOut : aluResult;                         //
assign reg_wr_addr3 = (regWriteDst) ? instruction[9:8] : instruction[7:6];  // 1 i type 0 r type

assign branchOffsetSigned = {offsetSigned[14:0], 1'b0}; // shift one left
assign PCPlus4 = program_counter_c + 2;
assign PCBranched = branchOffsetSigned + PCPlus4;
assign program_counter_n = (PCNSource) ? PCBranched : PCPlus4;

always @(posedge clk ) begin
    program_counter_c <= program_counter_n;
end

always @(posedge rst ) begin
    if(rst) program_counter_c <= 0;
end

endmodule