`timescale 1ns/10ps
module new_datapath(

	input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
	input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
	input wire HIin, HIout, LOin, LOout, PCin, PCout, IRin, Zin, Zhiout, Zloout, Yin, MARin, MDRin, MDRout, Read, Clock, GlobalReset,
	input wire [31:0] Mdatain,
	input wire [4:0] ALUControl,
	
	output wire Zero,
	output wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15,
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

// register declarations

register Y_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(Yin),         // Enables writing from BusMuxOut to Y
    .BusMuxOut(BusMuxOut), // Input data for Y
    .BusMuxIn(Y)          // Stored value of Y
);
register R0_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R0in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R0)          
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
register R6_reg (
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
register R8_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R8in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R8)          
);
register R9_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R9in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R9)          
);
register R10_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R10in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R10)          
);
register R11_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R11in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R11)          
);
register R12_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R12in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R12)          
);
register R13_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R13in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R13)          
);
register R14_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R14in),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R14)          
);
register R15_reg (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(R15in), 
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(R15)          
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
        MDRout,    // Bit 21 
        PCout,     // Bit 20
        Zloout,    // Bit 19
        Zhiout,    // Bit 18
        LOout,     // Bit 17 
        HIout,     // Bit 16 
        R15out,    // Bit 15 
        R14out,    // Bit 14
        R13out,    // Bit 13 
        R12out,    // Bit 12 
        R11out,    // Bit 11
        R10out,    // Bit 10 
        R9out,     // Bit 9
        R8out,     // Bit 8
        R7out,     // Bit 7
        R6out,     // Bit 6
        R5out,     // Bit 5
        R4out,     // Bit 4
        R3out,     // Bit 3 
        R2out,     // Bit 2
        R1out,     // Bit 1
        R0out      // Bit 0 
    }),
    .select(BusMuxControl)  // Select signal from Control Unit (5-bit)
);

mux32to1 busMux(
    .R0(R0), .R1(R1), .R2(R2), .R3(R3), 
    .R4(R4), .R5(R5), .R6(R6), .R7(R7), 
    .R8(R8), .R9(R9), .R10(R9), .R11(R11), 
    .R12(R12), .R13(13), .R14(R14), .R15(R15), 
    .RHI(HI), .RLO(LO), .RZHI(Z[63:32]), .RZLO(Z[31:0]), 
    .RPC(PC), .RMDR(MDR), .RINPORT(32'b0), .RC(32'b0), 
    .Sel(BusMuxControl),  // Control signal to select the right input
    .Y(BusMuxOut)  // Output to the bus
);

endmodule
