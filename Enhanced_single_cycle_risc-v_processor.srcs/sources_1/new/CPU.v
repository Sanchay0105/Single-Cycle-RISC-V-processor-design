`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 00:26:05
// Design Name: 
// Module Name: CPU
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


module CPU(
    input  wire clk,
    input  wire reset
);
    // ==== Wires & Regs ====
    wire [31:0] pc;
    wire [31:0] instruction;
    wire [6:0]  opcode;
    wire [2:0]  funct3;
    wire [6:0]  funct7;
    wire [4:0]  rs1, rs2, rd;
    wire [31:0] read_data1, read_data2;
    wire [31:0] imm_ext;
    wire [2:0]  imm_sel;           // selects I/S/B/U/J
    wire [3:0]  alu_op;
    wire [31:0] alu_operand2;
    wire [31:0] alu_result;
    wire        zero_flag;         // from ALU (high when branch condition true)
    wire        reg_write;
    wire        mem_read;
    wire        mem_write;
    wire        alu_src;
    wire        mem_to_reg;
    wire        branch;

    // ==== 1. Program Counter ====
    wire [31:0] pc_plus4 = pc + 32'd4;

    // We will compute the branch target as pc_plus4 + imm_ext
    wire [31:0] branch_target = pc_plus4 + imm_ext;

    // pc_src should be high only if (branch == 1) AND (zero_flag == 1)
    wire pc_src = branch & zero_flag;

    program_counter PC_inst (
        .clk        (clk),
        .reset      (reset),
        .pc_src     (pc_src),
        .branch_addr(branch_target),
        .pc_out     (pc)
    );

    // ==== 2. Instruction Memory ====
    instruction_memory IM_inst (
        .addr        (pc),
        .instruction (instruction)
    );

    // ==== 3. Instruction Decode ====
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    // ==== 4. Control Unit ====
    control_unit CU_inst (
        .opcode    (opcode),
        .funct3    (funct3),
        .funct7    (funct7),
        .alu_op    (alu_op),
        .reg_write (reg_write),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .alu_src   (alu_src),
        .branch    (branch),
        .mem_to_reg(mem_to_reg)
    );

    // ==== 5. Register File ====
    reg_file RF_inst (
        .clk         (clk),
        .reset       (reset),
        .read_reg1   (rs1),
        .read_reg2   (rs2),
        .write_reg   (rd),
        .write_data  ((mem_to_reg) ? mem_read_data : alu_result),
        .reg_write   (reg_write),
        .read_data1  (read_data1),
        .read_data2  (read_data2)
    );

    // ==== 6. Immediate Generator ====
    // Decide imm_sel (I=0, S=1, B=2, U=3, J=4)
    // This always_comb can be extended for JAL, JALR, LUI, AUIPC if needed.
    reg [2:0] imm_type_sel;
    always @(*) begin
        case (opcode)
            7'b0010011: imm_type_sel = 3'd0; // I-arith (ADDI, ANDI, …)
            7'b0000011: imm_type_sel = 3'd0; // I-load    (LW)
            7'b0100011: imm_type_sel = 3'd1; // S-store   (SW)
            7'b1100011: imm_type_sel = 3'd2; // B-branch  (BEQ, BNE, …)
            // If you add LUI (0110111) or AUIPC (0010111): imm_type_sel = 3'd3
            // If you add JAL  (1101111):           imm_type_sel = 3'd4
            default:      imm_type_sel = 3'd0; 
        endcase
    end

    sign_extender SE_inst (
        .instruction(instruction),
        .imm_type   (imm_type_sel),
        .imm_out    (imm_ext)
    );

    // ==== 7. ALU Operand MUX ====
    assign alu_operand2 = (alu_src) ? imm_ext : read_data2;

    // ==== 8. ALU ====
    arithmetic_logic_unit ALU_inst (
        .operand1   (read_data1),
        .operand2   (alu_operand2),
        .alu_op     (alu_op),
        .result     (alu_result),
        .zeroflag   (zero_flag)
    );

    // ==== 9. Data Memory ====
    //wire [31:0] mem_read_data;
    data_memory DM_inst (
        .clk        (clk),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .addr       (alu_result),
        .write_data (read_data2),
        .read_data  (mem_read_data)
    );

    // ==== 10. Write-back MUX ====
    // (Already integrated into the RF instantiation's write_data port)

endmodule

