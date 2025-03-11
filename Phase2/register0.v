`timescale 1ns/10ps
module register0 #(parameter DATA_WIDTH = 32, INIT = 32'h0)(
    input clear, clock, enable, 
    input BAout, 
    input [DATA_WIDTH-1:0] BusMuxOut, 
    input R0in, 
    output reg [DATA_WIDTH-1:0] BusMuxIn 
);
    reg [DATA_WIDTH-1:0] q; 

    initial begin
        q <= INIT;
    end

    always @(posedge clock) begin
        if (clear) begin
            q <= {DATA_WIDTH{1'b0}}; 
        end else if (R0in && enable) begin
            q <= BusMuxOut; 
        end
    end
	always @(*) begin
		 integer i;  // Declare loop variable
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin
            BusMuxIn[i] = q[i] & ~BAout; 
        end
	end

endmodule
