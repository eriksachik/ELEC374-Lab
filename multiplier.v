`timescale 1ns/10ps

module multiplier(
    input  wire [31:0] Mplr, input  wire [31:0] Mcnd, output reg  [63:0] Y
);
    reg [33:0] booth; 
	 reg [63:0] accumulated;
    reg [63:0] Mcnd_SE;
    reg [63:0] Mplr_SE;
           

    integer i;

    always @(*) begin
        Mplr_SE = {{32{Mplr[31]}}, Mplr};
        Mcnd_SE    = {{32{Mcnd[31]}}, Mcnd};

        accumulated = 64'd0;

        // Initialize booth with the lower 32 bits of the multiplier plus an extra bit
        booth = { Mplr_SE[31:0], 1'b0 }; // 33 bits total

        // Perform Booth multiplication
        for (i = 0; i < 32; i = i + 1) begin
            case (booth[1:0])
                2'b01: accumulated = accumulated + (Mcnd_SE << i);
                2'b10: accumulated = accumulated - (Mcnd_SE << i);
                default: ;
            endcase
            // Arithmetic right shift the booth value by 1
            booth = { {1{booth[33]}}, booth[33:1] };
        end

        Y = accumulated;
    end

endmodule
