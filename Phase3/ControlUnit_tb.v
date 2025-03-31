`timescale 1ns/10ps
module control_unit_tb();
		reg clk,reset,stop;
	reg [31:0] IN_data;
	wire [31:0] OUT;
		wire run;
	initial begin
		clk=0;
		reset=0;
		stop=0;
		IN_data=0;
		
	end
	always #10 clk=~clk;

	 
	 
	 
	 
	 
	 

datapath datapath(
	.clk(clk),.reset(reset),.stop(stop),
	.inport_data(IN_data),
	.outport_data(OUT),
	.run(run)
);
endmodule
