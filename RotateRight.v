module RotateRight(
    input [31:0] unrotated,
    output [31:0] rotated
);
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : rotate_right_loop
            assign rotated[i] = unrotated[i + 1];
        end
        assign rotated[31] = unrotated[0]; // The MSB gets the LSB
    endgenerate
endmodule
