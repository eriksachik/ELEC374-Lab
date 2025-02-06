`timescale 1ns/10ps
module multiplier_tb (input a  output b;

  
    reg [31:0] Ra, Rb;     // Multiplier and multiplicand inputs
    wire [63:0] Rz;             // 64-bit product output
    multiplier MULT(Ra, Rb, Rz);
    
    initial begin
        
        Ra = 32'h0000000F;  // 15 in hex
        Rb = 32'h0000000A;  // 10 in hex
        #20;  // Wait for 20 ns

        // Test case 2: Multiply a positive and a negative number
        Ra = 32'h0000000F;  // 15 in hex
        Rb = 32'hFFFFFFF6;  // -10 in hex (2's complement)
        #20;  // Wait for 20 ns

        // Test case 3: Multiply 2 negative numbers
        Ra = 32'hFFFFFFF1;  // -15 in hex (2's complement)
        Rb = 32'hFFFFFFF6;  // -10 in hex (2's complement)
        #20;  // Wait for 20 ns

        // Test case 4: Multiply by zero
        Ra = 32'h00000000;  // 0 in hex
        Rb = 32'h0000000A;  // 10 in hex
        #20;  // Wait for 20 ns

    
    end
endmodule

