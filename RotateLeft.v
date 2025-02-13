`timescale 1ns/10ps 
module RotateLeft(
    input [31:0] unrotated,
    input [31:0] rotateBy,  // Full 32-bit input, but only the lower 5 bits are used
    output reg [31:0] rotated
);
    integer i, j;
    
    always @(*) begin
        rotated = unrotated;  // Initialize with the original value
        for (j = 0; j < rotateBy[4:0]; j = j + 1) begin  // Use only the lower 5 bits
            for (i = 31; i > 0; i = i - 1) begin
                rotated[i] = rotated[i - 1];  // Shift bits left
            end
            rotated[0] = rotated[31];  // Wrap MSB to LSB (rotation)
        end
    end
endmodule
