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

    // State Definitions
    parameter  Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110;
    reg  [3:0] Present_State = Default;

    // Instantiate the datapath
    new_datapath DUT(
        .HIin(HIin), .HIout(HIout), .LOin(LOin), .LOout(LOout), .PCinc(PCinc), .PCout(PCout), 
        .IRin(IRin), .Zin(Zin), .Zhiout(Zhiout), .Zloout(Zloout), .Yin(Yin), .MARin(MARin), 
        .MDRin(MDRin), .MDRout(MDRout), .Read(Read), .Clock(Clock), .GlobalReset(GlobalReset),
        .ALUControl(ALUControl), .PCinput(PCinput), .PCin(PCin),
        .Zero(Zero), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .HI(HI), .LO(LO), .IR(IR), .PC(PC), .BusMuxOut(BusMuxOut), .Z(Z), .Y(Y),
        .R4(R4), .R5(R5), .R6(R6), .R7(R7), .R8(R8), .R9(R9), .R10(R10), .R11(R11), .R12(R12), .R13(R13), .R14(R14), .R15(R15),
        .Cout(Cout), .write(write), .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rout(Rout), .Rin(Rin), .BAout(BAout), .s_d_en(s_d_en), 
        .CONin(CONin), .CONout(CONout), .OUT_portin(OUT_portin), .Strobe(Strobe), .IN_portout(IN_portout)
    );

    // Clock signal generation
    initial
    begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // State machine to define each step of JAL operation
    always @(posedge Clock)
    begin
        case(Present_State)
            Default: Present_State = T0;
            T0: Present_State = T1;
            T1: Present_State = T2;
            T2: Present_State = T3;
            T3: Present_State = T4;
            T4: Present_State = T5;
            default: Present_State = Default;
        endcase
    end

    // Control signal behavior based on the current state
    always @(Present_State) begin
        case (Present_State)
            // Default state
            Default: begin
                // Deassert all control signals
                HIin <= 0; HIout <= 0; LOin <= 0; LOout <= 0; PCinc <= 0; PCout <= 0; 
                IRin <= 0; Zin <= 0; Zhiout <= 0; Zloout <= 0; Yin <= 0; MARin <= 0; MDRin <= 0; MDRout <= 0; Read <= 0; GlobalReset <= 0;
                Cout <= 0; IN_portout <= 0;
                Gra <= 0; Grb <= 0; Grc <= 0; Rout <= 0; BAout <= 0; Rin <= 0;
                s_d_en <= 1; CONin <= 0; OUT_portin <= 0; Strobe <= 0;
                write <= 0; PCin <= 0; PCinc<=0;
					 
					 force R5 = 32'h0000000E;
            end

            // Instruction fetch cycle (JAL-specific)
            T0: begin
                // Fetch instruction: Set up MAR, Read memory, fetch instruction into MDR
                PCout <= 1; MARin <= 1; PCinc <= 1; 
                #15 PCout <= 0; MARin <= 0; PCinc <= 0;
            end
            T1: begin
                // Fetch the instruction (load it to MDR)
                Read <= 1; MDRin <= 1;
                #15 Read <= 0; MDRin <= 0;
            end
            T2: begin
                // Transfer instruction from MDR to IR (IR = instruction register)
                MDRout <= 1; IRin <= 1; PCinc <= 1;
                #15 MDRout <= 0; IRin <= 0;PCinc <= 0;
            end

            // JAL Specific Steps
            T3: begin
                // Store the return address (PC+4) into R31 (for jal, we use $ra register which is R31)
//                Gra <= 1; Rout <= 1; // Store return address (PC+4) into R31    ALUcontrol <= 5'b00011;
                 PCout <= 1; Yin <= 1; 
                #15 PCout <= 0; Yin <= 0;
            end
            T4: begin
                // Set PC to the target address from the instruction
//                PCin <= 1; // Jump to the target address
//                #15 PCin <= 0;
						Gra <= 1; Rout <= 1; ALUControl <= 5'b00011; Zin <= 1;
						#15 Gra <= 0; Rout <= 0;Zin <= 0;
						
            end
            T5: begin
                // End the instruction (no further control signals needed)
                Zloout<=1; PCin <= 1;
                #15 Zloout<=0; PCin <= 0;
            end

            default: begin
                Present_State <= Default;
            end
        endcase
    end

endmodule
