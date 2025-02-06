`timescale 1ns/10ps 
module or_tb(input a, input b);

	wire Rz[31:0];
	reg Ra[31:0];
	reg Rb[31:0];
	
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