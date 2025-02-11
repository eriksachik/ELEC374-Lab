`timescale 1ns/10ps
module new_datapath_tb;

	reg R1out, R2out, R3out, R4out, R5out, R6out, R7out; 
	reg R1in, R2in, R3in, R4in, R5in, R6in, R7in;
	reg HIin, HIout, LOin, LOout, PCin, PCout, IRin, Zin, Zhiout, Zloout, Yin, MARin, MDRin, MDRout, Read, Clock, GlobalReset;
	reg [31:0] Mdatain;
	reg [3:0] ALUControl;
	
	// using R1, R2 as conventional inputs
	// using R3 as conventional output
	wire [4:0] testBusMuxControl;
	wire [31:0] testEncoderInput;
	
	wire Zero;
	wire [31:0] testMDRvalue;
	wire [31:0] R1, R2, R3, R4, R5, R6, R7;
	wire [31:0] HI, LO, IR, PC, BusMuxOut, Y;
	wire [63:0] Z;

	//defines all possible states that the datapath can be in
	parameter  Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,  
                             Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,  
                             T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100; 
   reg  [3:0] Present_State = Default; 
	
	new_datapath DUT(.R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out),.R5out(R5out),.R6out(R6out),.R7out(R7out), .R1in(R1in), .R2in(R2in), .R3in(R3in),.R4in(R4in),.R5in(R5in),.R6in(R6in),.R7in(R7in), .testMDRvalue(testMDRvalue),
						  .HIin(HIin), .HIout(HIout), .LOin(LOin), .LOout(LOout), .PCin(PCin), .PCout(PCout), 
						  .IRin(IRin), .Zin(Zin), .Zhiout(Zhiout), .Zloout(Zloout), .Yin(Yin), .MARin(MARin), 
						  .MDRin(MDRin), .MDRout(MDRout), .Read(Read), .Clock(Clock), .GlobalReset(GlobalReset),
						  .Mdatain(Mdatain), .ALUControl(ALUControl), .testBusMuxControl(testBusMuxControl), .testEncoderInput(testEncoderInput),
						  .Zero(Zero), .R1(R1), .R2(R2), .R3(R3), .HI(HI), .LO(LO), .IR(IR), .PC(PC), .BusMuxOut(BusMuxOut),.Z(Z), .Y(Y));

	// instantiates clock signal
	initial
		begin
			Clock = 0;
			forever #10 Clock = ~Clock;
	end
	
	// case statement for each possible state the datapath could be in
	always@(posedge Clock)
		begin
			case(Present_State)
			
				Default : Present_State = Reg_load1a;
				Reg_load1a : Present_State = Reg_load1b;
				Reg_load1b : Present_State = Reg_load2a;
//				Reg_load1b : Present_State = Reg_load1b; //debugging
				Reg_load2a : Present_State = Reg_load2b;
				Reg_load2b : Present_State = Reg_load3a;
				Reg_load3a : Present_State = Reg_load3b;
				Reg_load3b : Present_State = T0;
				T0			  : Present_State = T1;
				T1			  : Present_State = T2;
				T2			  : Present_State = T3;
				T3			  : Present_State = T4;
				T4			  : Present_State = T5;
				default    : Present_State = Default;
				
			endcase
	end
	
	always @(Present_State) begin
    case (Present_State)

        // Default state: Reset or idle state, clear all control signals
        Default: begin
            // Deassert all control signals
            // Example: R1in = 0; R1out = 0; Zin = 0;
            // Load initial values if needed
				R1out<=0; R1in<=0; R2out<=0; R2in<=0; R3out<=0; R3in<=0; HIin<=0; HIout<=0; LOin<=0; LOout<=0; PCin<=0; PCout<=0; 
				IRin<=0; Zin<=0; Zhiout<=0; Zloout<=0; Yin<=0; MARin<=0; MDRin<=0; MDRout<=0; Read<=0; Clock<=0; GlobalReset<=0;
				
				R4out<=0; R4in<=0; R5out<=0; R5in<=0;
				R6out<=0; R6in<=0; R7out<=0; R7in<=0;
				
				Mdatain <= 32'h00000000; 

        end

        // Load Register 1
        Reg_load1a: begin
		  
            // Example: Mdatain = <value>;
				Mdatain<=32'h00000014;
            // Assert Read = 1, MDRin = 1
				Read = 0; MDRin = 0;
				Read <= 1; MDRin <= 1;
				#15 Read <= 0; MDRin <= 0;
				
        end
		  
        Reg_load1b: begin
            // Example: MDRout = 1, R1in = 1;
				
				MDRout <= 1; R1in <= 1;  
				
				#15 MDRout <= 0; R1in <= 0;
				
        end

        // Load Register 2
        Reg_load2a: begin
            // Example: Mdatain = <value>;
            // Assert Read = 1, MDRin = 1
				
				Mdatain<=32'h00000024;
				
				Read = 0; MDRin = 0;
				Read <= 1; MDRin <= 1;
				#15 Read <= 0; MDRin <= 0;
				
        end
        Reg_load2b: begin
            // Example: MDRout = 1, R2in = 1;
				
				MDRout <= 1; R2in <= 1;  
				
				#15 MDRout <= 0; R2in <= 0;
				
        end

        // Load Register 3
        Reg_load3a: begin
            // Example: Mdatain = <value>;
            // Assert Read = 1, MDRin = 1
				Mdatain<=32'h00000000;
				
				Read = 0; MDRin = 0;
				Read <= 1; MDRin <= 1;
				#15 Read <= 0; MDRin <= 0;
				
        end
        Reg_load3b: begin
            // Example: MDRout = 1, R3in = 1;
				
				MDRout <= 1; R3in <= 1;  
				
				#15 MDRout <= 0; R3in <= 0;
				
        end

        // Instruction execution steps
        T0: begin
            // Example: PCout = 1, MARin = 1, IncPC = 1, Zin = 1;
				PCout <= 1; MARin <= 1; PCin <= 1;
				#15 PCout <= 0; MARin <= 0;PCin<=0;
        end
        T1: begin
            // Example: Zlowout = 1, PCin = 1, Read = 1, MDRin = 1;
				
				Read <= 1; MDRin <= 1;   
				Mdatain <= 32'h2A2B8000; // placeholder Instruction/opcode
				
        end
        T2: begin
            // Example: MDRout = 1, IRin = 1;
				MDRout <= 1; IRin <= 1; 
				#15 MDRout <= 0; IRin <= 0; 
        end
        T3: begin
            // Example: R1out = 1, Yin = 1;
				R1out <= 1; Yin <= 1;
				#15 R1out <= 0; Yin <= 0;	
        end
        T4: begin
            // Example: R2out = 1, ALUControl = <some_op>, Zin = 1;
				R2out <= 1; ALUControl <= 4'b0000; Zin <= 1; // ALUControl signal for ADD
				#15 R2out<=0; Zin<=0;
        end
        T5: begin
            // Example: Zlowout = 1, R3in = 1;
				Zloout <= 1; R3in <= 1;   
				#15 Zloout<=0; R3in <= 0;
        end

        // Default case to handle any unexpected states
        default: begin
            Present_State = Default;
        end

    endcase
end

	
	
endmodule
