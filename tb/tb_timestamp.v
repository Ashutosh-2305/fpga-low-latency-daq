`timescale 1ns/1ps

module tb_timestamp;

reg clk;
reg rst;
reg enable;
wire [31:0] timestamp;

timestamp_counter uut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .timestamp(timestamp)
);

always #5 clk = ~clk;  // 100 MHz clock

initial begin
    clk = 0;
    rst = 1;
    enable = 0;

    #20 rst = 0;
    enable = 1;

    #200 $finish;
end

endmodule
