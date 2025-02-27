`timescale 1ns/10ps 
module MDR(
    input wire clk,
    input wire clr,
    input wire [31:0] BusMuxOut,    // Data from the bus
    input wire [31:0] MdataIn,      // Data from memory
    input wire MDRin,                // Enable signal for writing data to MDR
    input wire Read,                 // Read control signal for selecting input source
    output reg [31:0] MDROut        // Output from MDR
);
    always @(negedge clk or posedge clr) begin
        if (clr) begin
            MDROut <= 32'b0;  // Reset MDR to zero
        end else if (MDRin) begin
            // Select input based on the Read signal (0 = BusMuxOut, 1 = MdataIn)
            MDROut <= (Read) ? MdataIn : BusMuxOut;
        end
    end
endmodule
