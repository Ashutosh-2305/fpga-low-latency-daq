`timescale 1ns/1ps

module tb_fifo;

localparam DATA_WIDTH = 16;
localparam DEPTH = 4;
localparam ADDR_WIDTH = 2;

reg clk;
reg rst;
reg wr_en;
reg rd_en;
reg [DATA_WIDTH-1:0] din;
wire [DATA_WIDTH-1:0] dout;
wire full;
wire empty;
wire [ADDR_WIDTH:0] level;
integer failures;

fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) uut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty),
    .level(level)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("sim/waves/tb_fifo.vcd");
    $dumpvars(0, tb_fifo);
end

task push_word;
    input [DATA_WIDTH-1:0] value;
    begin
        din = value;
        wr_en = 1'b1;
        rd_en = 1'b0;
        @(posedge clk);
        #1;
        wr_en = 1'b0;
    end
endtask

task pop_word;
    input [DATA_WIDTH-1:0] expected;
    begin
        rd_en = 1'b1;
        wr_en = 1'b0;
        @(posedge clk);
        #1;
        rd_en = 1'b0;
        if (dout !== expected) begin
            $display("TB_FIFO FAIL expected read=%0d got=%0d", expected, dout);
            failures = failures + 1;
        end
    end
endtask

initial begin
    failures = 0;
    clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    din = 0;

    repeat (2) @(posedge clk);
    rst = 0;

    if (!empty || level != 0) begin
        $display("TB_FIFO FAIL fifo should reset empty");
        failures = failures + 1;
    end

    push_word(16'd10);
    push_word(16'd20);
    push_word(16'd30);
    push_word(16'd40);

    if (!full || level != DEPTH) begin
        $display("TB_FIFO FAIL fifo should be full after four pushes");
        failures = failures + 1;
    end

    push_word(16'd99);
    if (level != DEPTH) begin
        $display("TB_FIFO FAIL level changed on blocked write");
        failures = failures + 1;
    end

    pop_word(16'd10);
    pop_word(16'd20);
    pop_word(16'd30);
    pop_word(16'd40);

    if (!empty || level != 0) begin
        $display("TB_FIFO FAIL fifo should be empty after reads");
        failures = failures + 1;
    end

    rd_en = 1'b1;
    @(posedge clk);
    #1;
    rd_en = 1'b0;
    if (!empty || level != 0) begin
        $display("TB_FIFO FAIL level changed on blocked read");
        failures = failures + 1;
    end

    if (failures == 0)
        $display("TB_FIFO PASS");
    else
        $fatal(1, "TB_FIFO FAILED with %0d mismatches", failures);

    #10 $finish;
end

endmodule
