`timescale 1ns/10ps 
module ArithmeticRightShift(
    input [31:0] unshifted,
    input [31:0] shiftBy,  // Full 32-bit input, but only the lower 5 bits are used
    output reg [31:0] shifted
);
    integer i, j;
    
    always @(*) begin
        shifted = unshifted;  // Initialize with the original value
        for (j = 0; j < shiftBy[4:0]; j = j + 1) begin  // Use only the lower 5 bits
            for (i = 0; i < 31; i = i + 1) begin
                shifted[i] = shifted[i + 1];  // Shift bits right
            end
            shifted[31] = unshifted[31];  // Preserve the MSB (sign bit)
        end
    end
endmodule
