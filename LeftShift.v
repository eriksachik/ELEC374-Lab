`timescale 1ns/10ps 
module LeftShift(
    input [31:0] unshifted,
    output [31:0] shifted
);
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : left_shift_loop
            assign shifted[i] = unshifted[i - 1];
        end
        assign shifted[0] = 0; // The LSB is set to 0
    endgenerate
endmodule
