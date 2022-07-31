module memory (
    clk, addr, wr_data, wr_en, rd_data
);

input clk, wr_en;
input [7:0] addr;
input [7:0] wr_data;

output wire [7:0] rd_data;

reg [7:0] zero_page_mem [255:0];

assign rd_data = zero_page_mem[addr];

always @(posedge clk ) begin
    if(wr_en) begin
        if (addr < 16'h100) begin
            zero_page_mem[addr] <= wr_data;
        end
    end
end

endmodule