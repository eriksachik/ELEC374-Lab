`timescale 1ns/10ps

module negate_tb;

    reg [31:0] A;  // 32-bit input
    wire [31:0] C; // 32-bit output

    // Instantiate the Negate module
    Negate negate_instance (
        .A(A),
        .C(C)
    );

    initial begin
        // Test case 1: A = 0
        A = 32'h00000000;  // Expected C = 32'h00000000 (negation of 0 is 0)
        #20;

        // Test case 2: A = 32'h7FFFFFFF (largest positive 32-bit value)
        A = 32'h7FFFFFFF;  // Expected C = 32'h80000001 (negation of 0x7FFFFFFF)
        #20;

        // Test case 3: A = 32'hFFFFFFFF (largest negative 32-bit value)
        A = 32'hFFFFFFFF;  // Expected C = 32'h00000001 (negation of 0xFFFFFFFF)
        #20;

        // Test case 4: A = 32'h00000001 (positive number)
        A = 32'h00000001;  // Expected C = 32'hFFFFFFFE (negation of 1)
        #20;

        // Test case 5: A = 32'h80000000 (most negative 32-bit number)
        A = 32'h80000000;  // Expected C = 32'h7FFFFFFF (negation of 0x80000000)
        #20;

        // Test case 6: A = 32'h12345678 (random positive number)
        A = 32'h12345678;  // Expected C = 32'hEDCBA987 (negation of 0x12345678)
        #20;
        
        // Test case 7: A = 32'h87654321 (random positive number)
        A = 32'h87654321;  // Expected C = 32'h789ACDEF (negation of 0x87654321)
        #20;
        
        // Test case 8: A = 32'h000000FF (another random number)
        A = 32'h000000FF;  // Expected C = 32'hFFFFFF01 (negation of 0x000000FF)
        #20;
        
        // Test case 9: A = 32'h80000001 (negative number)
        A = 32'h80000001;  // Expected C = 32'h7FFFFFFE (negation of 0x80000001)
        #20;

        // End the simulation
        $finish;
    end
endmodule
