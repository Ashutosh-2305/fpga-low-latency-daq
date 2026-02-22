`timescale 1ns/1ps

module tb_trigger;

reg clk;
reg rst;
reg [15:0] data_in;
reg [15:0] threshold;
wire trigger_out;

trigger uut (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .threshold(threshold),
    .trigger_out(trigger_out)
);

always #5 clk = ~clk;  // 100 MHz clock

initial begin
    clk = 0;
    rst = 1;
    data_in = 0;
    threshold = 100;

    #20 rst = 0;

    #10 data_in = 50;
    #10 data_in = 120;
    #10 data_in = 80;
    #10 data_in = 150;

    #50 $finish;
end

endmodule
