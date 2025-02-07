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
        B = 32'h00000000; // B is not used in this operat
