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
ArithmeticRightShift ars (.A(A), .B(B), .ALUOut(arith_right_shift_out));
LogicalRightShift lrs (.A(A), .B(B), .ALUOut(log_right_shift_out));
LeftShift ls (.A(A), .B(B), .ALUOut(left_shift_out));
Negate negate (.A(A), .ALUOut(neg_out));
Not not_gate (.A(A), .ALUOut(not_out));
Or or_gate (.A(A), .B(B), .ALUOut(or_out));
RotateLeft rl (.A(A), .B(B), .ALUOut(rotate_left_out));
RotateRight rr (.A(A), .B(B), .ALUOut(rotate_right_out));
Subtract subtract (.A(A), .B(B), .ALUOut(sub_out));
Adder adder (.A(A), .B(B), .ALUOut(add_out));
And and_gate (.A(A), .B(B), .ALUOut(and_out));

// Instantiate the 64-bit operations
Div_32 div_32 (.A(A), .B(B), .ALUOut(div_out));  // 64-bit result (quotient, remainder)
Multiplier mul (.A(A), .B(B), .ALUOut(mul_out)); // 64-bit result

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
