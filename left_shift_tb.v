`timescale 1ns/10ps 
module left_shift_tb(input [31:0] unshifted, output [31:0] shifted);

    wire [31:0] Rz;
    reg [31:0] Ra;
    
    // Instantiate the LeftShift module
    LeftShift LS(Ra, Rz);
    
    initial begin
        // Test case 1: unshifted = 32'h00000001
        Ra = 32'h00000001;  // Expected shifted result: 32'h00000002
        #20;
        
        // Test case 2: unshifted = 32'h80000000
        Ra = 32'h80000000;  // Expected shifted result: 32'h00000000
        #20;
        
        // Test case 3: unshifted = 32'h12345678
        Ra = 32'h12345678;  // Expected shifted result: 32'h23456780
        #20;
    end
endmodule
