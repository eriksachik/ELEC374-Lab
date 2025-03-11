`timescale 1ns/10ps
module CON_FF (
    input [3:0] IR,      // Instruction Register bits 22-19
    input signed [31:0] R, // Register R[Ra] value (signed for handling negative)
    input CONin,           // Enable signal from Control Unit
    output reg CON        // Conditional flag for branch
);

    // Always block to evaluate the condition based on IR[22:19] and R[Ra]
    always @(*) begin
        if (CONin) begin
            case (IR) // Check the C2 field (4 bits)
                4'b0000: CON = (R == 32'b0);   // brzr: branch if zero
                4'b0001: CON = (R != 32'b0);   // brnz: branch if non-zero
                4'b0010: CON = (R[31] == 1'b0); // brpl: branch if positive (R > 0)
                4'b0011: CON = (R[31] == 1'b1); // brmi: branch if negative (R < 0)
                default: CON = 1'b0; // No branch for other values (default)
            endcase
        end else begin
            CON = 1'b0; // If CONin is not enabled, no branch
        end
    end

endmodule
