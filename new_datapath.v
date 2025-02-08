`timescale 1ns/10ps
module new_datapath(

	input wire R1out, R2out, R3out,
	input wire R1in, R2in, R3in, 
	input wire HIin, HIout, LOin, LOout, PCin, PCout, IRin, Zin, Zhiout, Zloout, Yin, MARin, MDRin, MDRout, Read, Clock, GlobalReset,
	input wire [31:0] Mdatain,
	input wire [3:0] ALUControl,
	
	// using R1, R2 as conventional inputs
	// using R3 as conventional output
	output wire Zero,
	output wire [31:0] R1, R2, R3,
	output wire [31:0] HI, LO, IR, PC, BusMuxOut,
	output wire [63:0] Z

);

// internal BusMux placeholder signals
wire [31:0] MDR;
wire [8:0] marAddress;
wire [4:0] BusMuxControl;

// module declarations
registerPC PC_reg(.clear(GlobalReset), .clock(Clock), .increment(PCin), .PCOut(PC)); // Program Counter

ALU ArithLogUnit(.A(R1), .B(R2), .ALUControl(ALUControl), .ALUOut(Z), .Zero(Zero));

MDR mdr(.clk(Clock), .clr(GlobalReset), .BusMuxOut(BusMuxOut), .MdataIn(Mdatain), .MDRin(MDRin), .Read(Read), .MDROut(MDR));

MAR mar(.clk(Clock), .clr(GlobalReset), .dIn(BusMuxOut), .Rin(1'b0), .address(marAddress));

// register declarations

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
//register64 Z_reg (			// only 64-bit register
//    .clear(GlobalReset),
//    .clock(Clock),
//    .enable(Zin),         
//    .BusMuxOut(???ALUout???), 
//    .BusMuxIn(Z)          
//);

// Bus Logic: 32-to-5 Encoder & 32-to-1 32-bit Mux

// BusMuxControl signals generated manually for testing
Encoder32to5 encoder(
    .DataIn({1'b0, R1out, R2out, R3out, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 		 // R0 and R4-R15 are not useful right now, put in later
	 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, HIout, LOout, Zhiout, Zloout, PCout, MDRout, 1'b0, 1'b0}),  // Pass the relevant outputs for BusMux: assume no Carry Out or external port data for now
    .select(BusMuxControl)  // Select signal from Control Unit (5-bit)
);
mux32to1 busMux(
    .R0(1'b0), .R1(R1), .R2(R2), .R3(R3), 
    .R4(1'b0), .R5(1'b0), .R6(1'b0), .R7(1'b0), 
    .R8(1'b0), .R9(1'b0), .R10(1'b0), .R11(1'b0), 
    .R12(1'b0), .R13(1'b0), .R14(1'b0), .R15(1'b0), 
    .RHI(HI), .RLO(LO), .RZHI(Z[63:32]), .RZLO(Z[31:0]), 
    .RPC(PC), .RMDR(MDR), .RINPORT(1'b0), .RC(1'b0), 
    .Sel(BusMuxControl),  // Control signal to select the right input
    .Y(BusMuxOut)  // Output to the bus
);

endmodule
