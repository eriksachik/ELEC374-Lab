`timescale 1ns/10ps
module multiplier_tb;

    reg clk;                   // Clock signal
    reg reset;                 // Reset signal
    reg [31:0] Mplr, Mcnd;     // Multiplier and multiplicand inputs
    wire [63:0] Y;             // 64-bit product output

    // Instantiate the multiplier module
    multiplier uut (
        .clk(clk),
        .reset(reset),
        .Mplr(Mplr),
        .Mcnd(Mcnd),
        .Y(Y)
    );

    // Clock generation
    always #5 clk = ~clk;  // Toggle clock every 5 ns, 10 ns period

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        Mplr = 32'd0;
        Mcnd = 32'd0;

        // Reset the multiplier
        #10 reset = 0;  // Deassert reset

        // Test case 1: Multiply 2 positive numbers
        Mplr = 32'd15;
        Mcnd = 32'd10;
        #20;  // Wait for 20 ns

        // Test case 2: Multiply a positive and a negative number
        Mplr = 32'd15;
        Mcnd = 32'd-10;
        #20;  // Wait for 20 ns

        // Test case 3: Multiply 2 negative numbers
        Mplr = 32'd-15;
        Mcnd = 32'd-10;
        #20;  // Wait for 20 ns

        // Test case 4: Multiply by zero
        Mplr = 32'd0;
        Mcnd = 32'd10;
        #20;  // Wait for 20 ns

        // Finish simulation
        $finish;
    end
endmodule
