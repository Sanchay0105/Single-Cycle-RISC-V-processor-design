`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 00:26:45
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module arithmetic_logic_unit(
    input  [31:0] operand1,
    input  [31:0] operand2,
    input  [3:0]  alu_op,
    output reg [31:0] result,
    output reg        zeroflag
);

    always @(*) begin
        case (alu_op)
            4'b0000: begin // AND
                result   = operand1 & operand2;
                zeroflag = (result == 32'd0) ? 1'b1 : 1'b0;
            end

            4'b0001: begin // OR
                result   = operand1 | operand2;
                zeroflag = (result == 32'd0) ? 1'b1 : 1'b0;
            end

            4'b0010: begin // ADD
                result   = operand1 + operand2;
                zeroflag = (result == 32'd0) ? 1'b1 : 1'b0;
            end

            4'b0110: begin // SUB
                result   = operand1 - operand2;
                zeroflag = (result == 32'd0) ? 1'b1 : 1'b0;
            end

            4'b0011: begin // XOR
                result   = operand1 ^ operand2;
                zeroflag = (result == 32'd0) ? 1'b1 : 1'b0;
            end

            4'b0100: begin // SLL (logical left)
                result   = operand1 << operand2[4:0];
                zeroflag = (result == 32'd0) ? 1'b1 : 1'b0;
            end

            4'b0101: begin // SRL (logical right)
                result   = operand1 >> operand2[4:0];
                zeroflag = (result == 32'd0) ? 1'b1 : 1'b0;
            end

            4'b0111: begin // SRA (arithmetic right)
                result   = operand1 >>> operand2[4:0];
                zeroflag = (result == 32'd0) ? 1'b1 : 1'b0;
            end

            4'b1000: begin // SLT (signed)
                result   = ($signed(operand1) < $signed(operand2)) ? 32'd1 : 32'd0;
                zeroflag = (result == 32'd0) ? 1'b0 : 1'b1; 
                // For SLT, if result=1 then "less than" is true → zero_flag=1 means branch-taken 
            end

            4'b1001: begin // SLTU (unsigned)
                result   = (operand1 < operand2) ? 32'd1 : 32'd0;
                zeroflag = (result == 32'd0) ? 1'b0 : 1'b1;
            end

            // Branch-comparison operations: drive result = 1 if condition true,
            // and set zeroflag = 1 when result == 1 (so that CPU's "branch & zeroflag" works)
            4'b1010: begin // BEQ
                result   = (operand1 == operand2) ? 32'd1 : 32'd0;
                zeroflag = (result == 32'd1) ? 1'b1 : 1'b0;
            end

            4'b1011: begin // BNE
                result   = (operand1 != operand2) ? 32'd1 : 32'd0;
                zeroflag = (result == 32'd1) ? 1'b1 : 1'b0;
            end

            4'b1100: begin // BLT (signed)
                result   = ($signed(operand1) < $signed(operand2)) ? 32'd1 : 32'd0;
                zeroflag = (result == 32'd1) ? 1'b1 : 1'b0;
            end

            4'b1101: begin // BGE (signed)
                result   = ($signed(operand1) >= $signed(operand2)) ? 32'd1 : 32'd0;
                zeroflag = (result == 32'd1) ? 1'b1 : 1'b0;
            end

            4'b1110: begin // BLTU (unsigned)
                result   = (operand1 < operand2) ? 32'd1 : 32'd0;
                zeroflag = (result == 32'd1) ? 1'b1 : 1'b0;
            end

            4'b1111: begin // BGEU (unsigned)
                result   = (operand1 >= operand2) ? 32'd1 : 32'd0;
                zeroflag = (result == 32'd1) ? 1'b1 : 1'b0;
            end

            default: begin
                result   = 32'd0;
                zeroflag = 1'b0;
            end
        endcase
    end

endmodule

