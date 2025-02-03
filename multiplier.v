module multiplier (
	input clk,
	input reset
	input [31:0] Mplr,
	input [31:0] Mcnd,
	output reg [63:0] Y);
	
	assign Y = 0; //dont know if this is right
	
	reg [8:1] CONSTANT;
	
	assign CONSTANT[0] = 0;
	assign CONSTANT[1] = 1;
	assign CONSTANT[2] = 1;
	assign CONSTANT[3] = 2;
	assign CONSTANT[4] = -2;
	assign CONSTANT[5] = -1;
	assign CONSTANT[6] = -1;
	assign CONSTANT[7] = 0;
	
	integer index;
	reg [63:0] temp;
	reg [63:0] partial_sum;
	reg [2:0] booth_code;
	
	integer i;
	always@(posedge clk or posedge reset) begin
		
		if (reset) begin
			Y <= 64'b0; // Reset the output
			partial_sum <= 64'b0;
      end else begin
			partial_sum <= 64'b0; //partial sum is cleared each clock cycle
			
			for (i = 0; i < 32; i = i + 2) begin
				
				booth_code = {Mplr[i+1], Mplr[i], (i == 0 ? 1'b0 : Mplr[i-1])};
				
				case (booth_code)
					3'b001, 3'b010: temp = Mcnd<<i;
					3'b011: temp = (Mcnd<<(i+1));
					3'b100: temp = (~(Mcnd<<(i+1))+1);
					3'b101, 3'b110: temp = ~(Mcnd<<i) + 1;
					default: temp = 64'b0;
				endcase
						// Accumulate the partial product
                partial_sum = partial_sum + temp;
			end

            // Update the output
            Y <= partial_sum;
		end
    end
endmodule
