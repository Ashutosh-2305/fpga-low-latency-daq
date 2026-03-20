`timescale 1ns/1ps

module tb_timestamp;

reg clk;
reg rst;
reg enable;
wire [31:0] timestamp;
integer failures;

timestamp_counter uut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .timestamp(timestamp)
);

always #5 clk = ~clk;  // 100 MHz clock

initial begin
    $dumpfile("sim/waves/tb_timestamp.vcd");
    $dumpvars(0, tb_timestamp);
end

task expect_timestamp;
    input [31:0] expected;
    begin
        @(posedge clk);
        #1;
        if (timestamp !== expected) begin
            $display("TB_TIMESTAMP FAIL expected=%0d got=%0d", expected, timestamp);
            failures = failures + 1;
        end
    end
endtask

initial begin
    failures = 0;
    clk = 0;
    rst = 1;
    enable = 0;

    expect_timestamp(32'd0);
    expect_timestamp(32'd0);

    rst = 0;
    enable = 1;

    expect_timestamp(32'd1);
    expect_timestamp(32'd2);
    expect_timestamp(32'd3);

    enable = 0;
    expect_timestamp(32'd3);

    if (failures == 0)
        $display("TB_TIMESTAMP PASS");
    else
        $fatal(1, "TB_TIMESTAMP FAILED with %0d mismatches", failures);

    #10 $finish;
end

endmodule
