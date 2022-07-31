`define jmp     4'b0000
`define ld      4'b0001
`define st      4'b0010
`define li      4'b0011
`define add     4'b0100
`define sub     4'b0101
`define and_    4'b0110
`define or_     4'b0111
`define invert  4'b1000
`define lsl     4'b1001
`define lsr     4'b1010
`define beq     4'b1011
`define bne     4'b1100
`define slt     4'b1111

module control (
    instruction, alu_control, regWrite, memWrite,
    regWriteDst, aluBSrcSel, memToReg, branch, aluFlags
);

input [15:0] instruction;
input [7:0] aluFlags;
output reg memWrite, regWrite, regWriteDst, aluBSrcSel, memToReg, branch;
output reg [3:0] alu_control;
wire [3:0] opc;
assign opc = instruction[15:12];

wire aluZeroFlag, aluCarryFlag, aluLargerFlag;

assign aluCarryFlag = aluFlags[0];
assign aluZeroFlag = aluFlags[1];
assign aluLargerFlag = aluFlags[2];

always @* begin
    case (opc)

        `ld: begin
            regWrite <= 1'b1;
            memWrite <= 1'b0;
            alu_control <= 4'b0010;
            regWriteDst <= 1'b1;
            aluBSrcSel <= 1'b0;
            memToReg <= 1'b1;
            branch <= 1'b0;
        end

        `st: begin
            regWrite <= 1'b0;
            memWrite <= 1'b1;
            alu_control <= 4'b0010;
            aluBSrcSel <= 1'b0;
            branch <= 1'b0;
        end

        `li: begin
            regWrite <= 1'b1;
            memWrite <= 1'b0;
            alu_control <= 4'b0000;
            regWriteDst <= 1'b1;
            aluBSrcSel <= 1'b0;
            memToReg <= 1'b0;
            branch <= 1'b0;
        end
        
        `add: begin
            regWrite <= 1'b1;
            memWrite <= 0;
            alu_control <= 4'b0010;
            regWriteDst <= 0;
            aluBSrcSel <= 1;
            memToReg <= 0;
            branch <= 1'b0;
        end

        `sub: begin
            regWrite <= 1'b1;
            memWrite <= 0;
            alu_control <= 4'b0011;
            regWriteDst <= 0;
            aluBSrcSel <= 1;
            memToReg <= 0;
            branch <= 1'b0;            
        end

        `and_: begin
            regWrite <= 1'b1;
            memWrite <= 0;
            alu_control <= 4'b0001;
            regWriteDst <= 0;
            aluBSrcSel <= 1;
            memToReg <= 0;
            branch <= 1'b0;            
        end

        `or_: begin
            regWrite <= 1'b1;
            memWrite <= 0;
            alu_control <= 4'b0100;
            regWriteDst <= 0;
            aluBSrcSel <= 1;
            memToReg <= 0;
            branch <= 1'b0;            
        end

        `invert: begin
            regWrite <= 1'b1;
            memWrite <= 0;
            alu_control <= 4'b0101;
            regWriteDst <= 0;
            aluBSrcSel <= 1;
            memToReg <= 0;
            branch <= 1'b0;            
        end

        `lsl: begin
            regWrite <= 1'b1;
            memWrite <= 0;
            alu_control <= 4'b0110;
            regWriteDst <= 0;
            aluBSrcSel <= 1;
            memToReg <= 0;
            branch <= 1'b0;            
        end

        `lsr: begin
            regWrite <= 1'b1;
            memWrite <= 0;
            alu_control <= 4'b0111;
            regWriteDst <= 0;
            aluBSrcSel <= 1;
            memToReg <= 0;
            branch <= 1'b0;            
        end

        `beq: begin
            regWrite <= 0;
            memWrite <= 0;
            aluBSrcSel <= 1;
            alu_control <= 4'b0011;
            if(aluZeroFlag) begin
                 branch <= 1'b1;
            end else begin
                 branch <= 1'b0;
            end
        end

        `bne: begin
            regWrite <= 0;
            memWrite <= 0;
            aluBSrcSel <= 1;
            alu_control <= 4'b0011;
            if(aluZeroFlag) begin
                 branch <= 1'b0;
            end else begin
                 branch <= 1'b1;
            end
        end

        `jmp: begin
            regWrite <= 0;
            memWrite <= 0;
            branch <= 1'b1;
        end

        `slt: begin
            regWrite <= 1'b1;
            memWrite <= 0;
            alu_control <= 4'b1000;
            regWriteDst <= 0;
            aluBSrcSel <= 1;
            memToReg <= 0;
            branch <= 1'b0;     
        end

        default: begin
            
        end

    endcase
end
    
endmodule