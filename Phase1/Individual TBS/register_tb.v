`timescale 1ns/10ps 
module register_tb;

    wire [31:0] BusMuxIn;
    reg clear, clock, enable;
    reg [31:0] BusMuxOut;

    // Instantiate the register module
    register #(32, 32) reg1(
        .clear(clear),
        .clock(clock),
        .enable(enable),
        .BusMuxOut(BusMuxOut),
        .BusMuxIn(BusMuxIn)
    );

    // Generate clock signal
    always #5 clock = ~clock;
    
    initial begin
        // Initialize signals
        clock = 0;
        clear = 1;
        enable = 0;
        BusMuxOut = 32'b0;

        // Test case 1: Reset the register (clear = 1)
        #10; // After 10ns, apply reset
        clear = 0; // Deassert reset
        
        // Test case 2: Enable register with a value
        enable = 1;
        BusMuxOut = 32'hA5A5A5A5; // Set input to a non-zero value
        #10; // Wait for 10ns, expect BusMuxIn = 0xA5A5A5A5

        // Test case 3: Disable register and change value, ensure no change
        enable = 0;
        BusMuxOut = 32'h5A5A5A5A; // Set new value, but register should not change
        #10; // Wait for 10ns, expect BusMuxIn = 0xA5A5A5A5 (unchanged)

        // End simulation

    end
endmodule
