`timescale 1ns/10ps
module ControlUnit (
//    output reg PCout, Zhiout, Zloout, MDRout, MARin, PCin, MDRin, IRin, Yin, PCinc, Read, HIin, LOin, HIout, LOout, Zin, Cout, write,
//    output reg Gra, Grb, Grc, Rin, Rout, BAout, CONin, enableInputPort, OUT_portin, InPortout, Run,
//    input [31:0] IR,
//    input Clock, Reset, Stop
	 
	 output reg HIin, HIout, LOin, LOout, PCinc, PCout, IRin, Zin, Zhiout, Zloout,
               Yin, MARin, MDRin, MDRout, Read, write,
    output reg Gra, Grb, Grc, Rout, Rin, BAout, s_d_en, CONin, OUT_portin, ReturnAddressIn,
               Strobe, IN_portout, Cout, PCin,
    output reg [4:0] ALUControl,
	 
	 input Zero,
    input CONout,
    input [31:0] IR,
    input Clock, GlobalReset, Stop
); 

	 reg Run;

    // State Encoding
    // State Encoding
	 parameter Reset_state = 8'd0, T0  = 8'd1, T1       = 8'd2, T2      = 8'd3, T3       = 8'd50,
				 TTB_T3  = 8'd4, TTB_T4   = 8'd5, TTB_T5   = 8'd6,
				 LD_T3   = 8'd7, LD_T4    = 8'd8, LD_T5    = 8'd9, LD_T6   = 8'd10, LD_T7   = 8'd11, LD_T8 = 8'd12,
				 ST_T3   = 8'd13, ST_T4   = 8'd14, ST_T5   = 8'd15, ST_T6  = 8'd16, ST_T7   = 8'd17,
				 MFHI_T3 = 8'd18, MFLO_T3 = 8'd19, IN_T3   = 8'd20, OUT_T3 = 8'd21, HALT_T3 = 8'd22,
				 ADDI_T3 = 8'd23, ADDI_T4 = 8'd24, ADDI_T5 = 8'd25,
				 ANDI_T3 = 8'd26, ANDI_T4 = 8'd27, ANDI_T5 = 8'd28,
				 ORI_T3  = 8'd29, ORI_T4  = 8'd30, ORI_T5  = 8'd31,
				 BR_T3   = 8'd32, BR_T4   = 8'd33, BR_T5   = 8'd34, BR_T6  = 8'd35,
				 JAL_T3  = 8'd36, JR_T3   = 8'd37,
				 LDI_T3  = 8'd38, LDI_T4  = 8'd39, LDI_T5  = 8'd40,
				 JAL_T4  = 8'd41, JAL_T5  = 8'd42,
				 SFB_T3  = 8'd43, SFB_T4  = 8'd44, SFB_T5  = 8'd45, SFB_T6 = 8'd46,
				 NEG_T3  = 8'd47, NEG_T4  = 8'd48,
				 NOP_T3  = 8'd49;


    reg [7:0] Present_state = Reset_state;

    always @(posedge Clock or posedge GlobalReset or posedge Stop) begin
        if (GlobalReset) Present_state <= Reset_state;
        else if (Stop) Present_state <= HALT_T3;
        else begin
            case (Present_state)
                Reset_state: Present_state <= T0; 
                T0: Present_state <= T1;
                T1: Present_state <= T2;
					 T2: Present_state <= T3;
                T3: begin
                    case (IR[31:27])
								// PHASE 1 TTB INSTRUCTIONS
								// ADD
                        5'b00011: begin Present_state <= TTB_T3; ALUControl <= 5'b00011; end
								// SUB
								5'b00100: begin Present_state <= TTB_T3; ALUControl <= 5'b00100; end
								// AND
								5'b00101: begin Present_state <= TTB_T3; ALUControl <= 5'b00101; end
								// OR
								5'b00110: begin Present_state <= TTB_T3; ALUControl <= 5'b00110; end
								// ROR
								5'b00111: begin Present_state <= TTB_T3; ALUControl <= 5'b00111; end
								// ROL
								5'b01000: begin Present_state <= TTB_T3; ALUControl <= 5'b01000; end
								// SHR
								5'b01001: begin Present_state <= TTB_T3; ALUControl <= 5'b01001; end
								// SHRA
								5'b01010: begin Present_state <= TTB_T3; ALUControl <= 5'b01010; end
								// SHL
								5'b01011: begin Present_state <= TTB_T3; ALUControl <= 5'b01011; end

								// PHASE 1 SFB INSTRUCTIONS
								// MUL
                        5'b10000: begin Present_state <= SFB_T3; ALUControl <= 5'b10000; end
								// DIV
								5'b01111: begin Present_state <= SFB_T3; ALUControl <= 5'b01111; end
								
								// PHASE 1 NEGATE/NOT
								// NEGATE
                        5'b10001: begin Present_state <= NEG_T3; ALUControl <= 5'b10001; end
								// NOT
								5'b10010: begin Present_state <= NEG_T3; ALUControl <= 5'b10010; end
								
								// PHASE 2 INSTRUCTIONS
                        5'b00000: begin Present_state <= LD_T3; ALUControl <= 5'b00011; end
                        5'b00010: begin Present_state <= ST_T3; ALUControl <= 5'b00011; end
                        5'b11001: begin Present_state <= MFHI_T3; end
                        5'b11000: begin Present_state <= MFLO_T3; end
                        5'b10110: begin Present_state <= IN_T3; end
                        5'b10111: begin Present_state <= OUT_T3; end
								5'b01100: begin Present_state <= ADDI_T3; ALUControl <= 5'b00011; end
								5'b01101: begin Present_state <= ANDI_T3; ALUControl <= 5'b00101; end
								5'b01110: begin Present_state <= ORI_T3; ALUControl <= 5'b00110; end
								5'b10011: begin Present_state <= BR_T3; ALUControl <= 5'b00011; end
								5'b10100: begin Present_state <= JAL_T3; ALUControl <= 5'b00011; end
								5'b10101: begin Present_state <= JR_T3; ALUControl <= 5'b00011; end
								5'b00001: begin Present_state <= LDI_T3; ALUControl <= 5'b00011; end
								
								// PHASE 3 INSTRUCTIONS
								5'b11011: begin Present_state <= HALT_T3; end
								5'b11010: begin Present_state <= NOP_T3; end
								
                        default: begin Present_state <= T0; end
                    endcase
					end
					
					TTB_T3: Present_state <= TTB_T4;
					TTB_T4: Present_state <= TTB_T5;
					TTB_T5: Present_state <= T0;
					
					SFB_T3: Present_state <= SFB_T4;
					SFB_T4: Present_state <= SFB_T5;
					SFB_T5: Present_state <= SFB_T6;
					SFB_T6: Present_state <= T0;
					
					NEG_T3: Present_state <= NEG_T4;
					NEG_T4: Present_state <= T0;
					
					LD_T3: Present_state <= LD_T4;
					LD_T4: Present_state <= LD_T5;
					LD_T5: Present_state <= LD_T6;
					LD_T6: Present_state <= LD_T7;
					LD_T7: Present_state <= LD_T8;
					LD_T8: Present_state <= T0;

					ST_T3: Present_state <= ST_T4;
					ST_T4: Present_state <= ST_T5;
					ST_T5: Present_state <= ST_T6;
					ST_T6: Present_state <= ST_T7;
					ST_T7: Present_state <= T0;

					ADDI_T3: Present_state <= ADDI_T4;
					ADDI_T4: Present_state <= ADDI_T5;
					ADDI_T5: Present_state <= T0;

					ANDI_T3: Present_state <= ANDI_T4;
					ANDI_T4: Present_state <= ANDI_T5;
					ANDI_T5: Present_state <= T0;

					ORI_T3: Present_state <= ORI_T4;
					ORI_T4: Present_state <= ORI_T5;
					ORI_T5: Present_state <= T0;

					BR_T3: Present_state <= BR_T4;
					BR_T4: Present_state <= BR_T5;
					BR_T5: Present_state <= BR_T6;
					BR_T6: Present_state <= T0;

					JAL_T3: Present_state <= JAL_T4;
               JAL_T4: Present_state <= JAL_T5;
               JAL_T5: Present_state <= T0;

               JR_T3: Present_state <= T0;

					LDI_T3: Present_state <= LDI_T4;
					LDI_T4: Present_state <= LDI_T5;
					LDI_T5: Present_state <= T0;

					MFHI_T3, MFLO_T3, IN_T3, OUT_T3, NOP_T3: Present_state <= T0;
					
					HALT_T3: Present_state <= HALT_T3;

					default: Present_state <= Reset_state;

            endcase
        end
    end

    always @(*) begin
        // Default deassert all signals
         {HIin, HIout, LOin, LOout, PCinc, PCout, IRin, Zin, Zhiout, Zloout,
         Yin, MARin, MDRin, MDRout, Read, write,
         Gra, Grb, Grc, Rout, Rin, BAout, CONin, OUT_portin,
         Strobe, IN_portout, Cout, PCin, ReturnAddressIn} = 0;
		  // Assert Run and Select Encode Enable
         Run = 1; s_d_en = 1;


        case (Present_state)
            T0: begin PCout = 1; MARin = 1; PCinc = 1; #15 PCout = 0; MARin = 0; PCinc = 0; end
            T1: begin Read = 1; MDRin = 1; end
            T2: begin Read = 1; MDRin = 1; #15 Read = 0; MDRin = 0; end
				T3: begin MDRout = 1; IRin = 1; #15 MDRout = 0; IRin = 0; end

            // 32 Bit 3 Reg Instruction (ADD/SUB/AND/OR/SHIFT/ROTATE)
            TTB_T3: begin Grb = 1; Rout = 1; Yin = 1; #15 Grb = 0; Rout = 0; Yin = 0; end
            TTB_T4: begin Grc = 1; Rout = 1; Zin = 1; #15 Grc = 0; Rout = 0; Zin = 0; end
            TTB_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end
				
				// 64 Bit Instruction (DIV/MUL)
				SFB_T3: begin Gra = 1; Rout = 1; Yin = 1; #15 Gra = 0; Rout = 0; Yin = 0; end
            SFB_T4: begin Grb = 1; Rout = 1; Zin = 1; #15 Grb = 0; Rout = 0; Zin = 0; end
            SFB_T5: begin Zloout = 1; LOin = 1; #15 Zloout = 0; LOin = 0; end
				SFB_T6: begin Zhiout = 1; HIin = 1; #15 Zhiout = 0; HIin = 0; end
				
				// 32 Bit 2 Reg Instruction (NEGATE/NOT)
				NEG_T3: begin Grb = 1; Rout = 1; Zin = 1; #15 Grb = 0; Rout = 0; Zin = 0; end
				NEG_T4: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end
				
				// ADDI Instruction example
            ADDI_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
            ADDI_T4: begin Cout = 1; Zin = 1; #15 Cout = 0; Zin = 0; end
            ADDI_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end
				
				// ANDI
				ANDI_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
				ANDI_T4: begin Cout = 1; Zin = 1; #15 Zin = 0; Cout = 0; end
				ANDI_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end

				// ORI
				ORI_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
				ORI_T4: begin Cout = 1; Zin = 1; #15 Zin = 0; Cout = 0; end
				ORI_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end
				
				// BR
				BR_T3: begin Gra = 1; Rout = 1; CONin = 1; #15 Gra = 0; Rout = 0; CONin = 0; end
				BR_T4: begin PCout = 1; Yin = 1; #15 PCout = 0; Yin = 0; end
				BR_T5: begin Cout = 1; Zin = 1; #15 Cout = 0; Zin = 0; end
				BR_T6: begin if(CONout) begin
										Zloout = 1; PCin = 1; 
										#15 Zloout = 0; PCin = 0; 
								 end
						 end
				
				// JAL
				JAL_T3: begin PCinc = 1; PCout = 1; ReturnAddressIn = 1; #15 PCinc = 0; PCout = 0; ReturnAddressIn = 0; end
				JAL_T4: begin Gra = 1; Rout = 1; PCin = 1; #15 Gra = 0; Rout = 0; PCin = 0; end
				JAL_T5: begin end

				// JR
				JR_T3: begin Gra = 1; Rout = 1; PCin = 1; #15 Gra = 0; Rout = 0; PCin = 0;  end

				// LDI
				LDI_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
				LDI_T4: begin Cout = 1; Zin = 1; #15 Cout = 0; Zin = 0; end
				LDI_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end
				
            // LD Instruction
            LD_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
            LD_T4: begin Cout = 1; Zin = 1; #15 Cout = 0; Zin = 0; end
            LD_T5: begin Zloout = 1; MARin = 1; #15 Zloout = 0; MARin = 0; end
            LD_T6: begin Read = 1; MDRin = 1; end
            LD_T7: begin Read = 1; MDRin = 1; #15 Read = 0; MDRin = 0; end
				LD_T8: begin MDRout = 1; Gra = 1; Rin = 1; #15 MDRout = 0; Gra = 0; Rin = 0; end

            // ST Instruction
            ST_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
            ST_T4: begin Cout = 1; Zin = 1; #15 Cout = 0; Zin = 0; end
            ST_T5: begin Zloout = 1; MARin = 1; #15 Zloout = 0; MARin = 0; end
            ST_T6: begin Gra = 1; Rout = 1; MDRin = 1; #15 Gra = 0; Rout = 0; MDRin = 0; end
            ST_T7: begin write = 1; #35 write = 0; end

            // Special
            MFHI_T3: begin HIout = 1; Gra = 1; Rin = 1; #15 HIout = 0; Gra = 0; Rin = 0; end
            MFLO_T3: begin LOout = 1; Gra = 1; Rin = 1; #15 LOout = 0; Gra = 0; Rin = 0; end
            IN_T3:   begin IN_portout = 1; Gra = 1; Rin = 1; #15 IN_portout = 0; Gra = 0; Rin = 0; end
            OUT_T3:  begin Gra = 1; Rout = 1; OUT_portin = 1; #15 Gra = 0; Rout = 0; OUT_portin = 0; end
            HALT_T3: begin Run = 0; end
				NOP_T3:  begin end
				
				Reset_state: begin end
				
				default: begin
							 // Ensure all control signals are deasserted for safety
							 {HIin, HIout, LOin, LOout, PCinc, PCout, IRin, Zin, Zhiout, Zloout,
							  Yin, MARin, MDRin, MDRout, Read, write,
							  Gra, Grb, Grc, Rout, Rin, BAout, CONin, OUT_portin,
							  Strobe, IN_portout, Cout, PCin} = 0;
							 Run = 1;
							 s_d_en = 1;
							end

        endcase
    end

endmodule
