`timescale 1ns/10ps
module multiplier_tb;

    // Testbench variables
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg reset;
    wire [63:0] PRODUCT;

    // Instantiate the multiplier
    booth_multiplier uut (
        .A(A),
        .B(B),
        .PRODUCT(PRODUCT),
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100 MHz clock
    end

    initial begin
        // Test initialization
        reset = 1;
        clk = 0;
        A = 32'h00000002;
        B = 32'h00000003;
        #10;
        reset = 0;  // Deassert reset

        // Test case 1: Multiply two numbers
        A = 32'h00000002;
        B = 32'h00000003;
        #40;  // Wait for some cycles

        // Test case 2: Multiply with a negative number
        A = 32'hFFFFFFFE;  // -2
        B = 32'h00000003;  // 3
        #40;

        // Test case 3: Multiply by zero
        A = 32'h00000000;
        B = 32'h00000000;
        #40;

        // Test case 4: Multiply by a large number
        A = 32'hFFFFFFFF;  // -1
        B = 32'h00000003;  // 3
        #40;

        // Test finish
        $finish;
    end

    // Monitor the PRODUCT signal during simulation
    initial begin
        $monitor("A = %h, B = %h, PRODUCT = %h", A, B, PRODUCT);
    end

endmodule
