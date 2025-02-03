// and datapath_tb.v file: <This is the filename> 
'timescale 1ns/10ps 
module and_tb(input a, output b);

	wire[31:0] Rz;
	wire[31:0] Ra;
	wire[31:0] Rb;
	
	and_gate AND(Rz, Ra, Rb);
	
		intial
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