`timescale 1ns/10ps 
module subtract_tb(input [31:0] A, input [31:0] B, output [31:0] Result);

    wire [31:0] Rz;
    reg [31:0] Ra, Rb;
    
    // Instantiate the Subtract module
    Subtract sub(Ra, Rb, Rz);
    
    initial begin
        // Test case 1: A = 32'h00000010, B = 32'h00000005
        Ra = 32'h00000010;  // Expected Result = 32'h00000005 (16 - 5)
        Rb = 32'h00000005;
        #20;
        
        // Test case 2: A = 32'hFFFFFFFF, B = 32'h00000001
        Ra = 32'hFFFFFFFF;  // Expected Result = 32'hFFFFFFFE (-1 - 1)
        Rb = 32'h00000001;
        #20;
        
        // Test case 3: A = 32'h12345678, B = 32'h87654321
        Ra = 32'h12345678;  // Expected Result = 32'h8FABCDEF (0x12345678 - 0x87654321)
        Rb = 32'h87654321;
        #20;
    end
endmodule
