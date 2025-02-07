`timescale 1ns/10ps
module datapath_tb;

// Declare testbench variables
reg Pcout, Zlowout, MDRout, R3out, R7out, MARin, Zin;
reg PCin, MDRin, R3in, R4in, R7in, Yin, Read, AND;
reg [31:0] instruction;  // This is where you set the instruction (opcode)
reg clock, clear;
reg IncPC; // Control signal for Incrementing PC

// Declare the control and output signals required for the simulation
wire [31:0] PC;
wire [63:0] Z;
wire [31:0] HI;
wire [31:0] LO;
wire Zero;

datapath DUT(
    .Pcout(Pcout), .Zlowout(Zlowout), .MDRout(MDRout), .R3out(R3out), .R7out(R7out),
    .MARin(MARin), .Zin(Zin), .PCin(PCin), .MDRin(MDRin), .R3in(R3in), .R4in(R4in),
    .R7in(R7in), .Yin(Yin), .Read(Read), .AND(AND),
    .instruction(instruction), .clock(clock), .clear(clear),
    .PC(PC), .Z(Z), .HI(HI), .LO(LO), .Zero(Zero)
);

// Clock generation
initial begin
    clock = 0;
    forever #10 clock = ~clock; // 50 MHz clock
end

// Test procedure
initial begin
    // Initialize all control signals
    clear = 1;
    Pcout = 0; Zlowout = 0; MDRout = 0; R3out = 0; R7out = 0; MARin = 0; Zin = 0;
    PCin = 0; MDRin = 0; R3in = 0; R4in = 0; R7in = 0; Yin = 0; Read = 0; AND = 0;
    instruction = 32'hA2B80000; // 32-bit AND opcode (for R4, R3, R7)

    // Step 1: Reset the Datapath
    clear = 1; #20;
    clear = 0; #20;

    // Step 2: Simulate control sequence for "and" operation (R4, R3, R7)
    // T0: Fetch instruction
    Pcout = 1; MARin = 1; IncPC = 1; Zin = 1; #20;

    // T1: Read instruction, load into MDR and IR
    Zlowout = 1; PCin = 1; Read = 1; MDRin = 1; #20;

    // T2: Store instruction in IR
    MDRout = 1; #20;

    // T3: Load R3 with value
    R3out = 1; Yin = 1; #20;

    // T4: Perform AND operation with R7
    R7out = 1; AND = 1; Zin = 1; #20;

    // T5: Store result in R4
    Zlowout = 1; R4in = 1; #20;

    // Finish test
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time = %0t, instruction = %h, PC = %h, Z = %h, HI = %h, LO = %h, Zero = %b",
             $time, instruction, PC, Z, HI, LO, Zero);
end

endmodule
