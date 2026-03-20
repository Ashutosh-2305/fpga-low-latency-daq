module daq_frontend #(
    parameter DATA_WIDTH = 16,
    parameter TS_WIDTH = 32,
    parameter FIFO_DEPTH = 4,
    parameter FIFO_ADDR_WIDTH = 2
)(
    input  wire                           clk,
    input  wire                           rst,
    input  wire                           enable,
    input  wire [DATA_WIDTH-1:0]          data_in,
    input  wire [DATA_WIDTH-1:0]          threshold,
    input  wire                           read_en,
    output wire                           trigger_out,
    output wire [TS_WIDTH-1:0]            timestamp_now,
    output reg  [TS_WIDTH-1:0]            event_timestamp,
    output reg  [DATA_WIDTH-1:0]          event_data,
    output reg                            event_valid,
    output wire [TS_WIDTH+DATA_WIDTH+8-1:0] fifo_dout,
    output wire                           fifo_full,
    output wire                           fifo_empty,
    output wire [FIFO_ADDR_WIDTH:0]       fifo_level
);

localparam PAYLOAD_WIDTH = TS_WIDTH + DATA_WIDTH;
localparam PACKET_WIDTH = PAYLOAD_WIDTH + 8;

wire [TS_WIDTH-1:0] timestamp_value;
wire trigger_condition;
wire [PAYLOAD_WIDTH-1:0] crc_payload;
wire [7:0] crc_value;
wire write_en;

assign trigger_condition = enable && (data_in > threshold);
assign trigger_out = trigger_condition;
assign timestamp_now = timestamp_value;
assign crc_payload = {timestamp_value, data_in};
assign write_en = trigger_condition && !fifo_full;

timestamp_counter #(
    .WIDTH(TS_WIDTH)
) u_timestamp_counter (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .timestamp(timestamp_value)
);

crc8 #(
    .DATA_WIDTH(PAYLOAD_WIDTH)
) u_crc8 (
    .data_in(crc_payload),
    .crc_out(crc_value)
);

fifo #(
    .DATA_WIDTH(PACKET_WIDTH),
    .DEPTH(FIFO_DEPTH),
    .ADDR_WIDTH(FIFO_ADDR_WIDTH)
) u_fifo (
    .clk(clk),
    .rst(rst),
    .wr_en(write_en),
    .rd_en(read_en),
    .din({crc_payload, crc_value}),
    .dout(fifo_dout),
    .full(fifo_full),
    .empty(fifo_empty),
    .level(fifo_level)
);

always @(posedge clk) begin
    if (rst) begin
        event_timestamp <= 0;
        event_data <= 0;
        event_valid <= 0;
    end else begin
        event_valid <= write_en;
        if (write_en) begin
            event_timestamp <= timestamp_value;
            event_data <= data_in;
        end
    end
end

endmodule
