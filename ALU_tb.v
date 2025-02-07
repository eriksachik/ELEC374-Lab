`timescale 1ns/10ps
module ALU_tb;

    // Declare testbench variables
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALUControl;
    wire [63:0] ALUOut;
    wire Zero;

    // Instantiate the ALU
    ALU uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUOut(ALUOut),
        .Zero(Zero)
    );

    initial begin
        // Test 1: Addition
        A = 32'h00000005; 
        B = 32'h00000003;
        ALUControl = 4'b0000; // Add operation
        #20;
        
        // Test 2: Subtraction
        A = 32'h00000005;
        B = 32'h00000003;
        ALUControl = 4'b0001; // Subtract operation
        #20;

        // Test 3: AND operation
        A = 32'h00000005;
        B = 32'h00000003;
        ALUControl = 4'b0010; // AND operation
        #20;

        // Test 4: OR operation
        A = 32'h00000005;
        B = 32'h00000003;
        ALUControl = 4'b0011; // OR operation
        #20;

        // Test 5: Negate operation
        A = 32'h00000005;
        B = 32'h00000000; // B is not used in this operation
        ALUControl = 4'b0100; // Negate operation
        #20;

        // Test 6: NOT operation
        A = 32'h00000005;
        B = 32'h00000000; // B is not used in this operation
        ALUControl = 4'b0101; // NOT operation
        #20;

        // Test 7: Arithmetic Right Shift
        A = 32'h00000005;
        B = 32'h00000000; // B is not used in this operation
        ALUControl = 4'b0110; // Arithmetic Right Shift operation
        #20;

        // Test 8: Multiply operation
        A = 32'h00000005;
        B = 32'h00000003;
        ALUControl = 4'b0111; // Multiply operation
        #20;

        // Test 9: Left Shift
        A = 32'h00000005;
        B = 32'h00000000; // B is not used in this operation
        ALUControl = 4'b1000; // Left Shift operation
        #20;

        // Test 10: Logical Right Shift
        A = 32'h00000005;
        B = 32'h00000000; // B is not used in this operation
        ALUControl = 4'b1001; // Logical Right Shift operation
        #20;

        // Test 11: Division
        A = 32'h0000000A;
        B = 32'h00000002;
        ALUControl = 4'b1010; // Division operation
        #20;

        // Test 12: Rotate Left
        A = 32'h00000005;
        B = 32'h00000000; // B is not used in this operation
        ALUControl = 4'b1011; // Rotate Left operation
        #20;

        // Test 13: Rotate Right
        A = 32'h00000005;
        B = 32'h00000000; // B is not used in this operation
        ALUControl = 4'b1100; // Rotate Right operation
        #20;
        
        // Test finish
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("A = %h, B = %h, ALUControl = %b, ALUOut = %h, Zero = %b", A, B, ALUControl, ALUOut, Zero);
    end

endmodule
