`timescale 1ns/1ps

module tb_crc8;

localparam DATA_WIDTH = 48;

reg [DATA_WIDTH-1:0] data_in;
wire [7:0] crc_out;
wire [7:0] crc_out_corrupt;
reg [DATA_WIDTH-1:0] corrupted_data;
integer failures;

crc8 #(
    .DATA_WIDTH(DATA_WIDTH)
) uut (
    .data_in(data_in),
    .crc_out(crc_out)
);

crc8 #(
    .DATA_WIDTH(DATA_WIDTH)
) uut_corrupt (
    .data_in(corrupted_data),
    .crc_out(crc_out_corrupt)
);

initial begin
    $dumpfile("sim/waves/tb_crc8.vcd");
    $dumpvars(0, tb_crc8);
end

initial begin
    failures = 0;
    data_in = 48'h1234_5678_ABCD;
    corrupted_data = 48'h1234_5678_ABCD;
    #1;

    if (crc_out !== 8'hD6) begin
        $display("TB_CRC8 FAIL expected baseline CRC 0xD6 got 0x%0h", crc_out);
        failures = failures + 1;
    end

    corrupted_data = data_in ^ 48'h0000_0000_0001;
    #1;
    if (crc_out_corrupt === crc_out) begin
        $display("TB_CRC8 FAIL CRC did not change after corruption");
        failures = failures + 1;
    end

    if (failures == 0)
        $display("TB_CRC8 PASS");
    else
        $fatal(1, "TB_CRC8 FAILED with %0d mismatches", failures);

    #1 $finish;
end

endmodule
