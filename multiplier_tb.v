
`timescale 1ns/10ps 
module multiplier_tb(input a, output b);

	wire[63:0] Rz;
	reg[31:0] Ra;
	reg[31:0] Rb;
	
	multiplier MUL(Ra, Rb, Rz);
	
		initial
				begin
			Ra = 32'hFFFFFFFF;
			Rb = 32'h00000000;
			#20
			Ra = 32'h0000FF00;
			Rb = 32'h000FFF0F;
			#20
			Ra = 32'FFFFFFFFF;
			Rb = 32'h000FFF0F;
			
				end
endmodule