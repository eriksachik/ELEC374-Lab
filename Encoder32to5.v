`timescale 1ns/10ps
module Encoder32to5( 
    input wire [31:0] DataIn, // One-hot encoded inputs from control signals
    output reg [4:0] select   // 5-bit output for selecting the appropriate register
);

    always @(*) begin
        case (DataIn)
            32'h00000001: select = 5'd0;   // R0out
            32'h00000002: select = 5'd1;   // R1out
            32'h00000004: select = 5'd2;   // R2out
            32'h00000008: select = 5'd3;   // R3out
            32'h00000010: select = 5'd4;   // R4out
            32'h00000020: select = 5'd5;   // R5out
            32'h00000040: select = 5'd6;   // R6out
            32'h00000080: select = 5'd7;   // R7out
            32'h00000100: select = 5'd8;   // R8out
            32'h00000200: select = 5'd9;   // R9out
            32'h00000400: select = 5'd10;  // R10out
            32'h00000800: select = 5'd11;  // R11out
            32'h00001000: select = 5'd12;  // R12out
            32'h00002000: select = 5'd13;  // R13out
            32'h00004000: select = 5'd14;  // R14out
            32'h00008000: select = 5'd15;  // R15out
            32'h00010000: select = 5'd16;  // HIout
            32'h00020000: select = 5'd17;  // LOout
            32'h00040000: select = 5'd18;  // Zhighout
            32'h00080000: select = 5'd19;  // Zlowout
            32'h00100000: select = 5'd20;  // PCout
            32'h00200000: select = 5'd21;  // MDRout
            32'h00400000: select = 5'd22;  // In.Portout
            32'h00800000: select = 5'd23;  // Cout
            default: select = 5'd31;       // Default (safe fallback)
        endcase
    end

endmodule
