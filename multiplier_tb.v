`timescale 1ns/10ps 
module multiplier_tb;

    wire [63:0] Rz;
    reg [31:0] Ra;
    reg [31:0] Rb;
    reg clk, reset;
    
    // Instantiate the multiplier module
    multiplier MUL(.Mplr(Ra), .Mcnd(Rb), .Y(Rz));
    
    // Generate clock signal
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        Ra = 32'b0;
        Rb = 32'b0;

        // Apply reset
        #10;
        reset = 0;
        
        // Monitor Rz value
        $monitor("At time %t, Rz = %h", $time, Rz);


        // Test case 2: Multiply two random numbers
        Ra = 32'h0000FF00;  // Multiplier = 65280
        Rb = 32'h000FFF0F;  // Multiplicand = 1048583
        #20; // Expected Rz = 65280 * 1048583
        
        // Test case 3: Multiply a negative and a positive number
        Ra = 32'hFFFFFFFF;  // Multiplier = -1
        Rb = 32'h000FFF0F;  // Multiplicand = 1048583
        #20; // Expected Rz = -1048583 (64-bit negative result)
        
        $finish; // End simulation
    end
endmodule
