`timescale 1ns/10ps
module new_datapath(

	input wire HIin, HIout, LOin, LOout, PCinc, PCout, IRin, Zin, Zhiout, Zloout, Yin, MARin, MDRin, MDRout, Read, Clock, GlobalReset, write, //ADDED WRITE
	input wire Gra, Grb, Grc, Rout, Rin, BAout, s_d_en, CONin, OUT_portin, Strobe, IN_portout, Cout, PCin,// ADD TO TESTBENCH
	input wire [4:0] ALUControl,
	
	output wire Zero,
	output wire CONout, 
	output wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, Cex, OUT,
	output wire [31:0] IN, INdata, HI, LO, IR, PC, BusMuxOut, Y, PCinput,
	output wire [63:0] Z

);

// internal BusMux placeholder signals
wire [31:0] MDR;
wire [8:0] marAddress;
wire [4:0] BusMuxControl;
wire [63:0] ALU_Output;
wire [31:0] Mdatain;

// register select signals
wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out; // ADD TO TESTBENCH
wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;

// RAM declaration

ram RAM(.address(marAddress), .clock(Clock), .data(MDR), .wren(write), .q(Mdatain));

// Select and Encode Logic

select_decode_logic s_d (
	 .ir(IR),
    .Gra(Gra), .Grb(Grb), .Grc(Grc), 
    .Rout(Rout), .BAout(BAout), .Rin(Rin), 
    .enable(s_d_en), 

    .R0in(R0in), .R1in(R1in), .R2in(R2in), .R3in(R3in),
    .R4in(R4in), .R5in(R5in), .R6in(R6in), .R7in(R7in),
    .R8in(R8in), .R9in(R9in), .R10in(R10in), .R11in(R11in),
    .R12in(R12in), .R13in(R13in), .R14in(R14in), .R15in(R15in),

    .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out),
    .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out),
    .R8out(R8out), .R9out(R9out), .R10out(R10out), .R11out(R11out),
    .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),

    .CsignExtended(Cex) //*************************************************
);

// CONFF

wire CON_FF_Out;  // Temporary wire to hold the output from CON_FF

CON_FF con_ff(
    .IR(IR[22:19]),
    .R(BusMuxOut), 
    .CONin(CONin), 
    .CON(CON_FF_Out) // Store the result in a wire first
);

registerCON_FF CONout_reg(
    .clear(GlobalReset),
    .clock(Clock),
    .enable(CONin),         // Enable writing when CONin is high
    .CON_FFin(CON_FF_Out), // Input from CON_FF
    .CON_FFout(CONout)       // Stored value
);


// module declarations
registerPC PC_reg(.clear(GlobalReset), .clock(Clock), .increment(PCinc), .PCOut(PC), .PCinput(BusMuxOut), .in(PCin)); // Program Counter

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

register0 R0_reg(
    .clear(GlobalReset), 
	 .clock(Clock), 
	 .enable(R0in), 
	 .BAout(BAout), 
	 .BusMuxOut(BusMuxOut), 
	 .R0in(R0in), 
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
register OUT_port (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(OUT_portin),         
    .BusMuxOut(BusMuxOut), 
    .BusMuxIn(OUT)          
);
register IN_port (
    .clear(GlobalReset),
    .clock(Clock),
    .enable(Strobe),         
    .BusMuxOut(IN), 
    .BusMuxIn(INdata)          
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
        Cout,      // Bit 23 (unused)
        IN_portout,      // Bit 22 (unused)
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
    .R12(R12), .R13(R13), .R14(R14), .R15(R15), 
    .RHI(HI), .RLO(LO), .RZHI(Z[63:32]), .RZLO(Z[31:0]), 
    .RPC(PC), .RMDR(MDR), .RINPORT(INdata), .RC(Cex), 
    .Sel(BusMuxControl),  // Control signal to select the right input
    .Y(BusMuxOut)  // Output to the bus
);

endmodule
