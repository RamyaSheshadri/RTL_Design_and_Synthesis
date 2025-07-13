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


# 2:1 MUX: RTL Design, Simulation & Synthesis (SKY130)

This demonstrates the complete RTL to gate-level flow for a 2:1 multiplexer using open-source tools and the SKY130 standard cell library.

---

## Tools Used

| Tool       | Purpose                            |
|------------|------------------------------------|
| `iverilog` | Simulation of RTL design           |
| `vvp`      | Executes compiled simulation       |
| `gtkwave`  | Waveform visualization (`.vcd`)    |
| `yosys`    | Logic synthesis & technology mapping|
| `.lib`     | SKY130 Liberty file for cell info  |

---

## Files in this Lab

| File                  | Purpose                         |
|-----------------------|---------------------------------|
| `good_mux.v`          | Verilog RTL for 2:1 MUX         |
| `tb_good_mux.v`       | Verilog testbench               |
| `dump.vcd`            | VCD file for waveform viewing   |
| `mux_out`             | Compiled simulation binary      |
| `mux_synth.v`         | Synthesized netlist (optional)  |
| `sky130_fd_sc_hd__tt_025C_1v80.lib` | Liberty file      |

---

## Step-by-Step Procedure

### 1. Write RTL and Testbench
- `good_mux.v`:using command nano good_mux.v 
- tb_good_mux.v:using command nano tb_good_mux.v
- Ctrl+O to save, ENTER, Ctrl+X to exit

### 2. Run simulation:
- iverilog -o mux_out good_mux.v tb_good_mux.v
- vvp mux_out
- gtkwave dump.vcd &

Observe a, b, sel, and y in GTKWave. 
<img width="858" height="308" alt="mux op gtk" src="https://github.com/user-attachments/assets/32462b29-abad-48e7-a82c-e870a501e439" />

### 3. Run synthesis in Yosys by:
yosys
**Then in yosys shell, type the following commands one by one**
- read_liberty -lib sky130_fd_sc_hd__tt_025C_1v80.lib
- read_verilog good_mux.v
- synth -top good_mux
- dfflibmap -liberty sky130_fd_sc_hd__tt_025C_1v80.lib
- abc -liberty sky130_fd_sc_hd__tt_025C_1v80.lib
- show


 **synth -top good_mux**

### Inference from `stat` Output — Before ABC Mapping

* **Module name** is `good_mux` — your top-level design
* **4 wires and 4 wire bits** → represent the signals `a`, `b`, `sel`, `y`
* **No memories or processes** → confirms it's a purely combinational design (no FSMs or RAM)
* **Number of cells: 1** → only one logic unit used internally
* **`$_MUX_` is present** → this is a *generic inferred mux* from Yosys
* Not yet mapped to real SKY130 cells — design is still in **intermediate netlist form**
* Indicates you haven’t run `abc` (or `dfflibmap + abc`) yet to tech-map to real standard cells

---

### Summary:

> MUX design has successfully synthesized to one internal multiplexer (`$_MUX_`), but it's not yet mapped to any **actual SKY130 standard cell**. Run `abc` to replace `$_MUX_` with `sky130_fd_sc_hd__mux2_1` or equivalent.

```
ABC RESULTS: sky130_fd_sc_hd__mux2_1 cells: 1
```
### Inference from `stat` Output — **After ABC Mapping**

* The design is now **technology-mapped** to the SKY130 cell library
* **`sky130_fd_sc_hd__mux2_1`** is the actual physical standard cell used
* The previously inferred `$_MUX_` has been **replaced** with a real gate
* This means your RTL was successfully synthesized to a **tapeout-valid cell**
* Since only 1 cell was used, it's an **area-optimized** mapping — no redundant gates
* All inputs/outputs are **connected directly to the mux2\_1 cell**
* Ready for STA, power, area, and layout-level analysis

---

### Summary:

> Your RTL multiplexer is now represented by a single **sky130\_fd\_sc\_hd\_\_mux2\_1** gate — a standard cell from the SKY130 library. This is a **fully optimized, technology-mapped** version of your design — exactly what gets used in real silicon.

Let me know if you want this included in your final **README Day 1 results section** 🔧💚 You’re documenting it like a rockstar engineer now!

 
