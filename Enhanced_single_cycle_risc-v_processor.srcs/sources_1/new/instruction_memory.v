`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 00:29:21
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(
    input  [31:0] addr,
    output [31:0] instruction
);
    reg [31:0] memory [0:255];  // 256 words of instruction memory

`ifndef SYNTHESIS
initial begin
    $readmemh("program.mem", memory);
    $display("Instruction at address 0: %h", memory[0]);
end
`endif

    // Word-aligned: use addr[9:2] (bits [1:0] are zero on a 32-bit PC that increments by 4)
    assign instruction = memory[addr[9:2]];

endmodule

