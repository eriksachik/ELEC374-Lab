`timescale 1ns/10ps
module new_datapath_tb;

    // Control Signals
    reg HIin, HIout, LOin, LOout, PCinc, PCout, IRin, Zin, Zhiout, Zloout, Yin, MARin, MDRin, MDRout, Read, Clock, GlobalReset, write;
    reg Gra, Grb, Grc, Rout, Rin, BAout, s_d_en, CONin, OUT_portin, Strobe, IN_portout, Cout, PCin;
    reg [4:0] ALUControl;

    // Datapath Outputs
    wire Zero;
    wire CONout;
    wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15;
    wire [31:0] HI, LO, IR, PC, BusMuxOut, Y;
    wire [63:0] Z;

	//defines all possible states that the datapath can be in
	parameter  Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,  
                             Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,  
                             T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101, T7 = 4'b1110, T8 = 4'b1111; 
   reg  [3:0] Present_State = Default; 
	
	    // Instantiate the datapath
    new_datapath DUT(
        .HIin(HIin), .HIout(HIout), .LOin(LOin), .LOout(LOout), .PCinc(PCinc), .PCout(PCout), 
        .IRin(IRin), .Zin(Zin), .Zhiout(Zhiout), .Zloout(Zloout), .Yin(Yin), .MARin(MARin), 
        .MDRin(MDRin), .MDRout(MDRout), .Read(Read), .Clock(Clock), .GlobalReset(GlobalReset),
        .ALUControl(ALUControl), .PCin(PCin),
        .Zero(Zero), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .HI(HI), .LO(LO), .IR(IR), .PC(PC), .BusMuxOut(BusMuxOut), .Z(Z), .Y(Y),
        .R4(R4), .R5(R5), .R6(R6), .R7(R7), .R8(R8), .R9(R9), .R10(R10), .R11(R11), .R12(R12), .R13(R13), .R14(R14), .R15(R15),
        .Cout(Cout), .write(write), .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rout(Rout), .Rin(Rin), .BAout(BAout), .s_d_en(s_d_en), 
        .CONin(CONin), .CONout(CONout), .OUT_portin(OUT_portin), .Strobe(Strobe), .IN_portout(IN_portout)
    );

    // Clock signal generation
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end
	
	// case statement for each possible state the datapath could be in
	always@(posedge Clock)
		begin
			case(Present_State)
				Default : Present_State = T0;
			
//				Default : Present_State = Reg_load1a;
//				Reg_load1a : Present_State = Reg_load1b;
//				Reg_load1b : Present_State = Reg_load2a;
//				Reg_load2a : Present_State = Reg_load2b;
////				Reg_load2b : Present_State = Reg_load3a;
//				
//				Reg_load2b : Present_State = T0;     // comment out for operations without hi and lo outputs
//
////				Reg_load3a : Present_State = Reg_load3b;
//				Reg_load3b : Present_State = T0;
				T0			  : Present_State = T1;
				T1			  : Present_State = T2;
				T2			  : Present_State = T3;
				T3			  : Present_State = T4;
				T4			  : Present_State = T5;
				T5			  : Present_State = T6;      // comment out for operations without hi and lo outputs
//				T6			  : Present_State = T7;
//				T7			  : Present_State = T8;
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
//				R0out<=0; R0in<=0; R1out<=0; R1in<=0; R2out<=0; R2in<=0; R3out<=0; R3in<=0; 
				HIin <= 0; HIout <= 0; LOin <= 0; LOout <= 0; PCinc <= 0; PCout <= 0; 
                IRin <= 0; Zin <= 0; Zhiout <= 0; Zloout <= 0; Yin <= 0; MARin <= 0; MDRin <= 0; MDRout <= 0; Read <= 0; GlobalReset <= 0;
                Cout <= 0; IN_portout <= 0;
                Gra <= 0; Grb <= 0; Grc <= 0; Rout <= 0; BAout <= 0; Rin <= 0;
                s_d_en <= 1; CONin <= 0; OUT_portin <= 0; Strobe <= 0;
                write <= 0; PCin <= 0; 
					 
					 force R3 = 32'hF00000F0;
				
//				R4out<=0; R4in<=0; R5out<=0; R5in<=0;
//				R6out<=0; R6in<=0; R7out<=0; R7in<=0;
//				R8out<=0; R8in<=0; R9out<=0; R9in<=0;
//				R10out<=0; R10in<=0; R11out<=0; R11in<=0;
//				R12out<=0; R12in<=0; R13out<=0; R13in<=0;
//				R14out<=0; R14in<=0; R15out<=0; R15in<=0;
//				
//				Mdatain <= 32'h00000000; 

        end
//
//        // Load Register 1
//        Reg_load1a: begin
//		  
//            // Example: Mdatain = <value>;
//				Mdatain<=32'h00000000;
//            // Assert Read = 1, MDRin = 1
//				Read = 0; MDRin = 0;
//				Read <= 1; MDRin <= 1;
//				#15 Read <= 0; MDRin <= 0;
//				
//        end
//		  
//        Reg_load1b: begin
//            // Example: MDRout = 1, R1in = 1;
//				
//				MDRout <= 1; R5in <= 1;  
//				
//				#15 MDRout <= 0; R5in <= 0;
//				
//        end
//
//        // Load Register 2
//        Reg_load2a: begin
//            // Example: Mdatain = <value>;
//            // Assert Read = 1, MDRin = 1
//				
//				Mdatain<=32'h0000000F;
//				
//				Read = 0; MDRin = 0;
//				Read <= 1; MDRin <= 1;
//				#15 Read <= 0; MDRin <= 0;
//				
//        end
//        Reg_load2b: begin
//            // Example: MDRout = 1, R2in = 1;
//				
//				MDRout <= 1; R0in <= 1;  
//				
//				#15 MDRout <= 0; R0in <= 0;
//				
//        end

//        // Load Register 3
//        Reg_load3a: begin
//            // Example: Mdatain = <value>;
//            // Assert Read = 1, MDRin = 1
//				Mdatain<=32'h00000000;
//				
//				Read = 0; MDRin = 0;
//				Read <= 1; MDRin <= 1;
//				#15 Read <= 0; MDRin <= 0;
//				
//        end
//        Reg_load3b: begin
//            // Example: MDRout = 1, R3in = 1;
//				
//				MDRout <= 1; R4in <= 1;  
//				
//				#15 MDRout <= 0; R4in <= 0;
//				
//        end

        // Instruction execution steps
        T0: begin
            // Example: PCout = 1, MARin = 1, IncPC = 1, Zin = 1;
				PCout <= 1; MARin <= 1; PCin <= 1;
				#15 PCout <= 0; MARin <= 0;PCin<=0;
        end
        T1: begin
            // Example: Zlowout = 1, PCin = 1, Read = 1, MDRin = 1;
				
				Read <= 1; MDRin <= 1;   
//				Mdatain <= 32'h92800000; // placeholder Instruction/opcode
				#15 Read<=0; MDRin<=0;
				
        end
        T2: begin
            // Example: MDRout = 1, IRin = 1;
				MDRout <= 1; IRin <= 1; 
				#15 MDRout <= 0; IRin <= 0; 
        end
        T3: begin
				// Decode: R[rb] out -> Y register
				Grb <= 1; BAout <= 1; Yin <= 1; 
				#15 Grb <= 0; BAout <= 0; Yin <= 0;
		  end

		  T4: begin
				// ALU operation: Y + immediate (IR[15:0] sign-extended)
				Cout <= 1; // You don't need external Cout
				ALUControl <= 5'b00011; // Assuming this is ADD
				Zin <= 1;
				#15 Zin <= 0; Cout<=0;
		  end

			T5: begin
			// Write result: Zloout -> destination register (Gra + Rin)
			Zloout <= 1; Gra <= 1; Rin <= 1; 
			#15 Zloout <= 0; Gra <= 0; Rin <= 0;
		  end

		  

    endcase
end

	
	
endmodule
