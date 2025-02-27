`timescale 1ns/10ps 
module rotate_right_tb(input [31:0] unrotated, output [31:0] rotated);

    wire [31:0] Rz;
    reg [31:0] Ra;
    
    // Instantiate the RotateRight module
    RotateRight ROT(Ra, Rz);
    
    initial begin
        // Test case 1: unrotated = 32'h00000001
        Ra = 32'h00000001;  // Expected rotated result: 32'h80000000
        #20;
        
        // Test case 2: unrotated = 32'h80000000
        Ra = 32'h80000000;  // Expected rotated result: 32'h40000000
        #20;
        
        // Test case 3: unrotated = 32'h12345678
        Ra = 32'h12345678;  // Expected rotated result: 32'h091A2B3C
        #20;
    end
endmodule
