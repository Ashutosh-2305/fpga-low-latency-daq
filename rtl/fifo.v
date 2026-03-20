module fifo #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 4,
    parameter ADDR_WIDTH = 2
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  wr_en,
    input  wire                  rd_en,
    input  wire [DATA_WIDTH-1:0] din,
    output reg  [DATA_WIDTH-1:0] dout,
    output wire                  full,
    output wire                  empty,
    output reg  [ADDR_WIDTH:0]   level
);

reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
reg [ADDR_WIDTH-1:0] wr_ptr;
reg [ADDR_WIDTH-1:0] rd_ptr;

wire do_write;
wire do_read;

assign do_write = wr_en && !full;
assign do_read  = rd_en && !empty;

assign full  = (level == DEPTH);
assign empty = (level == 0);

always @(posedge clk) begin
    if (rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        dout   <= 0;
        level  <= 0;
    end else begin
        if (do_write) begin
            mem[wr_ptr] <= din;
            wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1'b1;
        end

        if (do_read) begin
            dout <= mem[rd_ptr];
            rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1'b1;
        end

        case ({do_write, do_read})
            2'b10: level <= level + 1'b1;
            2'b01: level <= level - 1'b1;
            default: level <= level;
        endcase
    end
end

endmodule
