`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 00:33:33
// Design Name: 
// Module Name: sign_extender
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


module sign_extender(
    input  [31:0] instruction,  // full 32-bit instruction
    input  [2:0]  imm_type,     // 0=I, 1=S, 2=B, 3=U, 4=J
    output reg [31:0] imm_out
);

    always @(*) begin
        case (imm_type)
            // I-type immediate: bits [31:20]
            3'd0: begin
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
            end

            // S-type immediate: bits [31:25] concatenated with [11:7]
            3'd1: begin
                imm_out = {{20{instruction[31]}},
                           instruction[31:25],
                           instruction[11:7]};
            end

            // B-type immediate: imm[12]=inst[31], imm[11]=inst[7],
            // imm[10:5]=inst[30:25], imm[4:1]=inst[11:8], imm[0]=0
            3'd2: begin
                imm_out = {{19{instruction[31]}},
                           instruction[31],
                           instruction[7],
                           instruction[30:25],
                           instruction[11:8],
                           1'b0};
            end

            // U-type immediate: bits [31:12] << 12
            3'd3: begin
                imm_out = {instruction[31:12], 12'b0};
            end

            // J-type immediate: imm[20]=inst[31], imm[19:12]=inst[19:12],
            // imm[11]=inst[20], imm[10:1]=inst[30:21], imm[0]=0
            3'd4: begin
                imm_out = {{11{instruction[31]}},
                           instruction[31],
                           instruction[19:12],
                           instruction[20],
                           instruction[30:21],
                           1'b0};
            end

            default: begin
                imm_out = 32'd0;
            end
        endcase
    end

endmodule

