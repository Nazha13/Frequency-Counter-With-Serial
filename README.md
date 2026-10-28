# Frequency Counter With Serial

This a custom digital logic design of a frequency counter (measuring from 5 Hz to 9999 Hz) fully verified via behavioral simulation and optimized for the
**Digilent Nexys A7-50T (Artix-7)** FPGA board. This system features a custom-built UART transmitter module and a display controller due to the board having a multiplexed seven segment display.

---

# Hardware & Software Specs

Target FPGA Board : Digilent Nexys A7-50T
Software Environment : Xilinx Design Suite
Hardware Description Language : VHDL
Global Clock : 50 MHz (MMCM Output)
UART Params : 115200 baud

# Vivado Synthesis & Implementation Summary

| Parameter | Metric / Value | 
| :--- | :---: | 
| **Logic Utilization (LUT)** | 1% | 
| **Register Utilization (FF)** | 1% | 
| **I/O Pins Used** | 9% | 
| **Worst Negative Slack (WNS)** | 10.544 ns | 
| **Total On-Chip Power** | 0.171 W | 
| **Junction Temperature** | 25.8°C | 
