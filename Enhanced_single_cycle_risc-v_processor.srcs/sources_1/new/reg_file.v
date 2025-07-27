`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 00:32:19
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input              clk,
    input              reset,
    input      [4:0]   read_reg1,
    input      [4:0]   read_reg2,
    input      [4:0]   write_reg,
    input      [31:0]  write_data,
    input              reg_write,
    output reg [31:0]  read_data1,
    output reg [31:0]  read_data2
);

    // 32 registers of 32 bits each
    reg [31:0] registers [0:31];

    integer i;

    // Read ports (combinational)
    always @(*) begin
        read_data1 = registers[read_reg1];
        read_data2 = registers[read_reg2];
    end

    // Write port + reset logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize all registers to zero on reset
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else begin
            if (reg_write && (write_reg != 5'd0)) begin
                registers[write_reg] <= write_data;
            end
            registers[0] <= 32'd0; // x0 is always zero
        end
    end

endmodule

