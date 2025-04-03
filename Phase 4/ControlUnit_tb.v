

`timescale 1ns/10ps
module ControlUnit_tb();

    // Clock & Reset
    reg clk;
    reg reset;
	 reg Stop;

    // Observed Output Port
    wire [31:0] OUT;

    // Internal signals for datapath outputs
    wire Zero;
    wire CONout;

    wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9;
    wire [31:0] R10, R11, R12, R13, R14, R15;
	 wire [7:0] OUTREG, OUTREG2;
    wire [31:0] Cex;

    wire [31:0] INdata, IN;
    wire [31:0] HI, LO, IR, PC;
    wire [31:0] BusMuxOut, Y, PCinput;
    wire [63:0] Z;

	 initial begin
		clk=0;
		reset=0;
		Stop=0;
	 end
	 
	     // Clock generation
    always #10 clk = ~clk;
	 
	 
	 
    // Instantiate the datapath
    new_datapath datapath_inst (
        .Clock(clk),
        .GlobalReset(reset),
		  .Stop(Stop),
        .IN(IN),
        .OUT(OUT),
        .Zero(Zero),
        .CONout(CONout),

        .R0(R0), .R1(R1), .R2(R2), .R3(R3),
        .R4(R4), .R5(R5), .R6(R6), .R7(R7),
        .R8(R8), .R9(R9), .R10(R10), .R11(R11),
        .R12(R12), .R13(R13), .R14(R14), .R15(R15),

        .Cex(Cex),
        .INdata(INdata),
        .HI(HI), .LO(LO), .IR(IR), .PC(PC),
        .BusMuxOut(BusMuxOut), .Y(Y), .PCinput(PCinput),
        .Z(Z), .OUTREG(OUTREG), .OUTREG2(OUTREG2)
    );

endmodule
