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
    reg [31:0] dividend;  
    reg dividend_sign, divisor_sign;

    always @(a_dividend or b_divisor) begin
        // Determine the signs of the dividend and divisor
        dividend_sign = a_dividend[31];
        divisor_sign = b_divisor[31];

        // Take absolute values for the division process
        dividend = dividend_sign ? -a_dividend : a_dividend;
        divisor = divisor_sign ? -b_divisor : b_divisor;

        // Initialize quotient and remainder
        quotient_and_remainder_se = {32'b0, dividend};  // Remainder (A) initialized to 0, lower 32 bits store dividend

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

        // After division, assign the quotient and remainder
        c_quotient_and_remainder <= quotient_and_remainder_se[63:0];

        // Step 4: Correct the signs of the quotient and remainder
        if (dividend_sign ^ divisor_sign) begin  // If signs are different, negate the quotient
            c_quotient_and_remainder[63:32] <= -c_quotient_and_remainder[63:32];  // Negate the quotient
        end

        // Ensure remainder sign follows dividend
        if (dividend_sign) begin  // If dividend is negative
            c_quotient_and_remainder[31:0] <= -c_quotient_and_remainder[31:0];  // Negate the remainder
        end
    end
endmodule
