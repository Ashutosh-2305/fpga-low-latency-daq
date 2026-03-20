`timescale 1ns/1ps

module tb_trigger;

reg clk;
reg rst;
reg [15:0] data_in;
reg [15:0] threshold;
wire trigger_out;
integer failures;

trigger uut (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .threshold(threshold),
    .trigger_out(trigger_out)
);

always #5 clk = ~clk;  // 100 MHz clock

initial begin
    $dumpfile("sim/waves/tb_trigger.vcd");
    $dumpvars(0, tb_trigger);
end

task expect_trigger;
    input [15:0] sample;
    input expected;
    begin
        data_in = sample;
        @(posedge clk);
        #1;
        if (trigger_out !== expected) begin
            $display("TB_TRIGGER FAIL sample=%0d expected=%0b got=%0b", sample, expected, trigger_out);
            failures = failures + 1;
        end
    end
endtask

initial begin
    failures = 0;
    clk = 0;
    rst = 1;
    data_in = 0;
    threshold = 100;

    repeat (2) @(posedge clk);
    rst = 0;

    expect_trigger(16'd50, 1'b0);
    expect_trigger(16'd100, 1'b0);
    expect_trigger(16'd101, 1'b1);
    expect_trigger(16'd80, 1'b0);
    expect_trigger(16'd150, 1'b1);

    if (failures == 0)
        $display("TB_TRIGGER PASS");
    else
        $fatal(1, "TB_TRIGGER FAILED with %0d mismatches", failures);

    #10 $finish;
end

endmodule
