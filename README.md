# 🧠 Single-Cycle RISC-V Processor Design

This repository contains the Verilog HDL implementation of a **Single-Cycle RISC-V processor**, designed and simulated using **Xilinx Vivado**. The processor supports essential RISC-V instructions and demonstrates a clear architectural breakdown of a basic CPU pipeline without pipelining stages.

---

## 🚀 Features

- Fully modular Verilog-based RISC-V CPU design
- Executes RV32I base integer instruction set (R, I, S, B-types)
- Separate **Instruction** and **Data Memory** modules
- ALU with arithmetic and logical operations
- Register file with read/write access
- Instruction decoding using a custom **Control Unit**
- 32-bit `program_counter` and `sign_extender` modules
- Parameterizable memory size
- Easily testable using `program.mem` file
- Simulated and verified using Vivado testbench (`CPU_tb.v`)

---

## 🛠️ Requirements

- **Vivado Design Suite** (tested with Vivado 2020.2 and above)
- Basic knowledge of Verilog and RISC-V ISA

---

## 📁 Directory Structure

```bash
├── .gitignore                                 # Ignores all Vivado-generated files
├── README.md                                  # You're reading it
├── program.mem                                # Memory initialization file (hex instructions)
├── Enhanced_single_cycle_risc-v_processor.xpr # Vivado project file
├── Enhanced_single_cycle_risc-v_processor.srcs/
│   ├── sources_1/
│   │   └── new/
│   │       ├── ALU.v
│   │       ├── CPU.v
│   │       ├── control_unit.v
│   │       ├── data_memory.v
│   │       ├── instruction_memory.v
│   │       ├── program_unit.v
│   │       ├── reg_file.v
│   │       └── sign_extender.v
│   └── sim_1/
│       └── new/
│           └── CPU_tb.v                       # Testbench
