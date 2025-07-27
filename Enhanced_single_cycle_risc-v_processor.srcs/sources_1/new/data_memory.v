`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 00:34:26
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    input              clk,
    input              mem_read,
    input              mem_write,
    input      [31:0]  addr,
    input      [31:0]  write_data,
    output reg [31:0]  read_data
);
    // 1024 words = 4 KiB of word-addressable memory
    reg [31:0] memory_array [0:1023];

    // Read port (combinational)
    always @(*) begin
        if (mem_read) begin
            read_data = memory_array[addr[11:2]]; // word-aligned
        end else begin
            read_data = 32'd0;
        end
    end

    // Write port (synchronous)
    always @(posedge clk) begin
        if (mem_write) begin
            memory_array[addr[11:2]] <= write_data;
        end
    end

endmodule

