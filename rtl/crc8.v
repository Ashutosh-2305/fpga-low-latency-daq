module crc8 #(
    parameter DATA_WIDTH = 48,
    parameter POLY = 8'h07
)(
    input  wire [DATA_WIDTH-1:0] data_in,
    output wire [7:0]            crc_out
);

function [7:0] calc_crc8;
    input [DATA_WIDTH-1:0] data;
    integer i;
    reg [7:0] crc;
    begin
        crc = 8'h00;
        for (i = DATA_WIDTH-1; i >= 0; i = i - 1) begin
            crc = {crc[6:0], 1'b0};
            if (crc[7] ^ data[i])
                crc = ({crc[6:0], 1'b0} ^ POLY);
        end
        calc_crc8 = crc;
    end
endfunction

assign crc_out = calc_crc8(data_in);

endmodule
