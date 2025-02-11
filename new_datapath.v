`timescale 1ns/10ps
module new_datapath(

	input wire R1out, R2out, R3out, R4out, R5out, R6out, R7out,
	input wire R1in, R2in, R3in, R4in, R5in, R6in, R7in,
	input wire HIin, HIout, LOin, LOout, PCin, PCout, IRin, Zin, Zhiout, Zloout, Yin, MARin, MDRin, MDRout, Read, Clock, GlobalReset,
	input wire [31:0] Mdatain,
	input wire [3:0] ALUControl,
	
	
	// using R1, R2 as conventional inputs
	// using R3 as conventional output
	output wire [4:0] testBusMuxControl,
	output wire [31:0] testEncoderInput,
	output wire [31:0] testMDRvalue,
	
	output wire Zero,
	output wire [31:0] R1, R2, R3, R4, R5, R6, R7,
	output wire [31:0] HI, LO, IR, PC, BusMuxOut, Y,
	output wire [63:0] Z

);

// internal BusMux placeholder signals
wire [31:0] MDR;
wire [8:0] marAddress;
wire [4:0] BusMuxControl;
wire [63:0] ALU_Output;

// module declarations
registerPC PC_reg(.clear(GlobalReset), .clock(Clock), .increment(PCin), .PCOut(PC)); // Program Counter

ALU ArithLogUnit(.A(Y), .B(BusMuxOut), .ALUControl(ALUControl), .ALUOut(ALU_Output), .Zero(Zero));

MDR mdr(.clk(Clock), .clr(GlobalReset), .BusMuxOut(BusMuxOut), .MdataIn(Mdatain), .MDRin(MDRin), .Read(Read), .MDROut(MDR));

MAR mar(.clk(Clock), .clr(GlobalReset), .dIn(BusMuxOut), .Rin(MARin), .address(marAddress));

// DEBUGGING modules

DEBUG32 dbgMDR(.debugWire(MDR), .debugOut(testMDRvalue), .clk(Clock));
DEBUG dbg(.debugWire(BusMuxControl), .debugOut(testBusMuxControl), .clk(Clock));
DEBUG32 dbg32(.debugWire({
        1'b0,  // Bit 31 (unused)
        1'b0,  // Bit 30 (unused)
        1'b0,  // Bit 29 (unused)
        1'b0,  // Bit 28 (unused)
        1'b0,  // Bit 27 (unused)
        1'b0,  // Bit 26 (unused)
        1'b0,  // Bit 25 (unused)
        1'b0,  // Bit 24 (unused)
        1'b0,  // Bit 23 (unused)
        1'b0,  // Bit 22 (unused)
        1'b0,  // Bit 21 (unused)
        1'b0,  // Bit 20 (unused)
        1'b0,  // Bit 19 (unused)
        1'b0,  // Bit 18 (unused)
        1'b0,  // Bit 17 (unused)
        1'b0,  // Bit 16 (unused)
        HIout, // Bit 15 (HIout)
        LOout, // Bit 14 (LOout)
        Zhiout,// Bit 13 (Zhiout)
        Zloout,// Bit 12 (Zloout)
        PCout, // Bit 11 (PCout)
        MDRout,// Bit 10 (MDRout)
        1'b0,  // Bit 9 (unused)
        1'b0,  // Bit 8 (unused)
        R7out,  // Bit 7 (unused)
        R6out,  // Bit 6 (unused)
        R5out,  // Bit 5 (unused)
        R4out,  // Bit 4 (unused)
        R3out, // Bit 3 (R3out)
        R2out, // Bit 2 (R2out)
        R1out, // Bit 1 (R1out)
        1'b0   // Bit 0 (R0out, unused)
    }), .debugOut(testEncoderInput), .clk(Clock));

// register declarations


register Y_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(Yin),         // Enables writing from BusMuxOut to Y
    .BusMuxOut(BusMuxOut), // Input data for Y
    .BusMuxIn(Y)          // Stored value of Y
);

register R1_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R1in),         // Enables writing from BusMuxOut to R1
    .BusMuxOut(BusMuxOut), // Input data for R1
    .BusMuxIn(R1)          // Stored value of R1
);
register R2_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R2in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R2)          
);
register R3_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R3in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R3)          
);
register R4_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R4in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R4)          
);
register R5_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R5in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R5)          
);
register R_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R6in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R6)          
);
register R7_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R7in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R7)          
);
register HI_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(HIin),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(HI)          
);
register LO_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(LOin),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(LO)          
);
register IR_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(IRin),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(IR)          
);
register64 Z_reg (			// only 64-bit register
    .clear(GlobalReset),
    .clock(Clock),
    .enable(Zin),         
    .BusMuxOut(ALU_Output), 
    .BusMuxIn(Z)          
);

// Bus Logic: 32-to-5 Encoder & 32-to-1 32-bit Mux

// BusMuxControl signals generated manually for testing
//Encoder32to5 encoder(
//    .DataIn({
//        1'b0,  // Bit 31 (unused)
//        R1out,  // Bit 30 (unused)
//        R2out,  // Bit 29 (unused)
//        R3out,  // Bit 28 (unused)
//        R4out,  // Bit 27 (unused)
//        R5out,  // Bit 26 (unused)
//        R6out,  // Bit 25 (unused)
//        R7out,  // Bit 24 (unused)
//        1'b0,  // Bit 23 (unused)
//        1'b0,  // Bit 22 (unused)
//        MDRout,  // Bit 21 (unused)
//        PCout,  // Bit 20 (unused)
//        Zloout,  // Bit 19 (unused)
//        Zhiout,  // Bit 18 (unused)
//        LOout,  // Bit 17 (unused)
//        HIout,  // Bit 16 (unused)
//        1'b0,// Bit 12 (Zloout)
//        1'b0, // Bit 11 (PCout)
//        1'b0,// Bit 10 (MDRout)
//        1'b0,  // Bit 9 (unused)
//        1'b0,  // Bit 8 (unused)
//        1'b0,  // Bit 7 (unused)
//        1'b0,  // Bit 6 (unused)
//        1'b0,  // Bit 5 (unused)
//        1'b0,  // Bit 4 (unused)
//        1'b0, // Bit 3 (R3out)
//        1'b0, // Bit 2 (R2out)
//        1'b0, // Bit 1 (R1out)
//		  1'b0,
//		  1'b0,
//		  1'b0,
//        1'b0   // Bit 0 (R0out, unused)
//    }),
//    .select(BusMuxControl)  // Select signal from Control Unit (5-bit)
//);


Encoder32to5 encoder(
    .DataIn({
        1'b0,      // Bit 31 (unused)
        1'b0,      // Bit 30 (unused)
        1'b0,      // Bit 29 (unused)
        1'b0,      // Bit 28 (unused)
        1'b0,      // Bit 27 (unused)
        1'b0,      // Bit 26 (unused)
        1'b0,      // Bit 25 (unused)
        1'b0,      // Bit 24 (unused)
        1'b0,      // Bit 23 (unused)
        1'b0,      // Bit 22 (unused)
        MDRout,    // Bit 21 (MDRout)
        PCout,     // Bit 20 (PCout)
        Zloout,    // Bit 19 (Zloout)
        Zhiout,    // Bit 18 (Zhiout)
        LOout,     // Bit 17 (LOout)
        HIout,     // Bit 16 (HIout)
        1'b0,      // Bit 15 (unused)
        1'b0,      // Bit 14 (unused)
        1'b0,      // Bit 13 (unused)
        1'b0,      // Bit 12 (unused)
        1'b0,      // Bit 11 (unused)
        1'b0,      // Bit 10 (unused)
        1'b0,      // Bit 9 (unused)
        1'b0,      // Bit 8 (unused)
        R7out,     // Bit 7 (R7out)
        R6out,     // Bit 6 (R6out)
        R5out,     // Bit 5 (R5out)
        R4out,     // Bit 4 (R4out)
        R3out,     // Bit 3 (R3out)
        R2out,     // Bit 2 (R2out)
        R1out,     // Bit 1 (R1out)
        1'b0       // Bit 0 (R0out, unused)
    }),
    .select(BusMuxControl)  // Select signal from Control Unit (5-bit)
);

mux32to1 busMux(
    .R0(32'b0), .R1(R1), .R2(R2), .R3(R3), 
    .R4(R4), .R5(R5), .R6(R6), .R7(R7), 
    .R8(32'b0), .R9(32'b0), .R10(32'b0), .R11(32'b0), 
    .R12(32'b0), .R13(32'b0), .R14(32'b0), .R15(32'b0), 
    .RHI(HI), .RLO(LO), .RZHI(Z[63:32]), .RZLO(Z[31:0]), 
    .RPC(PC), .RMDR(MDR), .RINPORT(32'b0), .RC(32'b0), 
    .Sel(BusMuxControl),  // Control signal to select the right input
    .Y(BusMuxOut)  // Output to the bus
);

endmodule
