# RTL_Design_and_Synthesis
# RTL Design and Synthesis using SKY130 🚀

## Overview

This repository documents my journey through the **RTL Design & Synthesis Workshop using SKY130**, based on the open-source flow by [Prachurjya Ghy](https://github.com/prachurjyaghy/RTL_Design_and_Synthesis_Workshop_Using_SKY130).  I have extended it with my own documentation, notes, and experiments.It covers the **complete front-end ASIC design flow** using open-source tools like:

- **Icarus Verilog** – RTL simulation
- **GTKWave** – Waveform analysis and debugging
- **Yosys** – RTL synthesis
- **Sky130 PDK** – Industry-grade open-source standard cell library

This project helps me **build practical VLSI design experience**, aligned with real industry flows and tools used at companies like **Intel, Synopsys, Cadence, AMD**, and more.

---

## Goal

To learn and implement a complete RTL-to-Gate-Level design flow from scratch using:
> Verilog →  Simulation →  Synthesis → (Optional) GDSII with OpenLane

---

## Tools Used

| Tool        | Purpose                         |
|-------------|---------------------------------|
| Icarus Verilog | RTL Simulation               |
| vvp         | Run compiled Verilog simulation |
| GTKWave     | View VCD waveforms              |
| Yosys       | Synthesis to gate-level netlist |
| Sky130 PDK  | Standard cells + timing models  |
| WSL (Ubuntu) | Linux dev environment on Windows |

---

##  Author

**Ramya Sheshadri**  
B.E. Electronics & Communication Engineering – BMSCE  
Aspiring VLSI Design Engineer | RTL | STA | CMOS | Verilog | SystemVerilog | EDA Tools 

# Session 1 — 2-input AND Gate RTL Design, Simulation & Waveform

This session covers writing the RTL and testbench for a 2-input AND gate, simulating the design using Icarus Verilog, and viewing the waveform on GTKWave.


### Project Setup
 #### Create a working directory for the session:
  - mkdir -p ~/sky130_workshop/session1
  - cd ~/sky130_workshop/session1

  #### Create RTL File
  - Open design.v in nano editor:using command : nano design.v
  - Write your RTL code inside it
    - Save and exit:
    - Press Ctrl + O, then Enter to save
    - Press Ctrl + X to exit
      
#### Create Testbench File
Use command:nano tb.v
 - Write Testbench code in it.
  - Save and exit with Ctrl + O, Enter, Ctrl + X.

#### Compile and Simulate
Compile both design and testbench files:
iverilog design.v tb.v -o sim.out

#### Run the compiled simulation:
vvp sim.out
This will generate a file called and_gate.vcd.

### Open GTKWave (for Waveform Visualization)
If you're on WSL, ensure your X11 server (e.g., VcXsrv) is running.

### Export display (for WSL only):
export DISPLAY=:0
Then open the waveform in GTKWave:
gtkwave and_gate.vcd

- Inside GTKWave:
- Navigate the left panel and double-click a, b, and y to load them into the waveform viewer.
- Zoom and inspect signal transitions as needed.

#### Status:
At this point:
- The Verilog RTL and testbench have been simulated
- Output waveform is successfully viewed
- Environment is fully functional

<img width="955" height="318" alt="GTK OP" src="https://github.com/user-attachments/assets/7f4e527b-328f-41da-b3ae-5661281cb3fb" />

