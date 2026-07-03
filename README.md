# 8Bit-Computer

A fully functional 8-bit CPU built from scratch in Verilog HDL. Features ALU (8 ops + carry), Reg A/B, 256×8 RAM with zero-latency combinational read, program counter, MAR, IR, and output register — all connected via a shared tri-stated bus. Simulated with Icarus Verilog and GTKWave.

# 🖥️ 8-Bit CPU — Built from Scratch in Verilog

> A fully functional 8-bit CPU designed and implemented in Verilog HDL, featuring a complete datapath with an ALU, register file, RAM, program counter, memory address register, instruction register, and output display — all connected through a shared tri-stated bus architecture. Simulated with Icarus Verilog and GTKWave.

---

## 📑 Table of Contents

- [1. 📌 Project Highlights](#1--project-highlights)
- [2. 🧠 How This Computer Works](#2--how-this-computer-works)
  - [The Fetch–Execute Cycle](#the-fetchexecute-cycle)
  - [The Shared Bus](#the-shared-bus)
- [3. 📁 Project Structure](#3--project-structure)
- [4. 📂 Module Details](#4--module-details)
  - [ALU_8Bit.v — Arithmetic Logic Unit](#alu_8bitv--arithmetic-logic-unit)
  - [Reg_A.v — General Purpose Register A](#reg_av--general-purpose-register-a)
  - [Reg_B.v — General Purpose Register B](#reg_bv--general-purpose-register-b)
  - [output_Reg.v — Output Display Register](#output_regv--output-display-register)
  - [MAR.v — Memory Address Register](#marv--memory-address-register)
  - [PC.v — Program Counter](#pcv--program-counter)
  - [RAM.v — Random Access Memory](#ramv--random-access-memory)
  - [IR.v — Instruction Register](#irv--instruction-register)
  - [CPU.v — Top-Level Integration Module](#cpuv--top-level-integration-module)
  - [tb_CPU.v — Testbench](#tb_cpuv--testbench)
- [5. ⚙️ How to Run the Simulation](#5-️-how-to-run-the-simulation)
  - [Requirements](#requirements)
  - [🐧 Ubuntu / Debian — Install](#-ubuntu--debian--install)
  - [🍎 macOS (Homebrew) — Install](#-macos-homebrew--install)
  - [🪟 Windows — Download & Install](#-windows--download--install)
  - [Step 1 — Compile all source files](#step-1--compile-all-source-files)
  - [Step 2 — Run the simulation](#step-2--run-the-simulation)
  - [Step 3 — View the waveform in GTKWave](#step-3--view-the-waveform-in-gtkwave)
- [6. 🔑 Key Design Decisions](#6--key-design-decisions)
- [7. 📊 Resource Summary](#7--resource-summary)
- [8. 👤 Author](#8--author)
- [9. 📄 License](#9--license)

---

## 1. 📌 Project Highlights

- ✅ Complete 8-bit datapath from scratch
- ✅ Shared tri-stated bus architecture (no bus conflicts)
- ✅ 256-location × 8-bit RAM with combinational read (zero-latency)
- ✅ 8-operation ALU with carry flag
- ✅ Free-running Program Counter with jump and preset
- ✅ Full simulation testbench with waveform output
- ✅ Verified module-by-module with rigorous logic analysis
- ✅ Synthesizable, clean Verilog with consistent non-blocking assignments

---

## 2. 🧠 How This Computer Works

This CPU follows a classic **bus-based datapath architecture**, similar in spirit to the SAP-1 (Simple As Possible) design taught in digital electronics courses. Every major component is connected to a single shared 8-bit data bus. At any given moment, only one module is allowed to drive the bus — all others tri-state their outputs (drive high-impedance `z`) when they are not selected. This is what makes the design work without dedicated point-to-point wiring between every pair of modules.

### The Fetch–Execute Cycle

The CPU operates in a sequential fetch–execute cycle:

1. **Fetch** — The Program Counter (PC) holds the address of the next instruction. The RAM module uses this address to place the instruction byte onto the shared bus. The Instruction Register (IR) captures this byte on the next clock edge, holding it steady for the remainder of the instruction cycle.

2. **Decode** — The control unit (or the human operator in manual mode) reads the instruction byte stored in IR and determines which operation to perform and which operands to use.

3. **Execute** — The relevant control signals are asserted in sequence: operand values are loaded from RAM into Reg_A and Reg_B, the ALU performs the operation across one or more clock cycles, and the result is stored into the output register. The Program Counter increments automatically, ready for the next fetch.

### The Shared Bus

The shared bus is the backbone of this design. Think of it as a single highway that carries data between all the components. At any moment:

- **Reg_A** can read from the bus (when `RegA_load` is high) or write onto it (when `BUS_enable_A` is high)
- **Reg_B** can read from the bus (when `RegB_load` is high) or write onto it (when `BUS_enable_B` is high)
- **RAM** always reads combinationally from the bus (when `WR=0`), meaning the correct value appears on the bus the instant the address and read-enable signals are set — no clock edge needed
- **Output Register** writes its stored result onto the bus when `OUT_enable` is high
- **IR** reads from the bus when `ir_load` is high

The control rule is simple and critical: **never assert two bus-driving enables at the same time**, or you will have two modules fighting over the same wire. The testbench is designed to respect this contract at every step.

---

## 3. 📁 Project Structure

```
8bit-cpu/
├── ALU_8Bit.v          # ALU: 8 operations + carry/borrow
├── Reg_A.v             # General purpose register A
├── Reg_B.v             # General purpose register B
├── output_Reg.v        # Output display register
├── MAR.v               # Memory Address Register
├── PC.v                # Program Counter
├── RAM.v               # 256×8 combinational-read RAM
├── IR.v                # Instruction Register
├── CPU.v               # Top-level integration module
├── tb_CPU.v            # Full-system testbench
│
├── tb_ALU.v            # Standalone testbench — ALU_8Bit.v
├── tb_outputreg.v      # Standalone testbench — output_Reg.v
├── tb_RegA.v           # Standalone testbench — Reg_A.v
├── tb_RegB.v           # Standalone testbench — Reg_B.v
├── tb_ir.v             # Standalone testbench — IR.v
├── tb_pc.v             # Standalone testbench — PC.v
├── tb_mar.v            # Standalone testbench — MAR.v
├── tb_Ram.v            # Standalone testbench — RAM.v
│
├── schematic.png       # Full CPU datapath schematic
├── dump.vcd            # Waveform dump (generated after running any testbench)
└── io_wave.pdf         # Exported waveform reference (PDF)
```

**Core modules** (top row) make up the CPU itself and are wired together in `CPU.v`, exercised together by `tb_CPU.v`.

**Per-module testbenches** (middle row) let you verify each component in isolation without building the full CPU. Each can be compiled and run the same way as `tb_CPU.v` — just swap in the matching module and testbench file:

```bash
iverilog -o tb_ALU.out tb_ALU.v ALU_8Bit.v
vvp tb_ALU.out
gtkwave dump.vcd
```

**Supporting artifacts** (bottom row):

| File | Description |
|------|--------------|
| `schematic.png` | Visual schematic of the full CPU datapath and shared bus wiring |
| `dump.vcd` | Waveform dump generated after running any testbench, viewable in GTKWave |
| `io_wave.pdf` | Exported waveform view (PDF) showing key signal transitions for reference without opening GTKWave |

---

## 4. 📂 Module Details

---

### `ALU_8Bit.v` — Arithmetic Logic Unit

The brain of the computation engine. The ALU takes two 8-bit operands (`w1` and `w2`) that are first latched from the connected registers, then performs one of eight operations selected by a 3-bit opcode. The result and carry flag are registered outputs.

**Ports:**

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `out` | output reg | 8-bit | Result of the operation |
| `c_flag` | output reg | 1-bit | Carry/borrow output |
| `A` | input | 8-bit | Operand A input (from Reg_A) |
| `B` | input | 8-bit | Operand B input (from Reg_B) |
| `opcode` | input | 3-bit | Selects the ALU operation |
| `A_load` | input | 1-bit | Latches A input into internal w1 register |
| `B_load` | input | 1-bit | Latches B input into internal w2 register |
| `rst` | input | 1-bit | Synchronous reset |
| `clk` | input | 1-bit | Clock |

**Supported Operations (opcode):**

| opcode | Operation | Description |
|--------|-----------|-------------|
| `000` | ADD | `w1 + w2`, carry out |
| `001` | SUB | `w1 - w2`, borrow out |
| `010` | AND | `w1 & w2` |
| `011` | OR | `w1 \| w2` |
| `100` | XOR | `w1 ^ w2` |
| `101` | NOT | `~w1` |
| `110` | SHL | Left shift `w1` by 1, MSB → carry |
| `111` | SHR | Right shift `w1` by 1, LSB → carry |

**How it works:** The ALU operates in two phases. When `A_load` or `B_load` is asserted, it latches the corresponding input into its internal `w1`/`w2` registers. When neither load signal is active, it computes the result of the selected opcode on `w1` and `w2` and stores it in `out`. This means the ALU requires at minimum two clock cycles to produce a result: one to latch inputs, one to compute. Arithmetic operations explicitly zero-extend both operands to 9 bits before adding or subtracting, ensuring the carry/borrow bit is correctly captured.

---

### `Reg_A.v` — General Purpose Register A

An 8-bit general purpose register that interfaces directly with the shared bus (bidirectionally) and provides a direct output to the ALU's A input. It can both receive data from the bus and drive data back onto the bus.

**Ports:**

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `out_A` | output reg | 8-bit | Direct output to ALU input A |
| `BUS` | inout | 8-bit | Shared tri-stated data bus |
| `RegA_load` | input | 1-bit | Load from BUS into register on clock edge |
| `BUS_enable_A` | input | 1-bit | Drive stored value onto BUS |
| `rst` | input | 1-bit | Synchronous reset |
| `clk` | input | 1-bit | Clock |

**How it works:** The register has two independent paths — a clocked path that captures the bus value on a rising edge when `RegA_load` is asserted, and a combinational path (`assign BUS = BUS_enable_A ? out_A : 8'bz`) that drives the stored value onto the bus the instant `BUS_enable_A` goes high. The `out_A` wire is permanently live, providing the ALU with a real-time view of what's stored in this register without any additional enable signal.

---

### `Reg_B.v` — General Purpose Register B

Structurally identical to Reg_A. Provides the second operand to the ALU via `out_B`. The same bus interface and tri-state behavior applies.

**Ports:**

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `out_B` | output reg | 8-bit | Direct output to ALU input B |
| `BUS` | inout | 8-bit | Shared tri-stated data bus |
| `RegB_load` | input | 1-bit | Load from BUS into register on clock edge |
| `BUS_enable_B` | input | 1-bit | Drive stored value onto BUS |
| `rst` | input | 1-bit | Synchronous reset |
| `clk` | input | 1-bit | Clock |

**How it works:** Exactly the same as Reg_A. The separation into two distinct modules allows both operands to be independently loaded and enables the top-level CPU module to connect each register's output directly to the corresponding ALU input port.

---

### `output_Reg.v` — Output Display Register

A dedicated display register that latches the ALU's result and carry flag, then drives them onto the bus and a separate carry output line when enabled. This module acts as the CPU's "window to the outside world" — when `OUT_enable` is asserted, both the result and carry flag become visible, like pressing a button to reveal the answer on a calculator display.

**Ports:**

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `BUS` | output | 8-bit | Tri-stated data output |
| `carry_flag` | output | 1-bit | Tri-stated carry output |
| `OUT` | input | 8-bit | Result input from ALU |
| `CF` | input | 1-bit | Carry flag input from ALU |
| `OUT_load` | input | 1-bit | Latch ALU result into register |
| `OUT_enable` | input | 1-bit | Enable output onto BUS and carry_flag |
| `rst` | input | 1-bit | Synchronous reset |
| `clk` | input | 1-bit | Clock |

**How it works:** The register stores the ALU result in `answer` and the carry in `carry` when `OUT_load` is pulsed high. When `OUT_enable` is asserted, `BUS` shows `answer` and `carry_flag` shows `carry` — both simultaneously, giving you the complete 9-bit result (8-bit value + carry). When `OUT_enable` is low, both outputs go high-impedance (`z`), representing the "display off" state that is unambiguously distinct from a real zero result.

---

### `MAR.v` — Memory Address Register

A dedicated 8-bit register that holds the address to be used for the next RAM write operation. It decouples address setup from the actual write cycle, allowing the control unit to first establish which address to target, then perform the write on a subsequent cycle.

**Ports:**

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `address_MAR` | output reg | 8-bit | Latched address output to RAM |
| `address_dip8` | input | 8-bit | External 8-bit address input (DIP switches) |
| `MAR_enable` | input | 1-bit | Load address from input on clock edge |
| `rst` | input | 1-bit | Synchronous reset |
| `clk` | input | 1-bit | Clock |

**How it works:** MAR only loads when `MAR_enable` is high on a rising clock edge. It does not interact with the shared bus at all — it receives its address from a separate dedicated external port (`address_dip8`) and outputs directly to RAM's `address_MAR` pin. This keeps address routing clean and separate from data routing.

---

### `PC.v` — Program Counter

The Program Counter automatically tracks which memory location to fetch the next instruction from. It counts upward by one every clock cycle by default, and can be overridden with a jump address or a preset value.

**Ports:**

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `address_PC` | output reg | 8-bit | Current program counter value |
| `jump_Number` | input | 8-bit | Target address for jump instruction |
| `jump` | input | 1-bit | Load `jump_Number` into PC |
| `prt` | input | 1-bit | Preset PC to `11111111` (255) |
| `rst` | input | 1-bit | Reset PC to 0 |
| `clk` | input | 1-bit | Clock |

**How it works:** Priority order is `rst > prt > jump > count`. On every clock edge where none of the override signals are active, the PC simply increments by 1. When it reaches 255 (`11111111`), it naturally wraps back to 0 on the next count, giving a circular 256-instruction address space. The `prt` (preset) signal forces the PC to 255 — useful for testing the wraparound behavior. The `jump` signal loads an arbitrary 8-bit target address, enabling unconditional jump/branch instructions.

---

### `RAM.v` — Random Access Memory

A 256-location × 8-bit synchronous write, combinational read memory. This is where both program instructions and data values are stored. The RAM module includes a built-in address multiplexer that selects between the PC's address and MAR's address for write operations, and accepts a separate direct address port for read operations.

**Ports:**

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `address_MAR` | input | 8-bit | Write address from MAR |
| `address_pc` | input | 8-bit | Write address from PC |
| `address_sel` | input | 1-bit | `1` = use PC address, `0` = use MAR address for writes |
| `address` | input | 8-bit | Direct read address input |
| `Number` | input | 8-bit | External data value to write |
| `BUS` | inout | 8-bit | Shared data bus |
| `Load_Number` | input | 1-bit | `1` = write BUS data, `0` = write Number data |
| `WR` | input | 1-bit | `1` = write mode, `0` = read mode |
| `rst` | input | 1-bit | Synchronous reset (clears all 256 locations) |
| `clk` | input | 1-bit | Clock |

**How it works:**

- **Write path (clocked):** On a rising clock edge with `WR=1`, the address multiplexer selects either `address_pc` or `address_MAR` based on `address_sel`. The data multiplexer then selects either the current `BUS` value or the external `Number` input based on `Load_Number`, and stores it into the selected RAM location.
- **Read path (combinational):** A continuous `assign` statement drives the shared `BUS` with `RAM[address]` whenever `WR=0`. There is no clock edge involved — the instant `WR` drops to 0 and a valid `address` is present, the correct memory value appears on `BUS` immediately. This zero-latency read is critical: it ensures that Reg_A or Reg_B can load the RAM's output in the same clock cycle that the read is initiated, without needing an extra wait cycle.
- **Reset:** All 256 locations are cleared to 0 when `rst` is asserted.

---

### `IR.v` — Instruction Register

A simple 8-bit register that captures and holds the current instruction byte from the shared bus. It acts as a stable "snapshot" of the instruction being executed, so that even as the bus is repurposed for data transfers during execution, the instruction byte remains available to the control unit.

**Ports:**

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `instruction` | output reg | 8-bit | Latched instruction byte |
| `BUS` | input | 8-bit | Shared data bus (read-only) |
| `ir_load` | input | 1-bit | Capture BUS value on clock edge |
| `rst` | input | 1-bit | Synchronous reset |
| `clk` | input | 1-bit | Clock |

**How it works:** When `ir_load` is pulsed high on a rising clock edge, `instruction` captures whatever byte is currently on the bus. It holds that value until the next `ir_load` pulse. Unlike Reg_A and Reg_B, IR never drives the bus — it is a one-way capture register (`BUS` is `input`, not `inout`).

---

### `CPU.v` — Top-Level Integration Module

The top-level module that instantiates all eight components and connects them together through the shared bus and dedicated point-to-point wires.

**Ports:**

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `BUS` | inout | 8-bit | Shared tri-stated data bus |
| `carry_flag` | output | 1-bit | Carry flag from output register |
| `instruction` | output | 8-bit | Current instruction from IR |
| `opcode` | input | 3-bit | ALU operation select (manual) |
| `address_dip8` | input | 8-bit | External MAR address input |
| `address` | input | 8-bit | RAM read address |
| `number` | input | 8-bit | RAM write data input |
| `jump_number` | input | 8-bit | PC jump target |
| `A_load` | input | 1-bit | ALU latch A |
| `B_load` | input | 1-bit | ALU latch B |
| `RegA_load` | input | 1-bit | Load Reg_A from BUS |
| `RegB_load` | input | 1-bit | Load Reg_B from BUS |
| `Bus_enable_A` | input | 1-bit | Reg_A drives BUS |
| `Bus_enable_B` | input | 1-bit | Reg_B drives BUS |
| `out_load` | input | 1-bit | Latch ALU result into output_Reg |
| `out_enable` | input | 1-bit | output_Reg drives BUS |
| `Mar_enable` | input | 1-bit | Load MAR |
| `load_number` | input | 1-bit | RAM data source select |
| `address_sel` | input | 1-bit | RAM address source select |
| `ir_load` | input | 1-bit | Load IR |
| `wr` | input | 1-bit | RAM write/read select |
| `jump` | input | 1-bit | PC jump |
| `prt` | input | 1-bit | PC preset |
| `rst` | input | 1-bit | Global reset |
| `clk` | input | 1-bit | Global clock |

**Internal connections:**

- `out_A` (Reg_A → ALU input A) — always live, no enable needed
- `out_B` (Reg_B → ALU input B) — always live, no enable needed
- `OUT` (ALU result → output_Reg input)
- `CF` (ALU carry → output_Reg carry input)
- `address_MAR` (MAR output → RAM write address)
- `address_PC` (PC output → RAM write address)

---

### `tb_CPU.v` — Testbench

A comprehensive simulation testbench that exercises the full CPU datapath. It drives all 23 external control and data signals, handles the shared `inout BUS` safely using a conditional `assign` with a `drive_bus` enable signal (preventing bus conflicts with the CPU's internal drivers), and verifies all 8 ALU operations across a sequence of test scenarios.

**Test scenarios covered:**

- Writing values into RAM via PC-addressed sequential writes
- Writing values into RAM via MAR-addressed targeted writes
- Reading values from RAM into Reg_A and Reg_B
- ALU operations: ADD, SUB, AND, OR, XOR, NOT, SHL, SHR
- Carry flag propagation for overflow cases
- IR instruction capture
- PC jump and preset
- output_Reg display gating (enable/disable)
- Bus enable conflicts (avoided by design)
- Global reset mid-sequence

---

## 5. ⚙️ How to Run the Simulation

### Requirements

- [Icarus Verilog](http://iverilog.icarus.com/) (`iverilog`) — free, open-source Verilog simulator
- [GTKWave](http://gtkwave.sourceforge.net/) — free waveform viewer

---

### 🐧 Ubuntu / Debian — Install

```bash
sudo apt-get update
sudo apt-get install iverilog gtkwave
```

---

### 🍎 macOS (Homebrew) — Install

```bash
brew install icarus-verilog gtkwave
```

---

### 🪟 Windows — Download & Install

- Icarus Verilog installer: [http://bleyer.org/icarus/](http://bleyer.org/icarus/) — download the latest `iverilog-vX.X-X-setup.exe` and install (this bundles both `iverilog` and `vvp`)
- GTKWave: bundled with the same Icarus Verilog Windows installer, or standalone from [https://sourceforge.net/projects/gtkwave/](https://sourceforge.net/projects/gtkwave/)

During installation, make sure to check the option to **add Icarus Verilog to your PATH** so the commands below work from any Command Prompt / PowerShell window.

> Alternatively, install [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/install) and simply follow the Ubuntu/Debian instructions above inside your WSL terminal.

---

### Step 1 — Compile all source files

Place all `.v` files in the same directory. Then compile the testbench together with all modules (same command on Ubuntu, macOS, and Windows):

```bash
iverilog -o tb_CPU.out tb_CPU.v CPU.v ALU_8Bit.v Reg_A.v Reg_B.v output_Reg.v MAR.v PC.v RAM.v IR.v
```

This produces a compiled simulation binary called `tb_CPU.out`.

---

### Step 2 — Run the simulation

```bash
vvp tb_CPU.out
```

This runs the simulation. You will see the `$monitor` output printed line by line in your terminal, showing every signal value at every timestep where something changes. A `dump.vcd` waveform file is also generated automatically.

---

### Step 3 — View the waveform in GTKWave

```bash
gtkwave dump.vcd
```

GTKWave opens with a file browser on the left. To view signals:

1. Click on `tb_CPU` in the SST (Signal Selection Tree) panel on the left
2. Double-click signals you want to add to the waveform view (e.g. `BUS`, `carry_flag`, `instruction`, `clk`, `rst`)
3. Use the zoom controls at the top to zoom in/out on the timeline
4. Look for the moments where `out_enable` goes high — that is when the ALU result becomes visible on `BUS`

**Recommended signals to add first:**
- `clk` — master clock reference
- `rst` — reset signal
- `BUS[7:0]` — shared data bus (shows all data movement)
- `carry_flag` — carry output
- `instruction[7:0]` — currently held instruction
- `wr` — distinguishes read vs write cycles on RAM

---

## 6. 🔑 Key Design Decisions

**Why tri-state bus instead of a mux?**
A tri-state bus more closely models how real hardware (breadboard CPUs, FPGA IO pins, older microprocessors) actually works. Each module independently decides whether to drive the bus or release it, which is more realistic than a centralized multiplexer that would need to know about every possible driver.

**Why combinational RAM reads?**
All other bus-driving modules (Reg_A, Reg_B, output_Reg) present their values combinationally when enabled — there is no clock delay between asserting an enable and seeing the value on the bus. RAM's read path matches this behavior by using a direct `assign BUS = RAM[address]` statement rather than a clocked intermediate register. This means the control unit can initiate a RAM read and capture the result in the same clock cycle, simplifying timing considerably.

**Why separate A_load/B_load and compute cycles in the ALU?**
The ALU uses internal registers (`w1`, `w2`) rather than reading directly from Reg_A/Reg_B combinationally. This gives the design a consistent clocked behavior where operand loading and computation are explicit, separate steps. The tradeoff is that every ALU operation requires at minimum two clock cycles — one to latch, one to compute — but the benefit is clear, deterministic timing with no combinational path from input to output.

**Why is IR's BUS port `input` instead of `inout`?**
IR never drives the bus — it only captures from it. Using `inout` would be misleading and potentially dangerous (a tool generating a bus driver for a port that should never drive). Using `input` accurately reflects the one-directional nature of IR's relationship with the bus.

---

## 7. 📊 Resource Summary

| Module | Type | Bits | Bus Interface |
|--------|------|------|---------------|
| ALU_8Bit | Combinational + Registered | 8-bit in/out | None (direct wires) |
| Reg_A | Register | 8-bit | Read + Write (inout) |
| Reg_B | Register | 8-bit | Read + Write (inout) |
| output_Reg | Register | 8-bit + 1-bit carry | Write only (output) |
| MAR | Register | 8-bit | None |
| PC | Counter + Register | 8-bit | None |
| RAM | Memory Array | 256 × 8-bit | Read + Write (inout) |
| IR | Register | 8-bit | Read only (input) |

---

## 8. 👤 Author

Built with curiosity, patience, and a lot of waveform debugging.

Feel free to fork, star ⭐, and build on top of this design. If you find a bug or want to extend it with a control unit or assembler, open a pull request — contributions welcome.

---

## 9. 📄 License

MIT License — free to use, modify, and distribute with attribution.
