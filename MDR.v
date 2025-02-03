module MDR(
    input wire clk,
    input wire clr,
    input wire [31:0] BusMuxOut,    
    input wire [31:0] MdataIn,      
    input wire MDRin,                
    output reg [31:0] MDROut
);
    always @(posedge clk or negedge clr)
    begin
        if (clr == 0)
            MDROut <= 0;                  
        else if (MDRin)
				MDROut <= Read ? Mdatain : BusMuxOut;
         
    end
endmodule
