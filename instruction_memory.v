module instruction_memory (
    address, data, unvalid_mem_addr
);

parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 16;
parameter MEM_DEPTH = 1 << 10;
parameter MEM_OFFSET = 0;


input [ADDR_WIDTH-1:0] address;

output reg [DATA_WIDTH-1:0] data;
output reg unvalid_mem_addr;

wire [15:0] addr;
assign addr = address>>1;

reg  [DATA_WIDTH-1:0] mem [MEM_DEPTH-1:0];

always @* begin
    if((addr >= MEM_OFFSET) && (addr < MEM_OFFSET + MEM_DEPTH)) begin
        data <= mem[addr];
        unvalid_mem_addr <= 0;
    end else begin
        unvalid_mem_addr <= 1;
    end
end
integer i;
initial begin
    
i = 0;
mem[i] = 16'b0011000000001010;
i = i + 1;
mem[i] = 16'b0011000100010100;
i = i + 1;
mem[i] = 16'b0011001011110110;
i = i + 1;
mem[i] = 16'b0011001111101100;
i = i + 1;
mem[i] = 16'b0100001000000000;
i = i + 1;
mem[i] = 16'b0100011101000000;
i = i + 1;
mem[i] = 16'b1101000110000000;
i = i + 1;
mem[i] = 16'b0011111100000000;
i = i + 1;
mem[i] = 16'b1011111011110111;
i = i + 1;

    
end
    
endmodule