module select_decode_logic(
	 input  wire [31:0] ir,
//    input  wire [11:0] addr,  // 4-bit address input
	 input  wire Gra, Grb, Grc, Rout, BAout, Rin, // Register Select
    input  wire enable, // Enable signal
    output reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
	 output reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
	 output [31:0] CsignExtended
    // 16-bit output
);

 	 wire [11:0] addr = ir[26:15];
	 wire [4:0] opcode = ir[31:27];
	 wire [18:0] C = ir[18:0];
	 wire CsignEx = ir[18];
//	 wire [31:0] CsignExtended;
	
	 reg outSig;
	 reg [3:0] RaMid, RbMid, RcMid, decIn;
	 reg  [15:0] out;
	 wire [3:0] GraFour = {Gra, Gra, Gra, Gra};
	 wire [3:0] GrbFour = {Grb, Grb, Grb, Grb};
	 wire [3:0] GrcFour = {Grc, Grc, Grc, Grc};
	 
    always @(*) begin
        if (enable) begin
		  
				R0in = 0; R1in = 0; R2in = 0; R3in = 0; R4in = 0; R5in = 0; R6in = 0; R7in = 0; R8in = 0; R9in = 0; R10in = 0; R11in = 0; R12in = 0; R13in = 0; R14in = 0; R15in = 0;
				R0out = 0; R1out = 0; R2out = 0; R3out = 0; R4out = 0; R5out = 0; R6out = 0; R7out = 0; R8out = 0; R9out = 0; R10out = 0; R11out = 0; R12out = 0; R13out = 0; R14out = 0; R15out = 0;
				RaMid = GraFour & addr[11:8];
				RbMid = GrbFour & addr[7:4];
				RcMid = GrcFour & addr[3:0];
				decIn = RaMid | RbMid | RcMid;
            out = 16'b0;         // Default all outputs to 0
            out[decIn] = 1'b1;    // Set the selected output to 1
				outSig = Rout | BAout;
				
				case(out)
					16'h0001: begin
									if(Rin == 1)
										R0in <= 1;
									else if(outSig == 1)
										R0out <= 1;
								end
				   16'h0002: begin
									if(Rin == 1)
										R1in <= 1;
									else if(outSig == 1)
										R1out <= 1;
								end
					16'h0004: begin
									if(Rin == 1)
										R2in <= 1;
									else if(outSig == 1)
										R2out <= 1;
								end
				   16'h0008: begin
									if(Rin == 1)
										R3in <= 1;
									else if(outSig == 1)
										R3out <= 1;
								end
					16'h0010: begin
									if(Rin == 1)
										R4in <= 1;
									else if(outSig == 1)
										R4out <= 1;
								end
				   16'h0020: begin
									if(Rin == 1)
										R5in <= 1;
									else if(outSig == 1)
										R5out <= 1;
								end
					16'h0040: begin
									if(Rin == 1)
										R6in <= 1;
									else if(outSig == 1)
										R6out <= 1;
								end
				   16'h0080: begin
									if(Rin == 1)
										R7in <= 1;
									else if(outSig == 1)
										R7out <= 1;
								end
					16'h0100: begin
									if(Rin == 1)
										R8in <= 1;
									else if(outSig == 1)
										R8out <= 1;
								end
				   16'h0200: begin
									if(Rin == 1)
										R9in <= 1;
									else if(outSig == 1)
										R9out <= 1;
								end
					16'h0400: begin
									if(Rin == 1)
										R10in <= 1;
									else if(outSig == 1)
										R10out <= 1;
								end
				   16'h0800: begin
									if(Rin == 1)
										R11in <= 1;
									else if(outSig == 1)
										R11out <= 1;
								end
					16'h1000: begin
									if(Rin == 1)
										R12in <= 1;
									else if(outSig == 1)
										R12out <= 1;
								end
				   16'h2000: begin
									if(Rin == 1)
										R13in <= 1;
									else if(outSig == 1)
										R13out <= 1;
								end
					16'h4000: begin
									if(Rin == 1)
										R14in <= 1;
									else if(outSig == 1)
										R14out <= 1;
								end
				   16'h8000: begin
									if(Rin == 1)
										R15in <= 1;
									else if(outSig == 1)
										R15out <= 1;
								end
					default: ;
				endcase
				
        end else begin
            out = 16'b0;         // If disabled, all outputs remain 0
				
				R0in = 0; R1in = 0; R2in = 0; R3in = 0; R4in = 0; R5in = 0; R6in = 0; R7in = 0; R8in = 0; R9in = 0; R10in = 0; R11in = 0; R12in = 0; R13in = 0; R14in = 0; R15in = 0;
				R0out = 0; R1out = 0; R2out = 0; R3out = 0; R4out = 0; R5out = 0; R6out = 0; R7out = 0; R8out = 0; R9out = 0; R10out = 0; R11out = 0; R12out = 0; R13out = 0; R14out = 0; R15out = 0;
				
				RaMid = 0; RbMid = 0; RcMid = 0; decIn = 0; outSig = 0;
        end
    end
	 
	 assign CsignExtended = {{13{CsignEx}}, C};

endmodule