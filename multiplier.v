`timescale 1ns/10ps
module multiplier (
    input clk,                  // Clock input
    input reset,                // Reset signal
    input [31:0] Mplr,          // Multiplier
    input [31:0] Mcnd,          // Multiplicand
    output reg [63:0] Y         // 64-bit product (final result)
);

    reg [63:0] accum;           // Accumulator for the product
    reg [63:0] multiplicand_ext; // Sign-extended multiplicand
    reg [63:0] multiplier_ext;  // Sign-extended multiplier
    reg [33:0] booth;           // Booth's algorithm requires 33-bit register
    integer i;                  // Loop variable

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Y <= 64'b0;            // Reset the product to zero
            accum <= 64'b0;        // Reset accumulator
        end else begin
            // Sign extend the multiplier and multiplicand
            multiplicand_ext = {{32{Mcnd[31]}}, Mcnd};  // Sign extend multiplicand to 64-bits
            multiplier_ext    = {{32{Mplr[31]}}, Mplr};  // Sign extend multiplier to 64-bits

            accum = 64'd0;        // Clear accumulator at the start of multiplication

            // Initialize the booth with the lower 32 bits of the multiplier plus an extra bit (total 33 bits)
            booth = {multiplier_ext[31:0], 1'b0};  

            // Perform Booth multiplication
            for (i = 0; i < 32; i = i + 1) begin
                case (booth[1:0])  // Booth's algorithm logic
                    2'b01: accum = accum + (multiplicand_ext << i);  // Add the shifted multiplicand
                    2'b10: accum = accum - (multiplicand_ext << i);  // Subtract the shifted multiplicand
                    default: ;  // No operation for 00 or 11
                endcase

                // Perform arithmetic right shift of booth (preserving sign)
                booth = {booth[33], booth[33:1]};
            end

            // Store the final result into Y
            Y <= accum;
        end
    end
endmodule

