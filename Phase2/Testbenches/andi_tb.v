`timescale 1ns/10ps
module new_datapath_tb;

//	reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, Cout; 
//	reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
	reg HIin, HIout, LOin, LOout, PCin, PCout, IRin, Zin, Zhiout, Zloout, Yin, MARin, MDRin, MDRout, Read, Clock, GlobalReset, write;
	reg Gra, Grb, Grc, Rout, Rin, BAout, s_d_en, CONin, CONout, OUT_portin, Strobe, IN_portout, Cout;
//	reg [31:0] Mdatain;
	reg [4:0] ALUControl;
	
	// using R1, R2 as conventional inputs
	// using R3 as conventional output
	
	wire Zero;
	wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15;
	wire [31:0] HI, LO, IR, PC, BusMuxOut, Y;
	wire [63:0] Z;
	
	reg second;

	initial begin
		 second = 1'b1;  // Initialize to 1
	end


	//defines all possible states that the datapath can be in
	parameter  Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,  
                             Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,  
                             T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101, T7 = 4'b1110, T8 = 4'b1111; 
   reg  [3:0] Present_State = Default; 
	
	new_datapath DUT(
//						  .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out),.R5out(R5out),.R6out(R6out),.R7out(R7out), 
//						  .R8out(R8out), .R9out(R9out), .R10out(R10out), .R11out(R11out), .R12out(R12out),.R13out(R13out),.R14out(R14out),.R15out(R15out), 
//						  .R0in(R0in), .R1in(R1in), .R2in(R2in), .R3in(R3in),.R4in(R4in),.R5in(R5in),.R6in(R6in),.R7in(R7in),
//						  .R8in(R8in), .R9in(R9in), .R10in(R10in), .R11in(R11in),.R12in(R12in),.R13in(R13in),.R14in(R14in),.R15in(R15in),
						  .HIin(HIin), .HIout(HIout), .LOin(LOin), .LOout(LOout), .PCin(PCin), .PCout(PCout), 
						  .IRin(IRin), .Zin(Zin), .Zhiout(Zhiout), .Zloout(Zloout), .Yin(Yin), .MARin(MARin), 
						  .MDRin(MDRin), .MDRout(MDRout), .Read(Read), .Clock(Clock), .GlobalReset(GlobalReset),
//						  .Mdatain(Mdatain), 
						  .ALUControl(ALUControl),
						  .Zero(Zero), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .HI(HI), .LO(LO), .IR(IR), .PC(PC), .BusMuxOut(BusMuxOut),.Z(Z), .Y(Y),
						  .R4(R4), .R5(R5), .R6(R6), .R7(R7), .R8(R8), .R9(R9), .R10(R10), .R11(R11), .R12(R12), .R13(R13), .R14(R14), .R15(R15),
						  .Cout(Cout), .write(write), .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rout(Rout), .Rin(Rin), .BAout(BAout), .s_d_en(s_d_en), 
						  .CONin(CONin), .CONout(CONout), .OUT_portin(OUT_portin), .Strobe(Strobe), .IN_portout(IN_portout));

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
				T6			  : Present_State = T7;
				T7			  : Present_State = T8;
				default    : Present_State = Default;
				
			endcase
	end
	
always @(Present_State) begin
    case (Present_State)

        // Default state: Reset or idle state, clear all control signals
        Default: begin
            // Deassert all control signals
            HIin<=0; HIout<=0; LOin<=0; LOout<=0; PCin<=0; PCout<=0; 
            IRin<=0; Zin<=0; Zhiout<=0; Zloout<=0; Yin<=0; MARin<=0; MDRin<=0; MDRout<=0; Read<=0; Clock<=0; GlobalReset<=0;
            Cout<=0; IN_portout<=0;
            Gra<=0; Grb<=0; Grc<=0; Rout<=0; BAout<=0; Rin<=0;
            s_d_en<=1; CONin<=0; CONout<=0; OUT_portin<=0; Strobe<=0;
            write<=0;
        end

        // Instruction execution steps
        T0: begin
            if (second) begin
                PCout <= 1; MARin <= 1; PCin <= 1;
                #15 PCout <= 0; MARin <= 0; PCin <= 0;
            end else begin
					 PCout <= 1; MARin <= 1; PCin <= 1;
					 #15 PCout <= 0; PCin <= 0;
				end
					 
        end
        T1: begin
            if (second) begin
                Read <= 1; MDRin <= 1;   
                #15 Read <= 0; MDRin <= 0;
            end else begin
					 #15 MARin <= 0;
				end
        end
        T2: begin
            if (second) begin
                MDRout <= 1; IRin <= 1; 
                #15 MDRout <= 0; IRin <= 0; 
            end else begin
					 Read <= 1; MDRin <= 1;   
				//    Mdatain <= 32'b001100_00010_00001_0000000000001010; // ANDI example opcode
					 #15 Read <= 0; MDRin <= 0;
				end
        end
        T3: begin
            if (second) begin
                Grb <= 1; BAout <= 1; Yin <= 1;
                #15 Grb <= 0; BAout <= 0; Yin <= 0;
            end else begin
							 // MDR -> IR
					 MDRout <= 1; IRin <= 1;
					 #15 MDRout <= 0; IRin <= 0; 
				end
        end
        T4: begin
            if (second) begin
                Cout <= 1; ALUControl <= 5'b00011; Zin <= 1;  
                #15 Cout <= 0; Zin <= 0;
            end else begin
							 // R[rb] -> Y register
					 Grb <= 1; BAout <= 1; Yin <= 1; 
					 #15 Grb <= 0; BAout <= 0; Yin <= 0; 
				end
        end
        T5: begin
            if (second) begin
                Zloout <= 1; MARin <= 1;   
                #15 Zloout <= 0; MARin <= 0;
            end else begin
					 // ALU: Y AND Immediate
					 // Replace ADD opcode with AND opcode for ALUControl
					 Cout <= 1; 
					 ALUControl <= 5'b00101; // Assuming 5'b00001 = AND in your ALU
					 Zin <= 1;
					 #15 Zin <= 0; Cout <= 0;
				end
        end
        T6: begin
            if (second) begin
                Read <= 1; MDRin <= 1; 
            end else begin
					 // Store result Zloout -> destination reg
					 Zloout <= 1; Gra <= 1; Rin <= 1; 
					 #15 Zloout <= 0; Gra <= 0; Rin <= 0;
				end
        end
        T7: begin
            if (second) begin
                #15 Read <= 0; MDRin <= 0;
            end
        end
        T8: begin
            if (second) begin
                MDRout <= 1; Gra <= 1; Rin <= 1;   
                #15 MDRout <= 0; Gra <= 0; Rin <= 0; 
            end
				second <= 0;
        end

        // Default case to handle any unexpected states
        default: begin
            Present_State = Default;
        end

    endcase
end


	
	
endmodule
