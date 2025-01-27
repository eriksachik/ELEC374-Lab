module ArithmeticRightShift(
    input [31:0] unshifted,
    output [31:0] shifted
);
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : arithmetic_right_shift_loop
            assign shifted[i] = unshifted[i + 1];
        end
        assign shifted[31] = unshifted[31]; // MSB retains the original sign bit
    endgenerate
endmodule
