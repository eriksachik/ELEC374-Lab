`timescale 1ns/10ps 
module RotateRight(
    input [31:0] unrotated,
    input [31:0] rotateBy,  // Full 32-bit input, but only the lower 5 bits are used
    output reg [31:0] rotated
);
    integer i, j;
    
    always @(*) begin
        rotated = unrotated;  // Initialize with the original value
        for (j = 0; j < rotateBy[4:0]; j = j + 1) begin  // Use only the lower 5 bits
            for (i = 0; i < 31; i = i + 1) begin
                rotated[i] = rotated[i + 1];  // Shift bits right
            end
            rotated[31] = rotated[0];  // Wrap LSB to MSB (rotation)
        end
    end
endmodule
