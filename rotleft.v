module rotleft(
	input wire [31:0] A, 
	output wire [31:0] C
);

  assign C = {A[30:0], A[31]};
endmodule