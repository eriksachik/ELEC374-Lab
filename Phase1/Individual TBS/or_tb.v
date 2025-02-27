`timescale 1ns/10ps 
module or_tb(input a, input b);

	wire [31:0] Rz;
	reg [31:0] Ra;
	reg [31:0] Rb;
	
	or_gate OR(Ra, Rb, Rz);
	
		initial
				begin
				
			Ra = 32'h00000000;
			Rb = 32'hFFF000FF;
			#20
			Ra = 32'hFFFFFFFF;
			Rb = 32'hFFFFFFFF;
			#20
			Ra = 32'hFFFFFFFF;
			Rb = 32'hFFF000FF;
					
					end
endmodule
