`timescale 1ns/10ps
module MAR_tb;

    wire [8:0] address;    // Address output from MAR
    reg clk, clr, Rin;     // Clock, Clear, and Rin control signals
    reg [31:0] dIn;        // 32-bit data input to MAR

    // Instantiate the MAR module
    MAR #(9'b0) mar (
        .clk(clk),
        .clr(clr),
        .dIn(dIn),
        .Rin(Rin),
        .address(address)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        clr = 1;
        Rin = 0;
        dIn = 32'b0;

        // Test case 1: Reset the MAR (clr = 0)
        #10;
        clr = 0;   // Assert reset
        #10;
        clr = 1;   // Deassert reset, address should be reset to VAL (default 0)

        // Test case 2: Enable the register (Rin = 1) and load a value into address
        Rin = 1;   
        dIn = 32'hFFFFF123;  // Load the lower 9 bits (0x123) into address
        #10;  // Expected address = 9'b000100100011

        // Test case 3: Disable the register (Rin = 0), value should not change
        Rin = 0;
        dIn = 32'h0FFFFFFF;  // Set new value, but it should not change due to Rin = 0
        #10;  // Expected address = 9'b000100100011 (unchanged)

        // End simulation
        $finish;
    end
endmodule
