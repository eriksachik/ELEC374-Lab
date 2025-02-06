`timescale 1ns/10ps
module Subtract(
    input [31:0] A, B,
    output reg [31:0] Result
);

    reg [32:0] Borrow;  // Extra bit for final borrow (carry-out)
    integer i;

    always @(*) begin
        Borrow = 33'd0; // Initialize borrow chain to 0
        for (i = 0; i < 32; i = i + 1) begin
            // Calculate result[i] using XOR for difference and the borrow
            Result[i] = A[i] ^ B[i] ^ Borrow[i];
            
            // Calculate the borrow: if A[i] < B[i] or there's an existing borrow
            Borrow[i+1] = (~A[i] & B[i]) | (Borrow[i] & (~(A[i] ^ B[i])));
        end
    end
endmodule
