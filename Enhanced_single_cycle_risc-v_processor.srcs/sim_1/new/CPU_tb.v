`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 11:47:09
// Design Name: 
// Module Name: CPU_tb
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

module CPU_tb;

  // Signals
  reg clk;
  reg reset;

  // Instantiate the CPU
  CPU a1 (
    .clk(clk),
    .reset(reset)
  );

  // Clock generation: 10 ns clock period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset pulse
  initial begin
    reset = 1;   // assert reset
    #20;
    reset = 0;   // deassert reset
    #40;
    reset = 1;   // assert reset
  end

  // Optional: Monitor key signals
  //initial begin
   // $monitor("Time = %0t | PC = %h", $time, a1.PC);
  //end

  // Optional: Load instruction memory (if applicable)
  // If your instruction memory is a module and loads from program.mem internally, you don't need this.
  // But if you're using $readmemh in testbench, uncomment below:
  /*
  initial begin
    $readmemh("program.mem", a1.instruction_memory.memory);
  end
  */

  // Run simulation for a fixed time
  initial begin
    #1000;  // Run for 1000 ns
    $finish;
  end

endmodule

