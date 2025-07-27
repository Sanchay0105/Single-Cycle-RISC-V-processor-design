`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 00:31:17
// Design Name: 
// Module Name: program_unit
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


module program_counter(
    input  wire        clk,
    input  wire        reset,
    input  wire        pc_src,       // "take branch" control (branch & zeroflag)
    input  wire [31:0] branch_addr,  // Computed branch target
    output reg  [31:0] pc_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'd0;
        end else if (pc_src) begin
            pc_out <= branch_addr;
        end else begin
            pc_out <= pc_out + 32'd4;
        end
    end

endmodule
