`timescale 1ns/10ps
module MAR #(parameter VAL = 0)(
    input wire clk,          // Clock
    input wire clr,          // Clear signal
    input wire [31:0] dIn,   // 32-bit data input (memory address)
    input wire Rin,          // Register input signal
    output reg [8:0] address // 9-bit address output (Memory Address Register)
);

    always @(posedge clk or negedge clr) begin
        if (~clr) begin
            address <= VAL;    // Reset address to VAL
        end else if (Rin) begin
            address <= dIn[8:0]; // Capture lower 9 bits of the input data into address
        end
    end

    initial begin
        address = VAL;  // Initialize address to VAL at the start
    end
endmodule
