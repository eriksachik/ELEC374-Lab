`timescale 1ns/10ps 
module and_gate(
    input [31:0] A, B,
    output [31:0] Y
);
    genvar i;
    generate
	    for (i = 0; i < 32; i = i + 1) begin : and_loop
		assign Y[i] = A[i] & B[i]; // Bitwise and operation
        end
    endgenerate
endmodule
