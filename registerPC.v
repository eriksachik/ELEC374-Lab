`timescale 1ns/10ps 
module registerPC #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)(

	input clear, clock, increment, // no branch capability yet
	
	output wire [DATA_WIDTH_OUT-1:0]PCOut
	
);

reg [DATA_WIDTH_IN-1:0]q;

initial q = INIT;

always @ (posedge clock)

		begin 
		
			if (clear) begin
			
				q <= INIT;
				
			end
			
			else if (increment) begin
			
				q <= q + 1;
				
			end
			
		end
		
	assign PCOut = q[DATA_WIDTH_OUT-1:0];
	
endmodule