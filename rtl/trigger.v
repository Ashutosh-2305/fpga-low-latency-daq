module trigger #(
    parameter WIDTH = 16
)(
    input wire clk,
    input wire rst,
    input wire [WIDTH-1:0] data_in,
    input wire [WIDTH-1:0] threshold,
    output reg trigger_out
);

always @(posedge clk) begin
    if (rst)
        trigger_out <= 0;
    else
        trigger_out <= (data_in > threshold);
end

endmodule
