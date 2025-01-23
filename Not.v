module not_gate(
    input [31:0] A,
    output reg [31:0] Y
);
    integer i;
    always @* begin
        for (i = 0; i < 32; i = i + 1) begin
            Y[i] = ~A[i]; // Bitwise NOT operation
        end
    end
endmodule