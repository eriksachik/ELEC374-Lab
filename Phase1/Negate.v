`timescale 1ns/10ps 
module Negate(
	input wire [31:0] A, 
	output wire [31:0] C
);

assign C = ~A + 1;
endmodule
