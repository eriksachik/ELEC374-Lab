`timescale 1ns/10ps
module div_32(
    input wire [31:0] a_dividend,
    input wire [31:0] b_divisor,
    output reg [63:0] c_quotient_and_remainder
);
    // Initialize registers
    reg [64:0] quotient_and_remainder_se; 
    reg [31:0] divisor;  
    reg [31:0] dividend;  
    reg [31:0] abs_q;
    reg [31:0] abs_m;
    reg [31:0] q;
    integer i;

    always @(a_dividend or b_divisor) begin

        // Handle division by 0
        if (b_divisor == 0) begin
            c_quotient_and_remainder = {2*32{1'b1}};  
        end else if (a_dividend == 0) begin
            c_quotient_and_remainder = 0;  // If dividend is 0, return 0
        end else begin
            q = 0;
            quotient_and_remainder_se = 0;

            // Get absolute values for signed division
            abs_q = a_dividend[31] ? -a_dividend : a_dividend;
            abs_m = b_divisor[31] ? -b_divisor : b_divisor;

            // Perform division using shift-and-subtract method
            for (i = 31; i >= 0; i = i - 1) begin
                quotient_and_remainder_se = quotient_and_remainder_se << 1;
                quotient_and_remainder_se[0] = abs_q[i];

                quotient_and_remainder_se = quotient_and_remainder_se - abs_m;

                if (quotient_and_remainder_se[64]) begin
                    q[i] = 0;
                    quotient_and_remainder_se = quotient_and_remainder_se + abs_m;
                end else begin
                    q[i] = 1;
                end
            end

            // Adjust the quotient's sign based on the dividend and divisor signs
            if (a_dividend[31] != b_divisor[31]) begin
                q = -q;
            end

            // Assign the final quotient and remainder (combining quotient and remainder)
            c_quotient_and_remainder = {quotient_and_remainder_se[63:32], q};
        end
    end
endmodule
