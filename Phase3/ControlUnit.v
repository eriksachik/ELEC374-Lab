`timescale 1ns/10ps
module control_unit (
//    output reg PCout, Zhiout, Zloout, MDRout, MARin, PCin, MDRin, IRin, Yin, PCinc, Read, HIin, LOin, HIout, LOout, Zin, Cout, write,
//    output reg Gra, Grb, Grc, Rin, Rout, BAout, CONin, enableInputPort, OUT_portin, InPortout, Run,
//    input [31:0] IR,
//    input Clock, Reset, Stop
	 
	 output reg HIin, HIout, LOin, LOout, PCinc, PCout, IRin, Zin, Zhiout, Zloout,
               Yin, MARin, MDRin, MDRout, Read, write,
    output reg Gra, Grb, Grc, Rout, Rin, BAout, s_d_en, CONin, OUT_portin, 
               Strobe, IN_portout, Cout, PCin, Run,
    output wire Zero,
    output wire CONout,
    output reg [4:0] ALUControl,
	 
    input [31:0] IR,
    input Clock, GlobalReset, Stop
); 

    // State Encoding
    // State Encoding
	 parameter Reset_state = 8'd0, T0 = 8'd1, T1 = 8'd2, T2 = 8'd3, 
				 ADD_T3 = 8'd4, ADD_T4 = 8'd5, ADD_T5 = 8'd6,
				 LD_T3 = 8'd7, LD_T4 = 8'd8, LD_T5 = 8'd9, LD_T6 = 8'd10, LD_T7 = 8'd11, LD_T8 = 8'd12,
				 ST_T3 = 8'd13, ST_T4 = 8'd14, ST_T5 = 8'd15, ST_T6 = 8'd16, ST_T7 = 8'd17,
				 MFHI_T3 = 8'd18, MFLO_T3 = 8'd19, IN_T3 = 8'd20, OUT_T3 = 8'd21, HALT_T3 = 8'd22,
				 ADDI_T3 = 8'd23, ADDI_T4 = 8'd24, ADDI_T5 = 8'd25,
				 ANDI_T3 = 8'd26, ANDI_T4 = 8'd27, ANDI_T5 = 8'd28,
				 ORI_T3  = 8'd29, ORI_T4  = 8'd30, ORI_T5  = 8'd31,
				 BR_T3   = 8'd32, BR_T4   = 8'd33, BR_T5   = 8'd34, BR_T6 = 8'd35,
				 JAL_T3  = 8'd36, JR_T3   = 8'd37,
				 LDI_T3  = 8'd38, LDI_T4  = 8'd39, LDI_T5  = 8'd40,
				 JAL_T4  = 8'd41, JAL_T5  = 8'd42;


    reg [7:0] Present_state = Reset_state;

    always @(posedge Clock or posedge GlobalReset or posedge Stop) begin
        if (GlobalReset) Present_state <= Reset_state;
        else if (Stop) Present_state <= HALT_T3;
        else begin
            case (Present_state)
                Reset_state: Present_state <= T0; 
                T0: Present_state <= T1;
                T1: Present_state <= T2;
                T2: begin
                    case (IR[31:27])
                        5'b00011: begin Present_state <= ADD_T3; ALUControl <= 5'b00011; end
                        5'b00000: begin Present_state <= LD_T3; ALUControl <= 5'b00011; end
                        5'b00010: begin Present_state <= ST_T3; ALUControl <= 5'b00011; end
                        5'b10111: begin Present_state <= MFHI_T3; end
                        5'b11000: begin Present_state <= MFLO_T3; end
                        5'b10101: begin Present_state <= IN_T3; end
                        5'b10110: begin Present_state <= OUT_T3; end
                        5'b11010: begin Present_state <= HALT_T3; end
								5'b01100: begin Present_state <= ADDI_T3; ALUControl <= 5'b00011; end
								5'b01101: begin Present_state <= ANDI_T3; ALUControl <= 5'b00101; end
								5'b01110: begin Present_state <= ORI_T3; ALUControl <= 5'b00110; end
								5'b10011: begin Present_state <= BR_T3; ALUControl <= 5'b00011; end
								5'b10100: begin Present_state <= JAL_T3; ALUControl <= 5'b00011; end
								5'b10101: begin Present_state <= JR_T3; ALUControl <= 5'b00011; end
								5'b00001: begin Present_state <= LDI_T3; ALUControl <= 5'b00011; end
								
                        default: begin Present_state <= T0; end
                    endcase
					end
					ADD_T3: Present_state <= ADD_T4;
					ADD_T4: Present_state <= ADD_T5;
					ADD_T5: Present_state <= T0;

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

					MFHI_T3, MFLO_T3, IN_T3, OUT_T3, HALT_T3: Present_state <= T0;

					default: Present_state <= Reset_state;

            endcase
        end
    end

    always @(*) begin
        // Default deassert all signals
         {HIin, HIout, LOin, LOout, PCinc, PCout, IRin, Zin, Zhiout, Zloout,
         Yin, MARin, MDRin, MDRout, Read, write,
         Gra, Grb, Grc, Rout, Rin, BAout, CONin, OUT_portin,
         Strobe, IN_portout, Cout, PCin} = 0;
		  // Assert Run and Select Encode Enable
         Run = 1; s_d_en = 1;


        case (Present_state)
            T0: begin PCout = 1; MARin = 1; PCinc = 1; #15 PCout = 0; MARin = 0; PCinc = 0; end
            T1: begin Read = 1; MDRin = 1; #15 Read = 0; MDRin = 0; end
            T2: begin MDRout = 1; IRin = 1; PCin = 1; #15 MDRout = 0; IRin = 0; PCin = 0; end

            // ADD Instruction example
            ADD_T3: begin Grb = 1; Rout = 1; Yin = 1; #15 Grb = 0; Rout = 0; Yin = 0; end
            ADD_T4: begin Grc = 1; Zin = 1; #15 Grc = 0; Zin = 0; end
            ADD_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end
				
				// ADDI Instruction example
            ADDI_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
            ADDI_T4: begin Cout = 1; Rout = 1; Zin = 1; #15 Cout = 0; Rout = 0; Zin = 0; end
            ADDI_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end
				
				// ANDI
				ANDI_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
				ANDI_T4: begin Cout = 1; Zin = 1; #15 Zin = 0; Cout = 0; end
				ANDI_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra <= 0; Rin = 0; end

				// ORI
				ORI_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
				ORI_T4: begin Cout = 1; Zin = 1; #15 Zin = 0; Cout = 0; end
				ORI_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end
				
				// BR
				BR_T3: begin Gra = 1; Rout = 1; CONin = 1; #15 Gra = 0; Rout = 0; CONin = 0; end
				BR_T4: begin PCout = 1; Yin = 1; #15 PCout = 0; Yin = 0; end
				BR_T5: begin Cout = 1; Zin = 1; #15 Cout = 0; Zin = 0; end
				BR_T6: begin Zloout = 1; PCin = 1; #15 Zloout = 0; PCin = 0; end
				
				// JAL
				JAL_T3: begin PCinc = 1; PCout = 1; Yin = 1; #15 PCinc = 0; PCout = 0; Yin = 0; end
				JAL_T4: begin Gra = 1; Rout = 1; Zin = 1; #15 Gra = 0; Rout = 0; Zin = 0; end
				JAL_T5: begin Zloout = 1; PCin = 1; #15 Zloout = 0; PCin = 0; end

				// JR
				JR_T3: begin Gra = 1; Rout = 1; PCin = 1; #15 Gra = 0; Rout = 0; PCin = 0;  end

				// LDI
				LDI_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb = 0; BAout = 0; Yin = 0; end
				LDI_T4: begin Cout = 1; Zin = 1; #15 Cout = 0; Zin = 0; end
				LDI_T5: begin Zloout = 1; Gra = 1; Rin = 1; #15 Zloout = 0; Gra = 0; Rin = 0; end
				
            // LD Instruction
            LD_T3: begin Grb = 1; BAout = 1; Yin = 1; #15 Grb <= 0; BAout <= 0; Yin <= 0; end
            LD_T4: begin Cout = 1; Zin = 1; #15 Cout = 0; Zin = 0; end
            LD_T5: begin Zloout = 1; MARin = 1; #15 Zloout = 0; MARin = 0; end
            LD_T6: begin Read = 1; MDRin = 1; end
            LD_T7: begin #15 Read = 0; MDRin = 0; end
				LD_T8: begin MDRout = 1; Gra = 1; Rin = 1; #15 MDRout = 0; Gra = 0; Rin = 0; end

            // ST Instruction
            ST_T3: begin Gra = 1; BAout = 1; Yin = 1; #15 Gra = 0; BAout = 0; Yin = 0; end
            ST_T4: begin Cout = 1; Zin = 1; #15 Cout = 0; Zin = 0; end
            ST_T5: begin Zloout = 1; MARin = 1; end
            ST_T6: begin Grb = 1; Rout = 1; MDRin = 1; #15 Grb = 0; Rout = 0; MDRin = 0; end
            ST_T7: begin write = 1; #35 write = 0; end

            // Special
            MFHI_T3: begin HIout = 1; Gra = 1; Rin = 1; #15 HIout = 0; Gra = 0; Rin = 0; end
            MFLO_T3: begin LOout = 1; Gra = 1; Rin = 1; #15 LOout = 0; Gra = 0; Rin = 0; end
            IN_T3:   begin IN_portout = 1; Gra = 1; Rin = 1; #15 IN_portout = 0; Gra = 0; Rin = 0; end
            OUT_T3:  begin Gra = 1; Rout = 1; OUT_portin = 1; #15 Gra = 0; Rout = 0; OUT_portin = 0; end
            HALT_T3: begin Run = 0; end
        endcase
    end

endmodule
