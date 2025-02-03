module div_32(
    input wire [31:0] a_dividend,
    input wire [31:0] b_divisor,
    output reg [63:0] c_quotient_and_remainder
);
    integer i; 
    // Sign-extended registers
    reg [32:0] dividend_se;
    reg [64:0] quotient_and_remainder_se;

    always @(a_dividend or b_divisor) begin
        // Initialize divisor and remainder
        quotient_and_remainder_se[31:0] = b_divisor; // Divisor
        quotient_and_remainder_se[64:32] = 0; // Upper part (A = remainder)
        dividend_se[31:0] = a_dividend; // Dividend

        for (i = 0; i < 32; i = i + 1) begin
            // Step 1: Shift left A and Q by one binary position
            quotient_and_remainder_se = quotient_and_remainder_se << 1;

            // Perform subtraction or addition based on sign of A
            if (quotient_and_remainder_se[64] == 0) begin
                // A >= 0: Subtract divisor
                quotient_and_remainder_se[64:32] = quotient_and_remainder_se[64:32] - b_divisor;
            end else begin
                // A < 0: Add divisor back
                quotient_and_remainder_se[64:32] = quotient_and_remainder_se[64:32] + b_divisor;
            end

            // Update Q (quotient bit) based on the sign of A
            if (quotient_and_remainder_se[64] == 0) begin
                quotient_and_remainder_se[0] = 1; // A >= 0
            end else begin
                quotient_and_remainder_se[0] = 0; // A < 0
            end
        end

        // Output quotient and remainder
        c_quotient_and_remainder <= quotient_and_remainder_se[63:0];
    end
endmodule

