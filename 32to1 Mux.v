module mux32to1 (
    input [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, RHI, RLO, RZHI, RZLO, RPC, RMDR, RINPORT, RC,       // 24 data inputs
    input [4:0] Sel,      // 5-bit select signal (can select up to 32 options)
    output reg Y          // Output
);

    always @(*) begin
        case (Sel)
            5'd0:  R0 = D[0];
            5'd1:  R1 = D[1];
            5'd2:  R2 = D[2];
            5'd3:  R3 = D[3];
            5'd4:  R4 = D[4];
            5'd5:  R5 = D[5];
            5'd6:  R6 = D[6];
            5'd7:  R7 = D[7];
            5'd8:  R8 = D[8];
            5'd9:  R9 = D[9];
            5'd10: R10 = D[10];
            5'd11: R11 = D[11];
            5'd12: R12 = D[12];
            5'd13: R13 = D[13];
            5'd14: R14 = D[14];
            5'd15: R15 = D[15];
            5'd16: RHI = D[16];
            5'd17: RLO = D[17];
            5'd18: RZHI = D[18];
            5'd19: RZLO = D[19];
            5'd20: RPC = D[20];
            5'd21: RMDR = D[21];
            5'd22: RINPORT = D[22];
            5'd23: RC = D[23];
            default: Y = 1'b0; // If Sel > 23, output 0
        endcase
    end

endmodule
