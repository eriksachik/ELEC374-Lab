module Subtract(A, B, Result);
    input [31:0] A, B;
    output reg [31:0] Result; // Make Result 'reg' directly in the output

    reg [32:0] Borrow;  // Extra bit for final borrow

    integer i;

    always @(*) 
    begin
        Borrow = 33'd0; // Initialize borrow chain
        for (i = 0; i < 32; i = i + 1)
        begin
            Result[i] = A[i] ^ B[i] ^ Borrow[i];  // Difference bit
            Borrow[i+1] = (~A[i] & B[i]) | (Borrow[i] & (~(A[i] ^ B[i]))); 
        end
    end
endmodule

