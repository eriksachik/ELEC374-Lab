module NOP_Controller (
    input clk,
    input reset,
    output reg [2:0] state,
    output reg IRWrite,
    output reg PCWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [1:0] ALUOp,
    output reg PCSource
);

// Timing states
parameter T0 = 3'd0,
          T1 = 3'd1,
          T2 = 3'd2,
          T3 = 3'd3;

always @(posedge clk or posedge reset) begin
    if (reset)
        state <= T0;
    else begin
        case (state)
            T0: state <= T1;
            T1: state <= T2;
            T2: state <= T3;
            T3: state <= T0; // Loop back or transition depending on next instruction
        endcase
    end
end

always @(*) begin
    // Default all signals to 0 (NOP = no control signals active)
    IRWrite   = 0;
    PCWrite   = 0;
    MemRead   = 0;
    MemWrite  = 0;
    ALUSrcA   = 0;
    ALUSrcB   = 2'b00;
    ALUOp     = 2'b00;
    PCSource  = 0;

    case (state)
        T0: begin
            // Instruction Fetch phase (optional for NOP)
            MemRead = 1;
            IRWrite = 1;
            ALUSrcB = 2'b01; // Set ALU to add PC + 4
            ALUOp   = 2'b00;
            PCWrite = 1;
        end
        T1: begin
            // Decode phase (NOP does nothing)
        end
        T2: begin
            // No execute
        end
        T3: begin
            // No memory/write back
        end
    endcase
end

endmodule
