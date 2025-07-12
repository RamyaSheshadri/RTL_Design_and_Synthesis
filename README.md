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

```bash
# 📁 Create working directory
mkdir -p ~/sky130_workshop/session1
cd ~/sky130_workshop/session1
# 📝 Create RTL file
nano design.v
# 📝 Create Testbench
nano tb.v
# ⚙️ Compile design and testbench
iverilog design.v tb.v -o sim.out
# ▶️ Run the simulation
vvp sim.out
# 🖥️ GTKWave setup for WSL only (run only if using WSL)
export DISPLAY=:0
# 📈 View waveform
gtkwave and_gate.vcd
Inside GTKWave:

Expand tb

Double-click on a, b, y to add signals to waveform window

Zoom in/out and observe transitions

<img width="955" height="318" alt="GTK OP" src="https://github.com/user-attachments/assets/7f4e527b-328f-41da-b3ae-5661281cb3fb" />

✅ DONE:
- RTL and TB written
- Simulated with Icarus Verilog
- Waveform visualized via GTKWave

