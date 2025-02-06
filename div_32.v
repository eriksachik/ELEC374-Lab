`timescale 1ns/10ps
module div_32(
    input wire [31:0] a_dividend,
    input wire [31:0] b_divisor,
    output reg [63:0] c_quotient_and_remainder
);
    integer i;
    
    // Registers for quotient and remainder
    reg [64:0] quotient_and_remainder_se; 
    reg [31:0] divisor;  

    always @(a_dividend or b_divisor) begin
        // Initialize quotient, remainder, and divisor
        quotient_and_remainder_se = {32'b0, a_dividend};  // Remainder (A) initialized to 0, lower 32 bits store dividend
        divisor = b_divisor;  // Store divisor separately

        for (i = 0; i < 32; i = i + 1) begin
            // Step 1: Shift left the remainder and quotient
            quotient_and_remainder_se = quotient_and_remainder_se << 1;

            // Step 2: Subtract divisor from the remainder part
            quotient_and_remainder_se[64:32] = quotient_and_remainder_se[64:32] - divisor;

            // Step 3: If remainder is negative, restore it and set quotient bit to 0
            if (quotient_and_remainder_se[64] == 1) begin
                quotient_and_remainder_se[64:32] = quotient_and_remainder_se[64:32] + divisor; 
                quotient_and_remainder_se[0] = 0; 
            end else begin
                quotient_and_remainder_se[0] = 1; 
            end
        end

        // Assign the final quotient and remainder
        c_quotient_and_remainder <= quotient_and_remainder_se[63:0];
    end
endmodule
