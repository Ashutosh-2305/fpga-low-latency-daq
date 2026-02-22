# FPGA Low-Latency DAQ System

## Overview
This project simulates a modular low-latency FPGA-based trigger and timestamped data acquisition (DAQ) architecture in Verilog.

The goal is to explore deterministic real-time system design, focusing on timing constraints, modular architecture, and verification workflows.

---

## Design Constraints

Timing constraint (setup + logic delay):

T_clk > T_cq + T_logic + T_setup

Throughput consideration:

Throughput = Data Width × Clock Frequency

---

## Architecture (Planned Modules)

- Trigger logic (threshold-based event detection)
- Timestamp counter
- FIFO buffering system
- CRC integrity module
- Testbench for verification

---

## Objectives

- Implement modular RTL design
- Simulate latency-aware architecture
- Validate functionality via structured testbenches
- Extend toward fixed-point inference blocks (future work)

---

## Status

Project structure initialized. RTL implementation in progress.
