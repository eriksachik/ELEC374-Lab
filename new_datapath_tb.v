`timescale 1ns/10ps
module new_datapath_tb;

	reg R1out, R2out, R3out;
	reg R1in, R2in, R3in;
	reg HIin, HIout, LOin, LOout, PCin, PCout, IRin, Zin, Zhiout, Zloout, Yin, MARin, MDRin, MDRout, Read, Clock, GlobalReset;
	reg [31:0] Mdatain;
	reg [3:0] ALUControl;
	
	// using R1, R2 as conventional inputs
	// using R3 as conventional output
	wire Zero;
	wire [31:0] R1, R2, R3;
	wire [31:0] HI, LO, IR, PC, BusMuxOut;
	wire [63:0] Z;

	//defines all possible states that the datapath can be in
	parameter  Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,  
                             Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,  
                             T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100; 
   reg  [3:0] Present_State = Default; 
	
	new_datapath DUT(.R1out(R1out), .R2out(R2out), .R3out(R3out), .R1in(R1in), .R2in(R2in), .R3in(R3in), 
						  .HIin(HIin), .HIout(HIout), .LOin(LOin), .LOout(LOout), .PCin(PCin), .PCout(PCout), 
						  .IRin(IRin), .Zin(Zin), .Zhiout(Zhiout), .Zloout(Zloout), .Yin(Yin), .MARin(MARin), 
						  .MDRin(MDRin), .MDRout(MDRout), .Read(Read), .Clock(Clock), .GlobalReset(GlobalReset),
						  .Mdatain(Mdatain), .ALUControl(ALUControl),
						  .Zero(Zero), .R1(R1), .R2(R2), .R3(R3), .HI(HI), .LO(LO), .IR(IR), .PC(PC), .BusMuxOut(BusMuxOut),.Z(Z));

	// instantiates clock signal
	initial
		begin
			Clock = 0;
			forever #15 Clock = ~Clock;
	end
	
	// case statement for each possible state the datapath could be in
	always@(posedge Clock)
		begin
			case(Present_State)
			
				Default : Present_State = Reg_load1a;
				Reg_load1a : Present_State = Reg_load1b;
				Reg_load1b : Present_State = Reg_load2a;
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
				Mdatain <= 32'h00000000; 

        end

        // Load Register 1
        Reg_load1a: begin
		  
            // Example: Mdatain = <value>;
				Mdatain<=32'h00000018;
            // Assert Read = 1, MDRin = 1
				Read = 0; MDRin = 0;
				Read <= 1; MDRin <= 1;
				#15 Read <= 0; MDRin <= 0;
				
        end
		  
        Reg_load1b: begin
            // Example: MDRout = 1, R1in = 1;
				
				MDRout <= 1; R1in <= 1;   
				#20 MDRout <= 0; R1in <= 0;
				
        end

        // Load Register 2
        Reg_load2a: begin
            // Example: Mdatain = <value>;
            // Assert Read = 1, MDRin = 1
        end
        Reg_load2b: begin
            // Example: MDRout = 1, R2in = 1;
        end

        // Load Register 3
        Reg_load3a: begin
            // Example: Mdatain = <value>;
            // Assert Read = 1, MDRin = 1
        end
        Reg_load3b: begin
            // Example: MDRout = 1, R3in = 1;
        end

        // Instruction execution steps
        T0: begin
            // Example: PCout = 1, MARin = 1, IncPC = 1, Zin = 1;
        end
        T1: begin
            // Example: Zlowout = 1, PCin = 1, Read = 1, MDRin = 1;
        end
        T2: begin
            // Example: MDRout = 1, IRin = 1;
        end
        T3: begin
            // Example: R1out = 1, Yin = 1;
        end
        T4: begin
            // Example: R2out = 1, ALUControl = <some_op>, Zin = 1;
        end
        T5: begin
            // Example: Zlowout = 1, R3in = 1;
        end

        // Default case to handle any unexpected states
        default: begin
            Present_State = Default;
        end

    endcase
end

	
	
endmodule
