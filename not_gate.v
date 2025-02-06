`timescale 1ns/10ps 
module not_gate(
    input [31:0] A,
    output reg [31:0] Y
);
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: loop
            assign Y[i] = !A[i]; // Bitwise NOT operation
        end
    endgenerate
endmodule
