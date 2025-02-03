module RotateLeft(
    input [31:0] unrotated,
    output [31:0] rotated
);
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : rotate_left_loop
            assign rotated[i] = unrotated[i - 1];
        end
        assign rotated[0] = unrotated[31]; // The LSB gets the MSB
    endgenerate
endmodule
