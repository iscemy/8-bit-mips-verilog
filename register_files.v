module regfile (
    clk,
    wr_en3, wr_addr3, wr_d3,    
    rd_d2, rd_addr2,
    rd_d1, rd_addr1
);

input clk, wr_en3;  
input[1:0] rd_addr1, rd_addr2, wr_addr3;
input[7:0] wr_d3;
output[7:0] rd_d1, rd_d2;

reg [7:0] registers [3:0]; 


/// work around for iverlog's problem with array dump
wire[7:0] r0, r1, r2, r3;
assign r0 = registers[0];
assign r1 = registers[1];
assign r2 = registers[2];
assign r3 = registers[3];
/// work around for iverlog's problem with array dump

/*
reg[0] A
reg[1] B
reg[2] C
reg[3] SP
*/


// assign rd_d1 = (rd_addr1 != 0) ? registers[rd_addr1] : 0;
// assign rd_d2 = (rd_addr2 != 0) ? registers[rd_addr2] : 0;

assign rd_d1 = registers[rd_addr1];
assign rd_d2 = registers[rd_addr2];

always @(posedge clk ) begin
    if(wr_en3) registers[wr_addr3] <= wr_d3;
end

endmodule