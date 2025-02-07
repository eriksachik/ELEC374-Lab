`timescale 1ns/10ps

module datapath_tb;

    // Declare testbench variables
    reg clock;
    reg clear;
    reg [31:0] instruction;
    reg [31:0] A;
    reg [31:0] B;
    reg RZout, RAout, RBout;
    reg RAin, RBin, RZin;
    reg [3:0] ALUControl;
    reg IncPC;
    wire [31:0] PC;
    wire [63:0] Z;
    wire [31:0] HI;
    wire [31:0] LO;
    wire Zero;

    // Instantiate the DataPath module
    DataPath uut (
        .clock(clock),
        .clear(clear),
        .instruction(instruction),
        .A(A),
        .B(B),
        .RZout(RZout),
        .RAout(RAout),
        .RBout(RBout),
        .RAin(RAin),
        .RBin(RBin),
        .RZin(RZin),
        .ALUControl(ALUControl),
        .IncPC(IncPC),
        .PC(PC),
        .Z(Z),
        .HI(HI),
        .LO(LO),
        .Zero(Zero)
    );

    // Generate clock signal
    always begin
        #10 clock = ~clock;  // Toggle clock every 10ns
    end

    initial begin
        // Initialize all signals
        clock = 0;
        clear = 0;
        instruction = 32'h00000000;
        A = 32'h00000000;
        B = 32'h00000000;
        RZout = 0;
        RAout = 0;
        RBout = 0;
        RAin = 0;
        RBin = 0;
        RZin = 0;
        ALUControl = 4'b0000;  // Add operation
        IncPC = 0;

        // Apply reset
        clear = 1;
        #20;
        clear = 0;

        // Test 1: Test ALU Add operation
        A = 32'h00000005;
        B = 32'h00000003;
        ALUControl = 4'b0000;  // Add operation
        #20;

        // Test 2: Test ALU Subtract operation
        A = 32'h00000005;
        B = 32'h00000003;
        ALUControl = 4'b0001;  // Subtract operation
        #20;

        // Test 3: Test ALU AND operation
        A = 32'h00000005;
        B = 32'h00000003;
        ALUControl = 4'b0010;  // AND operation
        #20;

        // Test 4: Test ALU OR operation
        A = 32'h00000005;
        B = 32'h00000003;
        ALUControl = 4'b0011;  // OR operation
        #20;

        // Test 5: Test ALU Negate operation
        A = 32'h00000005;
        B = 32'h00000000;  // B is not used for this operation
        ALUControl = 4'b0100;  // Negate operation
        #20;

        // Test 6: Test ALU NOT operation
        A = 32'h00000005;
        B = 32'h00000000;  // B is not used for this operation
        ALUControl = 4'b0101;  // NOT operation
        #20;

        // Test 7: Test ALU Arithmetic Right Shift operation
        A = 32'h00000005;
        B = 32'h00000000;  // B is not used for this operation
        ALUControl = 4'b0110;  // Arithmetic Right Shift operation
        #20;

        // Test 8: Test ALU Multiply operation
        A = 32'h00000005;
        B = 32'h00000003;
        ALUControl = 4'b0111;  // Multiply operation
        #20;

        // Test 9: Test ALU Left Shift operation
        A = 32'h00000005;
        B = 32'h00000000;  // B is not used for this operation
        ALUControl = 4'b1000;  // Left Shift operation
        #20;

        // Test 10: Test ALU Logical Right Shift operation
        A = 32'h00000005;
        B = 32'h00000000;  // B is not used for this operation
        ALUControl = 4'b1001;  // Logical Right Shift operation
        #20;

        // Test 11: Test ALU Division operation
        A = 32'h0000000A;
        B = 32'h00000002;
        ALUControl = 4'b1010;  // Division operation
        #20;

        // Test 12: Test ALU Rotate Left operation
        A = 32'h00000005;
        B = 32'h00000000;  // B is not used for this operation
        ALUControl = 4'b1011;  // Rotate Left operation
        #20;

        // Test 13: Test ALU Rotate Right operation
        A = 32'h00000005;
        B = 32'h00000000;  // B is not used for this operation
        ALUControl = 4'b1100;  // Rotate Right operation
        #20;

        // Test finish
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("PC = %h, ALUOut = %h, Z = %h, HI = %h, LO = %h, Zero = %b", PC, ALUOut, Z, HI, LO, Zero);
    end

endmodule
