`include "cpu.v"
`default_nettype none

module tb_;
reg clk;
reg rst_n;

cpu cp
(
    rst_n, clk
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_.vcd");
    $dumpvars(0, tb_);
end

initial begin
    #1 rst_n<=1'bx;clk<=1'bx;
    #(CLK_PERIOD*2) rst_n<=1;
    #(CLK_PERIOD*2) rst_n<=0;clk<=0;
    repeat(20) @(posedge clk);
    rst_n<=1;
    @(posedge clk);
    repeat(10) @(posedge clk);
    $finish(2);
end

endmodule
`default_nettype wire