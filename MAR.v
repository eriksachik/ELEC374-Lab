`timescale 1ns/10ps
module MAR (
    input wire clk,            // Clock input
    input wire clr,            // Clear signal
    input wire [31:0] dIn,     // 32-bit input data (memory address)
    input wire Rin,            // Register input signal
    output reg [8:0] address   // 9-bit address output (Memory Address Register)
);

    always @(negedge clk or posedge clr) begin
        if (clr)          // When clear is low, reset the address to 0
            address <= 9'b0;
        else if (Rin)          // When Rin is high, load the lower 9 bits of dIn to address
            address <= dIn[8:0];
    end

    initial begin
        address = 9'b0;       // Initialize address to 0 at the start
    end

endmodule
