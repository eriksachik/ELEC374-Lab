`timescale 1ns/10ps 
module negate_tb(input a, output b);

    wire [31:0] Rz;
    reg [31:0] Ra;
    
    // Instantiate the Negate module
    Negate NEG(Ra, Rz);
    
    initial begin
        // Test case 1: A = 32'h00000000
        Ra = 32'h00000000;  // Expected output: 32'h00000000 (negation of 0 is 0)
        #20;
        
        // Test case 2: A = 32'h7FFFFFFF
        Ra = 32'h7FFFFFFF;  // Expected output: 32'h80000001 (negation of 0x7FFFFFFF)
        #20;
        
        // Test case 3: A = 32'hFFFFFFFF
        Ra = 32'hFFFFFFFF;  // Expected output: 32'h00000001 (negation of 0xFFFFFFFF)
        #20;
    end
endmodule
