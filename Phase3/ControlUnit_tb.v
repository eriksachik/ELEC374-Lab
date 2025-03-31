`timescale 1ns/10ps
module ControlUnit_tb();
		reg clk,reset,stop;
		reg [31:0] inport_data;
		wire [31:0] outport_data;
		wire run;
	initial begin
		clk=0;
		reset=0;
		stop=0;
		inport_data=0;
		
	end
	always #10 clk=~clk;

	 
	 
	 
	 
	 
	 

datapath datapath(
	.clk(clk),.reset(reset),.stop(stop),
	.inport_data(inport_data),
	.outport_data(outport_data),
	.run(run)
);
endmodule
