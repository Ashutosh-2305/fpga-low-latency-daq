`timescale 1ns/1ps

module tb_daq_frontend;

localparam DATA_WIDTH = 16;
localparam TS_WIDTH = 32;
localparam FIFO_DEPTH = 4;
localparam FIFO_ADDR_WIDTH = 2;
localparam PACKET_WIDTH = DATA_WIDTH + TS_WIDTH + 8;

reg clk;
reg rst;
reg enable;
reg [DATA_WIDTH-1:0] data_in;
reg [DATA_WIDTH-1:0] threshold;
reg read_en;
wire trigger_out;
wire [TS_WIDTH-1:0] timestamp_now;
wire [TS_WIDTH-1:0] event_timestamp;
wire [DATA_WIDTH-1:0] event_data;
wire event_valid;
wire [PACKET_WIDTH-1:0] fifo_dout;
wire fifo_full;
wire fifo_empty;
wire [FIFO_ADDR_WIDTH:0] fifo_level;
integer failures;

reg [7:0] expected_crc;
reg [7:0] expected_crc_corrupt;
reg [PACKET_WIDTH-1:0] captured_packet;
reg [PACKET_WIDTH-1:0] corrupt_packet;
reg [PACKET_WIDTH-1:0] expected_first_packet;

daq_frontend #(
    .DATA_WIDTH(DATA_WIDTH),
    .TS_WIDTH(TS_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH),
    .FIFO_ADDR_WIDTH(FIFO_ADDR_WIDTH)
) uut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .data_in(data_in),
    .threshold(threshold),
    .read_en(read_en),
    .trigger_out(trigger_out),
    .timestamp_now(timestamp_now),
    .event_timestamp(event_timestamp),
    .event_data(event_data),
    .event_valid(event_valid),
    .fifo_dout(fifo_dout),
    .fifo_full(fifo_full),
    .fifo_empty(fifo_empty),
    .fifo_level(fifo_level)
);

crc8 #(
    .DATA_WIDTH(DATA_WIDTH + TS_WIDTH)
) crc_ref (
    .data_in({event_timestamp, event_data}),
    .crc_out(expected_crc)
);

crc8 #(
    .DATA_WIDTH(DATA_WIDTH + TS_WIDTH)
) crc_ref_corrupt (
    .data_in(corrupt_packet[PACKET_WIDTH-1:8]),
    .crc_out(expected_crc_corrupt)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("sim/waves/tb_daq_frontend.vcd");
    $dumpvars(0, tb_daq_frontend);
end

task drive_sample;
    input [DATA_WIDTH-1:0] sample;
    input expected_trigger;
    begin
        data_in = sample;
        @(posedge clk);
        #1;
        if (trigger_out !== expected_trigger) begin
            $display("TB_DAQ FAIL trigger mismatch sample=%0d expected=%0b got=%0b", sample, expected_trigger, trigger_out);
            failures = failures + 1;
        end
    end
endtask

initial begin
    failures = 0;
    clk = 0;
    rst = 1;
    enable = 0;
    data_in = 0;
    threshold = 16'd100;
    read_en = 0;
    captured_packet = 0;
    corrupt_packet = 0;
    expected_first_packet = 0;

    repeat (2) @(posedge clk);
    rst = 0;
    enable = 1;

    drive_sample(16'd40, 1'b0);
    drive_sample(16'd125, 1'b1);

    if (!event_valid) begin
        $display("TB_DAQ FAIL event_valid not asserted on trigger");
        failures = failures + 1;
    end

    if (event_timestamp !== 32'd1) begin
        $display("TB_DAQ FAIL expected event timestamp 1 got %0d", event_timestamp);
        failures = failures + 1;
    end

    if (event_data !== 16'd125) begin
        $display("TB_DAQ FAIL expected event data 125 got %0d", event_data);
        failures = failures + 1;
    end

    #1;
    expected_first_packet = {event_timestamp, event_data, expected_crc};
    if (uut.u_fifo.mem[0] !== expected_first_packet) begin
        $display("TB_DAQ FAIL FIFO packet does not match tagged payload");
        failures = failures + 1;
    end

    drive_sample(16'd80, 1'b0);
    drive_sample(16'd130, 1'b1);
    drive_sample(16'd135, 1'b1);
    drive_sample(16'd140, 1'b1);

    if (!fifo_full) begin
        $display("TB_DAQ FAIL fifo should be full after four trigger events");
        failures = failures + 1;
    end

    drive_sample(16'd150, 1'b1);
    if (fifo_level != FIFO_DEPTH) begin
        $display("TB_DAQ FAIL fifo level changed on blocked trigger write");
        failures = failures + 1;
    end

    read_en = 1'b1;
    @(posedge clk);
    #1;
    read_en = 1'b0;
    captured_packet = fifo_dout;
    if (captured_packet !== expected_first_packet) begin
        $display("TB_DAQ FAIL first packet mismatch got 0x%0h", captured_packet);
        failures = failures + 1;
    end

    corrupt_packet = captured_packet ^ {{(PACKET_WIDTH-1){1'b0}}, 1'b1};
    #1;
    if (expected_crc_corrupt === corrupt_packet[7:0]) begin
        $display("TB_DAQ FAIL CRC did not detect injected corruption");
        failures = failures + 1;
    end

    if (failures == 0)
        $display("TB_DAQ_FRONTEND PASS");
    else
        $fatal(1, "TB_DAQ_FRONTEND FAILED with %0d mismatches", failures);

    #10 $finish;
end

endmodule
