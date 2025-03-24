`timescale 1ns/10ps
module control_unit (
    output reg PCout, ZHighout, ZLowout, MDRout, MARin, PCin, MDRin, IRin, Yin, IncPC, Read, HIin, LOin, HIout, LOout, ZHighIn, ZLowIn, Cout, RAM_write,
    output reg Gra, Grb, Grc, Rin, Rout, BAout, CONin, enableInputPort, enableOutPort, InPortout, Run,
    input [31:0] IR,
    input Clock, Reset, Stop
);

    // State Encoding
    parameter Reset_state = 8'd0, T0 = 8'd1, T1 = 8'd2, T2 = 8'd3, 
              ADD_T3 = 8'd4, ADD_T4 = 8'd5, ADD_T5 = 8'd6,
              LD_T3 = 8'd7, LD_T4 = 8'd8, LD_T5 = 8'd9, LD_T6 = 8'd10, LD_T7 = 8'd11,
              ST_T3 = 8'd12, ST_T4 = 8'd13, ST_T5 = 8'd14, ST_T6 = 8'd15, ST_T7 = 8'd16,
              MFHI_T3 = 8'd17, MFLO_T3 = 8'd18, IN_T3 = 8'd19, OUT_T3 = 8'd20, HALT_T3 = 8'd21;

    reg [7:0] Present_state = Reset_state;

    always @(posedge Clock or posedge Reset or posedge Stop) begin
        if (Reset) Present_state <= Reset_state;
        else if (Stop) Present_state <= HALT_T3;
        else begin
            case (Present_state)
                Reset_state: Present_state <= T0;
                T0: Present_state <= T1;
                T1: Present_state <= T2;
                T2: begin
                    case (IR[31:27])
                        5'b00011: Present_state <= ADD_T3;
                        5'b00000: Present_state <= LD_T3;
                        5'b00010: Present_state <= ST_T3;
                        5'b10111: Present_state <= MFHI_T3;
                        5'b11000: Present_state <= MFLO_T3;
                        5'b10101: Present_state <= IN_T3;
                        5'b10110: Present_state <= OUT_T3;
                        5'b11010: Present_state <= HALT_T3;
                        default: Present_state <= T0;
                    endcase
                end
                ADD_T3: Present_state <= ADD_T4;
                ADD_T4: Present_state <= ADD_T5;
                ADD_T5: Present_state <= T0;
                LD_T3: Present_state <= LD_T4;
                LD_T4: Present_state <= LD_T5;
                LD_T5: Present_state <= LD_T6;
                LD_T6: Present_state <= LD_T7;
                LD_T7: Present_state <= T0;
                ST_T3: Present_state <= ST_T4;
                ST_T4: Present_state <= ST_T5;
                ST_T5: Present_state <= ST_T6;
                ST_T6: Present_state <= ST_T7;
                ST_T7: Present_state <= T0;
                MFHI_T3, MFLO_T3, IN_T3, OUT_T3, HALT_T3: Present_state <= T0;
                default: Present_state <= Reset_state;
            endcase
        end
    end

    always @(*) begin
        // Default deassert all signals
        {PCout, ZHighout, ZLowout, MDRout, MARin, PCin, MDRin, IRin, Yin, IncPC, Read, HIin, LOin, HIout, LOout, ZHighIn, ZLowIn, Cout, RAM_write, Gra, Grb, Grc, Rin, Rout, BAout, CONin, enableInputPort, enableOutPort, InPortout} = 0;
        Run = 1;

        case (Present_state)
            T0: begin PCout = 1; MARin = 1; IncPC = 1; end
            T1: begin Read = 1; MDRin = 1; end
            T2: begin MDRout = 1; IRin = 1; PCin = 1; end

            // ADD Instruction example
            ADD_T3: begin Grb = 1; Rout = 1; Yin = 1; end
            ADD_T4: begin Grc = 1; Rout = 1; ZLowIn = 1; ZHighIn = 1; end
            ADD_T5: begin ZLowout = 1; Gra = 1; Rin = 1; end

            // LD Instruction
            LD_T3: begin Grb = 1; BAout = 1; Yin = 1; end
            LD_T4: begin Cout = 1; ZLowIn = 1; end
            LD_T5: begin ZLowout = 1; MARin = 1; end
            LD_T6: begin Read = 1; MDRin = 1; end
            LD_T7: begin MDRout = 1; Gra = 1; Rin = 1; end

            // ST Instruction
            ST_T3: begin Grb = 1; BAout = 1; Yin = 1; end
            ST_T4: begin Cout = 1; ZLowIn = 1; end
            ST_T5: begin ZLowout = 1; MARin = 1; end
            ST_T6: begin Gra = 1; Rout = 1; MDRin = 1; end
            ST_T7: begin MDRout = 1; RAM_write = 1; end

            // Special
            MFHI_T3: begin HIout = 1; Gra = 1; Rin = 1; end
            MFLO_T3: begin LOout = 1; Gra = 1; Rin = 1; end
            IN_T3: begin InPortout = 1; Gra = 1; Rin = 1; end
            OUT_T3: begin Gra = 1; Rout = 1; enableOutPort = 1; end
            HALT_T3: begin Run = 0; end
        endcase
    end

endmodule
