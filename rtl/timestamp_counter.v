module timestamp_counter #(
    parameter WIDTH = 32
)(
    input wire clk,
    input wire rst,
    input wire enable,
    output reg [WIDTH-1:0] timestamp
);

always @(posedge clk) begin
    if (rst)
        timestamp <= 0;
    else if (enable)
        timestamp <= timestamp + 1;
end

endmodule
