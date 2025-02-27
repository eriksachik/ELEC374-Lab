module decoder4to16(
    input  wire [3:0] addr,  // 4-bit address input
    input  wire       enable, // Enable signal
    output reg  [15:0] out    // 16-bit output
);

    always @(*) begin
        if (enable) begin
            out = 16'b0;         // Default all outputs to 0
            out[addr] = 1'b1;    // Set the selected output to 1
        end else begin
            out = 16'b0;         // If disabled, all outputs remain 0
        end
    end

endmodule
