`timescale 1ns/10ps 
module multiplier_tb;

    wire [63:0] Rz;
    reg [31:0] Ra;
    reg [31:0] Rb;
    
    // Instantiate the multiplier module
    multiplier MUL(.Mplr(Ra), .Mcnd(Rb), .Y(Rz));
    
    initial begin
        // Test case 1: Multiply by 0
        Ra = 32'hFFFFFFFF;  // Multiplier = -1
        Rb = 32'h00000000;  // Multiplicand = 0
        #20; // Expected Rz = 64'h0000000000000000
        
        // Test case 2: Multiply two random numbers
        Ra = 32'h0000FF00;  // Multiplier = 65280
        Rb = 32'h000FFF0F;  // Multiplicand = 1048583
        #20; // Expected Rz = 65280 * 1048583
        
        // Test case 3: Multiply a negative and a positive number
        Ra = 32'hFFFFFFFF;  // Multiplier = -1
        Rb = 32'h000FFF0F;  // Multiplicand = 1048583
        #20; // Expected Rz = -1048583 (64-bit negative result)
        
    end
endmodule



