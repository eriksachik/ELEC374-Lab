`timescale 1ns/10ps
module mux32to1 (
    input [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, 
    input [31:0] RHI, RLO, RZHI, RZLO, RPC, RMDR, RINPORT, RC,  // 24 data inputs
    input [4:0] Sel,      // 5-bit select signal (can select up to 32 options)
    output reg [31:0] Y          // Output
);

    always @(*) begin
        case (Sel)
            5'd0:  Y = R0;
            5'd1:  Y = R1;
            5'd2:  Y = R2;
            5'd3:  Y = R3;
            5'd4:  Y = R4;
            5'd5:  Y = R5;
            5'd6:  Y = R6;
            5'd7:  Y = R7;
            5'd8:  Y = R8;
            5'd9:  Y = R9;
            5'd10: Y = R10;
            5'd11: Y = R11;
            5'd12: Y = R12;
            5'd13: Y = R13;
            5'd14: Y = R14;
            5'd15: Y = R15;
            5'd16: Y = RHI;
            5'd17: Y = RLO;
            5'd18: Y = RZHI;
            5'd19: Y = RZLO;
            5'd20: Y = RPC;
            5'd21: Y = RMDR;
            5'd22: Y = RINPORT;
            5'd23: Y = RC;
            default: Y = 32'b0; // If Sel > 23, output 0
        endcase
    end
endmodule
