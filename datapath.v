`timescale 1ns/10ps
module datapath(
    input wire clock, 
    input wire clear, 
    input wire [31:0] instruction,  // Instruction input (IR)
    input wire [31:0] A,  // ALU input A
    input wire [31:0] B,  // ALU input B
    input wire RZout, RAout, RBout,  // Control signals for output of registers
    input wire RAin, RBin, RZin,     // Control signals for input to registers
    input wire [3:0] ALUControl,    // Control signals for ALU operation
    input wire IncPC,  // Increment PC control signal
    output wire [31:0] PC,  // Program counter
    output wire [63:0] Z,   // ALU output (64-bit result now for Z)
    output wire [31:0] HI,  // HI register (for multiplication)
    output wire [31:0] LO,  // LO register (for multiplication)
    output wire Zero       // Zero flag from ALU
);

// Internal wires for BusMux
wire [31:0] BusMuxOut, BusMuxInRZ, BusMuxInRA, BusMuxInRB, ALUOut, TempPC;
wire [63:0] ALUOut64; // 64-bit output for multiplication/division
wire [63:0] Zregin;  // 64-bit temporary register to hold ALU result before Z
wire [31:0] MDR;    // Memory Data Register (for storing memory results)
wire [4:0] BusMuxControl; // BusMux control signals from Encoder

// General-purpose Registers R0 to R15
wire [31:0] R0Out, R1Out, R2Out, R3Out, R4Out, R5Out, R6Out, R7Out;
wire [31:0] R8Out, R9Out, R10Out, R11Out, R12Out, R13Out, R14Out, R15Out;

// Registers (R0 to R15, HI, LO, etc.)
register register_PC(clear, clock, IncPC, TempPC, PC);  // Program Counter Register
register register_IR(clear, clock, 1'b1, instruction, BusMuxInRA);  // Instruction Register (IR)

// MAR and MDR Modules
MAR mar(clear, clock, BusMuxOut, 1'b1, BusMuxInRA);  // Memory Address Register (MAR)
MDR mdr(clear, clock, 1'b1, BusMuxOut, MDR);  // Memory Data Register (MDR)

// Register for HI and LO (used in multiplication/division)
register register_HI(clear, clock, 1'b1, BusMuxOut, HI);  // HI Register (for multiplication)
register register_LO(clear, clock, 1'b1, BusMuxOut, LO);  // LO Register (for multiplication)
register register_RA(clear, clock, RAin, A, BusMuxInRA);  // Register A
register register_RB(clear, clock, RBin, B, BusMuxInRB);  // Register B

// 64-bit Register for Z
register64 register_Z(clear, clock, RZin, ALUOut64, Z);  // 64-bit Register for Z (storing ALU result)

// General-purpose registers R0 to R15
register register_R0(clear, clock, 1'b1, BusMuxOut, R0Out); 
register register_R1(clear, clock, 1'b1, BusMuxOut, R1Out); 
register register_R2(clear, clock, 1'b1, BusMuxOut, R2Out); 
register register_R3(clear, clock, 1'b1, BusMuxOut, R3Out); 
register register_R4(clear, clock, 1'b1, BusMuxOut, R4Out); 
register register_R5(clear, clock, 1'b1, BusMuxOut, R5Out); 
register register_R6(clear, clock, 1'b1, BusMuxOut, R6Out); 
register register_R7(clear, clock, 1'b1, BusMuxOut, R7Out); 
register register_R8(clear, clock, 1'b1, BusMuxOut, R8Out); 
register register_R9(clear, clock, 1'b1, BusMuxOut, R9Out); 
register register_R10(clear, clock, 1'b1, BusMuxOut, R10Out); 
register register_R11(clear, clock, 1'b1, BusMuxOut, R11Out); 
register register_R12(clear, clock, 1'b1, BusMuxOut, R12Out); 
register register_R13(clear, clock, 1'b1, BusMuxOut, R13Out); 
register register_R14(clear, clock, 1'b1, BusMuxOut, R14Out); 
register register_R15(clear, clock, 1'b1, BusMuxOut, R15Out); 

// ALU Operation (using control signals)
ALU alu(A, B, ALUControl, ALUOut64, Zero);

// BusMux (32:1 Multiplexer for Bus Selection)
mux32to1 busMux(
    .R0(R0Out), .R1(R1Out), .R2(R2Out), .R3(R3Out), 
    .R4(R4Out), .R5(R5Out), .R6(R6Out), .R7(R7Out), 
    .R8(R8Out), .R9(R9Out), .R10(R10Out), .R11(R11Out), 
    .R12(R12Out), .R13(R13Out), .R14(R14Out), .R15(R15Out), 
    .RHI(HI), .RLO(LO), .RZHI(), .RZLO(), 
    .RPC(PC), .RMDR(MDR), .RINPORT(), .RC(), 
    .Sel(BusMuxControl),  // Control signal to select the right input
    .Y(BusMuxOut)  // Output to the bus
);

// BusMuxControl signals generated by Encoder logic
Encoder32to5 encoder(
    .DataIn({R0Out, R1Out, R2Out, R3Out, R4Out, R5Out, R6Out, R7Out, 
             R8Out, R9Out, R10Out, R11Out, R12Out, R13Out, R14Out, R15Out, 
             HI, LO, Z, PC, MDR}),  // Pass the relevant outputs for BusMux
    .select(BusMuxControl)  // Select signal from Control Unit (5-bit)
);

// The result of the ALU operation is stored in the 64-bit Z register
assign Z = (RZin) ? ALUOut64 : Zregin;  // ALU result (64-bit for full operation)

// The program counter is incremented by 1 on each instruction fetch
assign TempPC = (IncPC) ? PC + 1 : PC;

endmodule
