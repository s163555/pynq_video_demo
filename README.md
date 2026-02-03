# Pynq-Z1 FPGA Screensaver
A hardware-accelerated "Moiré Pattern" generator running on the Pynq-Z1 (Zynq-7000 SoC). This project generates 720p video in real-time using custom VHDL logic, bypassing the CPU for rendering.

## Architecture

- **Target Board:** Pynq-Z1 (`xc7z020clg400-1`)
- **Toolchain:** Vivado 2025.2
- **Video Output:** HDMI (720p @ 60Hz)
- **Clock Domains:**
    - Logic/AXI: 100 MHz
    - Video Pixel Clock: 74.25 MHz

## Project Structure

- `moire_pattern_gen.vhd`: Custom IP core handling the pattern generation and timing logic.
- `pynq_z1_hdmi.xdc`: Physical constraints mapping HDMI signals to the board pins.
- `design_1.bd`: Block Design connecting the Zynq PS, VTC, and custom IP.

## Setup Instructions

1. Open the project in Vivado.
2. Ensure the "Digilent Vivado Library" is added to the IP Repository (required for `rgb2dvi`).
3. Validate the Block Design to ensure clock domain crossings are correct.
4. Run Synthesis -> Implementation -> Generate Bitstream.

## How to Run (Headless)

1. Transfer the generated `.bit` and `.hwh` files to the Pynq board via Samba (`\\\\pynq\\xilinx`).
2. Use the provided Jupyter notebook to load the overlay:
```python
from pynq import Overlay
ol = Overlay("pynq_video_demo.bit")
```

### A Critical "Pro Tip" for Vivado \& Git
Vivado's project file (`.xpr`) and Block Design file (`.bd`) are XML-based but change drastically with every click. They are painful to merge if two people work on them.

**The Golden Rule:**
When you get your project working (successfully generating a bitstream), run this command in the Vivado Tcl Console:
```tcl
write\_project\_tcl -paths\_relative rebuild\_project.tcl
```