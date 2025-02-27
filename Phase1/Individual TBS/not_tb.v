
`timescale 1ns/10ps 
module not_tb(input a, output b);

	wire[31:0] Rz;
	reg[31:0] Ra;
	
	not_gate NOT(Ra, Rz);
	
		initial
				begin
			Ra = 32'h00000000;
			#20
			Ra = 32'hFFFFFFFF;
			#20
			Ra = 32'hFFFFFFFF;
			
				end
endmodule
