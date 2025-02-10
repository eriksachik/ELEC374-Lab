`timescale 1ns/10ps
module div_32 (
    input wire [31:0] a_dividend,
    input wire [31:0] b_divisor,
    output reg [63:0] c_quotient_and_remainder
);

// Initialize registers
reg [32:0] a;
reg [31:0] q;
integer i;
reg [31:0] abs_q;
reg [31:0] abs_m;

always @(*) begin

    if (b_divisor == 0) begin
        c_quotient_and_remainder = {2*32{1'b1}};  // Handle division by 0
    end else if (a_dividend == 0) begin
        c_quotient_and_remainder = 0;  // If dividend is 0, result is 0
    end else begin
        q = 0;
        a = 0;

        // If the signed bit is 1, get the absolute value of dividend and divisor
        abs_q = a_dividend[31] ? -a_dividend : a_dividend;
        abs_m = b_divisor[31] ? -b_divisor : b_divisor;

        for (i = 31; i >= 0; i = i - 1) begin
            a = a << 1;               // Shift left the remainder
            a[0] = abs_q[i];          // Append the next bit from the dividend

            a = a - abs_m;            // Subtract the divisor

            if (a[32]) begin          // If the remainder is negative
                q[i] = 0;             // Set quotient bit to 0
                a = a + abs_m;        // Restore the remainder
            end else begin
                q[i] = 1;             // Set quotient bit to 1
            end
        end

        // Adjust the sign of the quotient if necessary
        if (a_dividend[31] != b_divisor[31]) begin
            q = ~q;  // If dividend and divisor have different signs, negate the quotient
        end

        // Set the result to combine quotient and remainder
        c_quotient_and_remainder = {a[31:0], q};
    end
end

endmodule
