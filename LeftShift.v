`timescale 1ns/10ps 
module LeftShift(
    input [31:0] unshifted,
    input [31:0] shiftBy,  // Only 5 bits needed for shifts (0 to 31)
    output reg [31:0] shifted
);
    integer i, j;
	
    always @(*) begin
        shifted = unshifted;  // Initialize with the original value
        for (j = 0; j < shiftBy[4:0]; j = j + 1) begin
            for (i = 31; i > 0; i = i - 1) begin
                shifted[i] = shifted[i - 1];  // Shift bits left
            end
            shifted[0] = 0;  // Set the least significant bit (LSB) to 0
        end
    end
	 
endmodule
