`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 00:30:16
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output reg [3:0] alu_op,
    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       alu_src,
    output reg       branch,
    output reg       mem_to_reg
);

    always @(*) begin
        // Default all control signals off / zero
        alu_op     = 4'b0000;
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        alu_src    = 1'b0;
        branch     = 1'b0;
        mem_to_reg = 1'b0;

        case (opcode)
            // R-TYPE: OP IMMED = 0110011
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0; // second operand comes from register

                case ({funct7, funct3})
                    10'b0000000_000: alu_op = 4'b0010; // ADD
                    10'b0100000_000: alu_op = 4'b0110; // SUB
                    10'b0000000_111: alu_op = 4'b0000; // AND
                    10'b0000000_110: alu_op = 4'b0001; // OR
                    10'b0000000_100: alu_op = 4'b0011; // XOR
                    10'b0000000_001: alu_op = 4'b0100; // SLL
                    10'b0000000_101: alu_op = 4'b0101; // SRL
                    10'b0100000_101: alu_op = 4'b0111; // SRA
                    default:          alu_op = 4'b1111; // illegal/unused
                endcase
            end

            // I-TYPE Arithmetic (ADDI, ANDI, ORI, XORI) → opcode=0010011
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1; // second operand = immediate
                case (funct3)
                    3'b000: alu_op = 4'b0010; // ADDI
                    3'b111: alu_op = 4'b0000; // ANDI
                    3'b110: alu_op = 4'b0001; // ORI
                    3'b100: alu_op = 4'b0011; // XORI
                    default:alu_op = 4'b1111;
                endcase
            end

            // LOAD (LW) → opcode=0000011
            7'b0000011: begin
                reg_write  = 1'b1;  // write loaded data into rd
                mem_read   = 1'b1;
                mem_write  = 1'b0;
                alu_src    = 1'b1;   // address = rs1 + imm
                alu_op     = 4'b0010; // use ADD for address computation
                mem_to_reg = 1'b1;   // write-back: from memory
            end

            // STORE (SW) → opcode=0100011
            7'b0100011: begin
                mem_read   = 1'b0;
                mem_write  = 1'b1;
                alu_src    = 1'b1;   // address = rs1 + imm
                alu_op     = 4'b0010; // ADD
                reg_write  = 1'b0;
                mem_to_reg = 1'b0;   // no write back
            end

            // BRANCH (BEQ, BNE, BLT, BGE, BLTU, BGEU) → opcode=1100011
            7'b1100011: begin
                branch  = 1'b1;
                alu_src = 1'b0;  // both operands come from registers

                case (funct3)
                    3'b000: alu_op = 4'b1010; // BEQ
                    3'b001: alu_op = 4'b1011; // BNE
                    3'b100: alu_op = 4'b1100; // BLT
                    3'b101: alu_op = 4'b1101; // BGE
                    3'b110: alu_op = 4'b1110; // BLTU
                    3'b111: alu_op = 4'b1111; // BGEU
                    default: alu_op = 4'b1111;
                endcase
            end

            default: begin
                // all control = 0
            end
        endcase
    end

endmodule

