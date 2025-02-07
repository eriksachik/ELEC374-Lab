`timescale 1ns/10ps
module multiplier(
    input wire [31:0] Mplr, 
    input wire [31:0] Mcnd, 
    output reg [63:0] Y
);

    reg [63:0] accumulated;  // Store the accumulated result
    reg [63:0] Mcnd_SE;      // Sign-extended multiplicand
    reg [63:0] Mplr_SE;      // Sign-extended multiplier
    reg [33:0] booth;        // Booth's algorithm register

    integer i;

    always @(*) begin
        // Sign-extend Mplr and Mcnd to 64 bits
        Mplr_SE = { {32{Mplr[31]}} , Mplr };   
        Mcnd_SE = { {32{Mcnd[31]}} , Mcnd };  

        // Clear accumulated result
        accumulated = 64'd0;

        // Initialize the booth value with Mplr_SE and the extra bit
        booth = { Mplr_SE[31:0], 1'b0 };  // Booth is 33 bits

        // Perform Booth's multiplication
        for (i = 0; i < 32; i = i + 1) begin
            // Check the lower two bits of booth to decide on operation
            if (booth[1:0] == 2'b01) begin
                accumulated = accumulated + (Mcnd_SE << i); // Add shifted Mcnd
            end
            else if (booth[1:0] == 2'b10) begin
                accumulated = accumulated - (Mcnd_SE << i); // Subtract shifted Mcnd
            end

            // Arithmetic right shift booth by 1 (preserve sign)
            booth = {booth[33], booth[33:1]}; 
        end

        // Store the final result into Y
        Y = accumulated;
    end

endmodule
