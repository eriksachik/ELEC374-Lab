`timescale 1ns/10ps 
module ALU (
    input wire [31:0] A,               // First operand (32 bits)
    input wire [31:0] B,               // Second operand (32 bits)
    input wire [3:0] ALUControl,       // Control signal to select operation
    output reg [63:0] ALUOut,          // 64-bit output for multiplication/division
    output reg Zero                    // Zero flag
);

// Internal wires for 32-bit operations
wire [31:0] add_out, sub_out, and_out, or_out, not_out, neg_out;
wire [31:0] arith_right_shift_out, left_shift_out, log_right_shift_out;
wire [31:0] rotate_left_out, rotate_right_out;
wire [63:0] mul_out, div_out;   // 64-bit results for multiplication/division

// Instantiate the 32-bit operations
ArithmeticRightShift ars (.unshifted(A), .shifted(arith_right_shift_out));
LogicalRightShift lrs (.unshifted(A), .shifted(log_right_shift_out));
LeftShift ls (.unshifted(A), .shifted(left_shift_out));

Negate negate (.A(A), .C(neg_out));
not_gate Not (.A(A), .Y(not_out));
or_gate Or (.A(A), .B(B), .Y(or_out));
RotateLeft rl (.unrotated(A), .rotated(rotate_left_out));
RotateRight rr (.unrotated(A), .rotated(rotate_right_out));
Subtract subtract (.A(A), .B(B), .Result(sub_out));
adder Adder (.A(A), .B(B), .Result(add_out));
and_gate AND  (.A(A), .B(B), .Y(and_out));

// Instantiate the 64-bit operations
div_32 Div_32 (.a_dividend(A), .b_divisor(B), .c_quotient_and_remainder(div_out));  // 64-bit result (quotient, remainder)
multiplier mul (.Mplr(A), .Mcnd(B), .Y(mul_out)); // 64-bit result

// ALU control logic to select the operation
always @(*) begin
    case(ALUControl)
        4'b0000: ALUOut = add_out;                // Add
        4'b0001: ALUOut = sub_out;                // Subtract
        4'b0010: ALUOut = and_out;                // AND
        4'b0011: ALUOut = or_out;                 // OR
        4'b0100: ALUOut = neg_out;                // Negate
        4'b0101: ALUOut = not_out;                // NOT
        4'b0110: ALUOut = arith_right_shift_out;  // Arithmetic Right Shift
        4'b0111: ALUOut = mul_out;                // Multiply (64 bits)
        4'b1000: ALUOut = left_shift_out;         // Left Shift
        4'b1001: ALUOut = log_right_shift_out;    // Logical Right Shift
        4'b1010: ALUOut = div_out;                // Division (64 bits)
        4'b1011: ALUOut = rotate_left_out;        // Rotate Left
        4'b1100: ALUOut = rotate_right_out;       // Rotate Right
        default: ALUOut = 64'b0;                  // Default case (just in case)
    endcase

    // Set the Zero flag (for 32-bit operations, could be modified for 64-bit)
    Zero = (ALUOut == 64'b0) ? 1'b1 : 1'b0;
end

endmodule
