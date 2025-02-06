`timescale 1ns/10ps
module multiplier (
    input clk,
    input reset,
    input [31:0] Mplr,   // Multiplier
    input [31:0] Mcnd,   // Multiplicand
    output reg [63:0] Y   // Product (64-bit result)
);

    reg [63:0] partial_sum;
    reg [63:0] temp;
    reg [2:0] booth_code;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Y <= 64'b0;           // Reset the output product to 0
            partial_sum <= 64'b0; // Reset partial sum
        end else begin
            partial_sum <= 64'b0; // Clear partial sum at the beginning of each clock cycle
            
            for (i = 0; i < 32; i = i + 2) begin
                booth_code = {Mplr[i + 1], Mplr[i], (i == 0 ? 1'b0 : Mplr[i - 1])};
                
                // Booth's multiplication algorithm
                case (booth_code)
                    3'b001, 3'b010: temp = Mcnd << i;                // Shift left
                    3'b011: temp = Mcnd << (i + 1);                   // Double shift left
                    3'b100: temp = (~(Mcnd << (i + 1))) + 1;         // Negate and shift
                    3'b101, 3'b110: temp = ~(Mcnd << i) + 1;         // Negate and shift
                    default: temp = 64'b0;                             // Default case for no operation
                endcase
                
                // Accumulate partial product
                partial_sum = partial_sum + temp;
            end

            // Store the final product in Y
            Y <= partial_sum;
        end
    end
endmodule
