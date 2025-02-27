`timescale 1ns/10ps
module multiplier(
    input wire [31:0] Mplr,    // Multiplier
    input wire [31:0] Mcnd,    // Multiplicand
    output reg [63:0] Y        // 64-bit Product
);

    reg [63:0] accumulated;        // Store the accumulated result
    reg [63:0] Mcnd_SE;           // Sign-extended multiplicand
    reg [63:0] Mplr_SE;           // Sign-extended multiplier
    reg [33:0] booth;             // Booth's algorithm register (33 bits)

    integer i;

    always @(*) begin
        // Sign-extend Mplr and Mcnd to 64 bits
        Mplr_SE = { {32{Mplr[31]}} , Mplr };  // Sign extend multiplier to 64-bits
        Mcnd_SE = { {32{Mcnd[31]}} , Mcnd };  // Sign extend multiplicand to 64-bits

        accumulated = 64'd0;           // Clear accumulated result

        // Initialize the booth value with Mplr_SE and the extra bit
        booth = { Mplr_SE[31:0], 1'b0 }; // Booth is 33 bits, initialize with multiplier and an extra 0

        // Perform Booth's multiplication
        for (i = 0; i < 32; i = i + 2) begin  // Loop over pairs of bits
            case (booth[2:0])  // Check the lower three bits for Booth encoding
                3'b001, 3'b010: // + Mcnd (Add Mcnd shifted by i)
                    accumulated = accumulated + (Mcnd_SE << i);
                3'b011: // + 2*Mcnd (Add Mcnd shifted by i+1)
                    accumulated = accumulated + (Mcnd_SE << (i + 1));
                3'b100: // -2*Mcnd (Subtract Mcnd shifted by i+1)
                    accumulated = accumulated - (Mcnd_SE << (i + 1));
                3'b101, 3'b110: // - Mcnd (Subtract Mcnd shifted by i)
                    accumulated = accumulated - (Mcnd_SE << i);
                default: // 000 or 111 → No operation
                    accumulated = accumulated;
            endcase

            // Arithmetic right shift booth by 2 (preserve sign)
            booth = {booth[33], booth[33], booth[33:2]}; // Maintain sign for shifts
        end

        // Store the final result into Y
        Y = accumulated;
    end

endmodule
