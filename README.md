# RTL Design and Synthesis using SKY130 

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


 ## **synth -top good_mux**

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
MUX design has successfully synthesized to one internal multiplexer (`$_MUX_`), but it's not yet mapped to any **actual SKY130 standard cell**. Run `abc` to replace `$_MUX_` with `sky130_fd_sc_hd__mux2_1` or equivalent.


## ABC RESULTS: sky130_fd_sc_hd__mux2_1 cells: 1

### Inference from `stat` Output — **After ABC Mapping**

* The design is now **technology-mapped** to the SKY130 cell library
* **`sky130_fd_sc_hd__mux2_1`** is the actual physical standard cell used
* The previously inferred `$_MUX_` has been **replaced** with a real gate
* This means your RTL was successfully synthesized to a **tapeout-valid cell**
* Since only 1 cell was used, it's an **area-optimized** mapping — no redundant gates
* All inputs/outputs are **connected directly to the mux2\_1 cell**
* Ready for STA, power, area, and layout-level analysis

---
<img width="308" height="227" alt="yosys op mux" src="https://github.com/user-attachments/assets/3708a371-ebe6-4e2e-b4c6-4e29dd2d8e4f" />

## Inference from `.yosys_show.dot` Gate-Level Diagram
### General Structure:
* The diagram is generated after running:show in Yosys **after `abc` + `.lib` tech mapping**.
---

### Key Observations:

* Inputs `a`, `b`, and `sel` are **connected via buffers (BUF)** — these are inserted by Yosys to match driving strength or syntax.
* The core logic cell is:
  ```
  sky130_fd_sc_hd__mux2_1
  ```
  This is a **real physical MUX gate** from the SKY130 standard cell library.
* Inputs:
  * `A0` = `a`
  * `A1` = `b`
  * `S` = `sel` (select line)

* Output:

  * `X` = result from MUX → passed to another `BUF` → output `y`
---

### Design-Level Inference:

* Your RTL 2:1 MUX is now **fully mapped to silicon-usable gate** — no inferred logic remains.
* No internal logic (NANDs or INVs) needed — this is **area-optimized**, thanks to direct use of `mux2_1`.
* Each input and output is passed through `BUF` gates to ensure signal integrity — this is typical in standard-cell synthesis.

## Post-Synthesis Stats (`stat` Output)

After running the full Yosys synthesis flow with SKY130 technology mapping, the following statistics were obtained using the `stat` command:

```txt
=== good_mux ===

   Number of wires:                  8
   Number of wire bits:              8
   Number of public wires:           4
   Number of public wire bits:       4
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                  1
     sky130_fd_sc_hd__mux2_1         1
```

### Inference from `stat` Output

- **Number of cells: 1**  
  - The entire design is implemented using **a single standard cell**, making it extremely area-efficient and minimal in gate count.

- **Mapped Cell: `sky130_fd_sc_hd__mux2_1`**  
  - This is a native **2:1 multiplexer** from the SKY130 standard cell library.  
  - The RTL was **perfectly matched** to this cell with no need for internal decomposition (e.g., into NAND, NOR, or INV gates).  
  - Result: A **clean and optimal** technology-mapped netlist.

- **8 wires / 8 wire bits**  
  - Represents a combination of internal connections and buffering handled by Yosys during synthesis.  
  - **Public wires: 4** → These are your actual RTL ports: `a`, `b`, `sel`, and `y`.

- **No memories or processes present**  
  - Confirms the design is **purely combinational** — no sequential elements, state machines, or RAM.  
  - Ideal for lightweight logic blocks and for STA or physical design integration.

---

### Takeaway

> The synthesized netlist is highly optimized, mapped to a single `mux2_1` gate from the SKY130 cell library, and ready for further analysis or layout.  
> This confirms that the RTL design is clean, efficient, and silicon-valid for fabrication using open PDKs.


# Day 2 — Liberty File Exploration: Timing Delay Extraction
 
**Goal**: Understand `.lib` files and extract accurate cell delay and slew values from standard cells  
**Cell Analyzed**: `sky130_fd_sc_hd__nand2_1`  
**Library Used**: `sky130_fd_sc_hd__tt_025C_1v80.lib`  
**Corner**: TT (Typical-Typical), 25°C, 1.8V  


## Objectives Completed Today

- Located and opened the correct Liberty (`.lib`) file  
- Parsed cell information for NAND2 gate  
- Extracted timing arcs for a chosen input-output transition  
- Interpreted propagation delay and transition slew  
- Connected `.lib` data with expected Verilog simulation behavior  


## Setup & Commands


#### Clone repo containing liberty file
git clone https://github.com/praharshapm/vsdmixedsignalflow.git

#### Copy the liberty file to local workshop directory
mkdir -p ~/RTL_Design_and_Synthesis_Workshop_Using_SKY130/lib
cp vsdmixedsignalflow/LIB/sky130_fd_sc_hd__tt_025C_1v80.lib lib/

#### Open the file and search for the cell
- nano lib/sky130_fd_sc_hd__tt_025C_1v80.lib
- Ctrl + W
- sky130_fd_sc_hd__nand2_1
- You'll see: cell ("sky130_fd_sc_hd__nand2_1")

  ### Pins Involved

| Pin | Type   | Role                          |
|-----|--------|-------------------------------|
| A   | Input  | Primary timing input          |
| B   | Input  | Secondary input               |
| Y   | Output | Primary timing output         |

### Extracted Timing Parameters

| Parameter         | Liberty Block     | Index (Slew, Load)     | Extracted Value | Description                      |
|-------------------|------------------|-------------------------|------------------|---------------------------------|
| Propagation Delay | `cell_fall`      | (0.01 ns, 0.0005 pF)    | 24.92 ps         | A ↑ → Y ↓ delay (neg_unate)     |
| Output Slew       | `fall_transition`| (0.01 ns, 0.0005 pF)    | 14.38 ps         | Slew at Y for A ↑ → Y ↓         |



<img width="797" height="278" alt="pin a " src="https://github.com/user-attachments/assets/4252dba7-bf15-4dc4-8bc9-2f4e56321584" />
<img width="815" height="284" alt="pin b" src="https://github.com/user-attachments/assets/ae58ddd2-2954-477d-96d3-a78ef081dd30" />
<img width="797" height="212" alt="pin y" src="https://github.com/user-attachments/assets/768f9e39-98ef-459d-a644-50970559ec61" />


### Which exact value did we extract?
**Let’s assume:**

- Slew = 0.01 ns (10 ps)
- Load = 0.0005 pF (0.5 fF)

**So we’re looking at:**
- index_1[0] = 0.0100000000
- index_2[0] = 0.0005000000

**This means:**
- We extract the [0][0] value from the matrix inside each values(...) block.

### An example is shown here:
<img width="800" height="362" alt="OUTPUT" src="https://github.com/user-attachments/assets/a1930031-dc37-40f2-bf8e-42aead8eded5" />

### Delay vs Slew vs Load — Interpretation

The `values()` matrix inside `cell_fall`, `cell_rise`, `fall_transition`, and `rise_transition` corresponds to:
- **X-axis (`index_1`)** = Input transition time (slew)
- **Y-axis (`index_2`)** = Output load capacitance

From the matrix, we extracted the delay at:
- **Input Slew = 0.01 ns**
- **Output Load = 0.0005 pF**

This maps to the **[0][0]** entry of the matrix.

We picked:
- `cell_fall` (A ↑ → Y ↓ delay)
- `fall_transition` (Slew of output Y for A ↑)

Both values decrease with lower load and faster input transitions (lower slew).

### What is `timing_sense`?

`timing_sense` tells us how the output behaves based on input transitions.

- `"positive_unate"` → Output follows input transition (e.g., A ↑ → Y ↑)
- `"negative_unate"` → Output inverts input transition (e.g., A ↑ → Y ↓)
- `"non_unate"`       → Output transition can’t be predicted (data-dependent)

Here, both A → Y and B → Y have `timing_sense : "negative_unate"`  
As expected — a NAND gate inverts input transition.

### Why is NAND2 output Y `negative_unate` w.r.t A or B?

A NAND gate outputs:
> Y = !(A & B)

- If A goes from 0 to 1 (↑), and B = 1, then:
  - A ↑ → A & B ↑ → Y goes from 1 → 0 (↓)
- This means: **Input A ↑ causes Output Y ↓**

Hence, the behavior is **inverting** → `negative_unate`

# Liberty File Exploration: Setup and Hold Time Extraction

This session involved **manual parsing** of a standard cell liberty file —  
specifically `sky130_fd_sc_hd__tt_025C_1v80.lib` — to extract **setup** and **hold** timing constraints for the flip-flop cell `sky130_fd_sc_hd__dfxtp_1`.


## 🔍 What Was Extracted?

We focused on **timing arcs** for the output pin `"Q"`:
- **Setup Time (`setup_rising`)**
- **Hold Time (`hold_rising`)**

These timing arcs define when input `"D"` must be stable **before** and **after** the rising edge of the clock `"CLK"`.


## Structure Observed in Liberty

```liberty
timing_type : "setup_rising";
related_pin : "CLK";
rise_constraint ("vio_3_3_1") {
  index_1("...")     --> Data transition time (D)
  index_2("...")     --> CLK transition time
  values("...")      --> Setup time values in ns
}

timing_type : "hold_rising";
related_pin : "CLK";
rise_constraint ("vio_3_3_1") {
  index_1("...")     --> Data transition time
  index_2("...")     --> CLK transition time
  values("...")      --> Hold time values in ns
}
```
<img width="452" height="449" alt="aa" src="https://github.com/user-attachments/assets/7c3ad1ba-919d-48be-b269-8c04252fc42e" />



**Interpreting a Value:**
- Let’s pick:
  - Data transition = 0.5 ns
  - Clock transition = 0.5 ns
  - Setup time = 0.152 ns (2nd row, 2nd Column intersection of the matrix)

Meaning:Data must be stable at least 0.152 ns before rising edge of CLK.

**Interpreting a Value: Hold time**
- If D = 0.5 ns, CLK = 0.5 ns → Hold = -0.115 ns
Meaning:
- Data must be stable at least 0.115 ns after rising CLK edge.

**Negative hold time implies:**
- There’s already built-in slack
- Might still cause hold violation in fast paths

Got it, pa! Here's a **proper, professional README-style title and heading** for the entire segment comparing **synchronous vs asynchronous reset DFFs** using Yosys schematics, including discussion on standard cells like `sky130_fd_sc_hd__dfxtp_1`, NOR gates, and the `$` cell labels:

---

## Comparison of Synchronous vs Asynchronous Reset D Flip-Flops using Yosys and SKY130 Standard Cells

### Overview
This segment documents the synthesis, standard cell mapping, and schematic-level comparison of two types of D flip-flop designs:

* **Synchronous Reset DFF**
* **Asynchronous Reset DFF**

We synthesize both using **Yosys** with **SKY130 standard cell library**, analyze the generated **gate-level netlists**, and visualize schematics to:

* Identify mapped **standard cells**
* Understand functional blocks like reset logic and core flip-flop behavior
* Compare the logic differences (like use of extra gates for async resets)

###  Focus Points

* Visual analysis of `dfxtp` (positive edge-triggered DFF) cells
* Role of additional NOR gates in async reset mapping
* Why extra gates appear in async version but not sync
* Meaning of `$`-labeled synthesized cells like `$83`, `$84`

---
### Output waveform of synchronous reset on GTKWave:

<img width="959" height="314" alt="sync reset" src="https://github.com/user-attachments/assets/45f8d158-8c74-40a2-a3c6-05b92179e843" />

### Output on Yosys: 
<img width="710" height="309" alt="yosys dff" src="https://github.com/user-attachments/assets/44ec5217-6b18-4156-9e7c-682330bc81ed" />

---

## What Verilog Code Says 

```verilog
always @(posedge clk) begin
  if (rst)
    q <= 0;
  else
    q <= d;
end
```

You're saying:

* "Hey DFF, at every **posedge clk**, do either:

  * Set `q = 0` if `rst = 1`
  * Or set `q = d` if `rst = 0`"

So, **the DFF has no idea about reset unless we tell it what to do with D**.

---

## What Yosys Does

There is **no special flip-flop** for sync reset in the liberty `.lib`.
So Yosys **fakes it** like this:

> **"Let me compute the value of D based on `rst` and `d`, and just give that to a plain flip-flop!"**

That’s why it builds a logic gate to mimic:

```verilog
assign D_in = (rst) ? 0 : d;
```

And how do we implement this `D_in = (rst) ? 0 : d` in hardware?

> Using a **2-input NOR2B gate**, with:
>
> * `A = rst`
> * `B_N = d` (inverted inside the cell)

That cell:

```text
sky130_fd_sc_hd__nor2b_1
```

means:

* **Input A** is normal
* **Input B\_N** is *already inverted*
* It does: `Y = ~(A + ~B)`

Now plug in your signals:

| Pin  | Signal |
| ---- | ------ |
| A    | rst    |
| B\_N | d      |

Then output becomes:

```
Y = ~(rst + ~d)
```

- When **`rst = 1`**, then `Y = 0` ⟶ This becomes the D input to the flip-flop ⇒ Reset behavior achieved.
- When **`rst = 0`**, then `Y = d` ⟶ The DFF gets the actual data input ⇒ Normal DFF operation.

**So this logic emulates the `if (rst) q <= 0; else q <= d;` behavior!**

---

## TL;DR: WHY NOR2B?

**Because we don’t have a flip-flop that supports synchronous reset directly in the library.**
- So, we build the reset logic externally — combine `rst` and `d` into a single input to the DFF.
- The NOR2B cell **performs exactly the same logic as your Verilog conditional statement** — in real gates.
---

## Asynchronous FF

### Output waveform on GTKWave:
<img width="959" height="292" alt="async " src="https://github.com/user-attachments/assets/1cec760a-57a1-4d39-9706-d06d4362e1f5" />

### Output on Yosys:
<img width="710" height="318" alt="yosys async" src="https://github.com/user-attachments/assets/b304a83b-edd4-496b-83b7-3adb8b77cc5f" />

---

### 🧠 What Your Async Verilog Code Says:

```verilog
module dff_async (
  input clk,
  input rst,
  input d,
  output reg q
);
  always @(posedge clk or posedge rst)
    if (rst)
      q <= 0;
    else
      q <= d;
endmodule
```
Translation:

> **"Hey flip-flop! The moment either `clk ↑` OR `rst ↑` happens, react instantly."**

That’s **asynchronous reset** — **`rst` bypasses the clock**.

---

### 🔧 Now, What Yosys Did with Std Cells (In Your Dot Image):

#### Cell 1: `sky130_fd_sc_hd__dfrtp_1`

This is a **D flip-flop with async reset**. Let’s look at its ports:

| Port      | Meaning                 |
| --------- | ----------------------- |
| `CLK`     | Clock input             |
| `D`       | Data input              |
| `Q`       | Output                  |
| `RESET_B` | **Active-LOW Reset**    |

So this FF resets when **RESET\_B = 0**

But in your Verilog, `rst = 1` means reset!

So... how do we fix that?

#### Cell 2: `sky130_fd_sc_hd__clkinv_1`

This is an **inverter** — it simply takes `rst` and **inverts it**.
So:

```
RESET_B = ~rst
```

This matches the **active-low reset** requirement of the FF cell.

---

### Final Flow in Diagram:

1. `rst` goes into `sky130_fd_sc_hd__clkinv_1`
2. That produces `~rst`, sent to `RESET_B` of the flip-flop
3. Now, flip-flop resets when `rst = 1`, just like your Verilog
4. `d`, `clk`, and `q` go directly to the FF

- $83 is just an internal net created during synthesis.
- It connects internal logic (like NOR) to standard cell pins.
- It’s safe to treat it as a “hidden wire” that routes control logic inside the synthesized netlist.
---

###  Why This Design Is So Clean?

* No gates needed to fake reset logic
* `sky130_fd_sc_hd__dfrtp_1` directly supports async reset
* Just need an inverter to match active-low format

---

### Side-by-Side Summary: Sync vs Async

| Feature             | Sync Version                                          | Async Version                                           |
| ------------------- | ----------------------------------------------------- | ------------------------------------------------------- |
| Reset Handling      | Done using NOR logic before DFF                       | Done **inside** DFF cell (via RESET\_B pin)             |
| Flip-Flop Cell Used | `sky130_fd_sc_hd__dfxtp_1` (no reset support)         | `sky130_fd_sc_hd__dfrtp_1` (async reset supported)      |
| Extra Cell Used     | `sky130_fd_sc_hd__nor2b_1` (for logic muxing)         | `sky130_fd_sc_hd__clkinv_1` (just to invert active-low) |
| Reset Trigger       | Acts **only on clock edge**                           | Acts **immediately**, even without a clock edge         |
| Logic Complexity    | Higher — reset logic has to be synthesized externally | Lower — handled by dedicated pin inside FF              |

---

# Session 3 — Multiplier RTL Design and Synthesis (mult2 & mult8)

- This session focuses on the design, simulation, and synthesis of 2-bit and 8-bit unsigned multipliers using Verilog, GTKWave for waveform viewing, and Yosys for synthesis.

---

##  `mult2` — 2-bit Unsigned Multiplier

### ✅ Design File: 
<img width="953" height="287" alt="mult2 op" src="https://github.com/user-attachments/assets/b6fabb2c-5212-4e2b-99ee-2408e7c29c21" />

- Implements a simple 2-bit × 2-bit multiplier
- Output width = 4 bits (`2N`)

### Simulation Instructions

```bash
# Compile and simulate
iverilog -o mult2_out mult2.v mult2_tb.v
vvp mult2_out
```
# View waveform
gtkwave dump.vcd

- Synthesis Instructions (Yosys)
yosys
read_verilog mult2.v
synth -top mult2
write_verilog synth/mult2_syn.v

## Similarly for 8-bit multiplier:

<img width="959" height="286" alt="mult8 op" src="https://github.com/user-attachments/assets/5f118f75-4424-4526-a989-a672ca2a2122" />

## 📊 Yosys Synthesis Report Summary

Below is a synthesized summary of the resource usage for the `mult2` (2-bit × 2-bit) and `mult8` (8-bit × 8-bit) unsigned multipliers.

| Metric                   | mult2        | mult8        |
|--------------------------|--------------|--------------|
|  Number of wires        | 3            | 3            |
|  Number of wire bits    | 8            | 32           |
|  Public wires           | 3            | 3            |
|  Public wire bits       | 8            | 32           |
|  Number of memories     | 0            | 0            |
| Number of memory bits  | 0            | 0            |
|  Number of processes    | 0            | 0            |
|  Number of cells        | 1            | 1            |
|   └── `$mul` (Multiplier) | 1            | 1            |

---

###  Explanation of Key Metrics

You've written two multiplier modules:

* `mult2`: Multiplies two **2-bit numbers**
* `mult8`: Multiplies two **8-bit numbers**

Then you ran them through **Yosys**, which checks:

* How many **signals**, **wires**, and **hardware blocks** your design needs.
* What kind of operations (like `+`, `*`, etc.) are being used.

Now let’s decode the Yosys stats one by one:


###  Number of Wires

* Think of **wires** like roads for electrical signals.
* Both designs have 3 wires:

  * `input a`, `input b`, and `output y`.

 **Why same for both?**
Because even though bit-widths differ, the number of variables (inputs/outputs) is still 3.


###  Number of Wire Bits

* A **wire bit** is like one lane in the road.
* For example:

  * `a[1:0]` has 2 bits → 2 lanes
  * `b[1:0]` has 2 bits → 2 lanes
  * `out[3:0]` has 4 bits → 4 lanes
    → Total: **2 + 2 + 4 = 8 bits** for `mult2`

  For `mult8`:

  * `a[7:0]` → 8 bits
  * `b[7:0]` → 8 bits
  * `out[15:0]` → 16 bits
    → Total: **8 + 8 + 16 = 32 bits**

**Why different?**
Because the numbers are **bigger** and need **more bits** to be represented.

---

###  Public Wires and Bits

* These are just **input/output wires** that your module exposes outside.
* Same values as above because you didn't create any internal temporary wires.

---

### Number of Memories and Memory Bits

* You didn’t use any RAM or arrays. Just pure math (`*`).
  ✅ So it's **0** for both.

---

### Number of Processes

* A **process** in Verilog means `always` blocks (used for clocked or conditional logic).
* Since your design is purely combinational (`assign out = a * b;`), Yosys reports **0** processes.

---

### Number of Cells

* A **cell** is like a basic hardware building block (e.g., AND gate, adder, multiplier).
* Both designs used:

  * **1 `$mul` cell** → Yosys inferred the multiplication and created a hardware block for it.

Even though `mult8` is bigger, it still counts as **1 multiplier cell** (just a larger one under the hood).

---


### So What Does This Tell You?

* Your code is **clean** and synthesizable.
* Yosys correctly detected and synthesized the `*` operator as a **multiplier cell**.
* Bit-width scaling affects only wire bits, not the number of wires or cells.
* This is an example of **pure combinational logic**, no clocks, no memories.

---

Let me know if you want the next step — comparing area/delay using `.lib`, or rewriting the multiplier *without* using `*` operator (just add & shift!) 🛠️

---

### Observations

-  Both designs use exactly **1 multiplier cell** (`$mul`), proving that `*` was inferred as a built-in multiplication operator.
-  The number of **wire bits scales with bit-width**:
  - `mult2`: 2-bit inputs produce 4-bit output ⇒ 2 + 2 + 4 = **8 bits**
  - `mult8`: 8-bit inputs produce 16-bit output ⇒ 8 + 8 + 16 = **32 bits**
-  No memory or sequential logic involved — pure combinational multiplication.
-  Synthesis flow is **consistent** and scalable as bit-width increases.

---


---

## Comparing Raw vs Simplified .dot Diagrams in Yosys

###  1. **Shows Yosys Optimization Power**

* The **initial DOT diagram** contains:

  * Direct expression trees from the RTL
  * Redundant gates or intermediate wires
 
  ## Mult2:
 <img width="559" height="318" alt="mult2 yosys" src="https://github.com/user-attachments/assets/26a73bc2-8a11-43ac-a01d-4589b56de469" />

## Mult8:
<img width="645" height="385" alt="mult 8 yosys dot" src="https://github.com/user-attachments/assets/74b20a08-23c3-4b35-9c74-05baa613aa2e" />

* The **simplified version** (after `opt`, `proc`, `clean`) shows:

  * Flattened logic
  * Reduced gate count
  * Only essential cells & wires

## Mult2 simplified version:
 
  <img width="418" height="295" alt="yosys mult2 simplified" src="https://github.com/user-attachments/assets/ba9cfeec-5e8d-4ed2-950b-cbb398428cd7" />


## Mult8 simplified version:
<img width="554" height="373" alt="yosys mult8 simplified" src="https://github.com/user-attachments/assets/0527b0bd-116e-4c9e-b85d-9af6200a7444" />

Helps you **visually see the impact of synthesis optimizations**.

---

### 2. **Explains Synthesis Flow Stages**


| Stage       | Command                                  | Effect                                         |
| ----------- | ---------------------------------------- | ---------------------------------------------- |
| Raw diagram | `read_verilog`, `hierarchy -top`, `show` | Shows full RTL as-is                           |
| Simplified  | `proc; opt; opt_clean; show`             | Reduced to primitives like `$mul`, `$add`, etc |

---

###  "What does synthesis actually do?"
 Yosys eliminated intermediate logic and directly used `$mul` cells for multiplication logic.

---

###  4. **Highlights Design Complexity**

A good contrast for:

* `mult2` vs `mult8`
* Or before vs after optimization


