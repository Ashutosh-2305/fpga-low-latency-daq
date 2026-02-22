# FPGA Low-Latency Trigger and Timestamped Data Acquisition

A Verilog-based simulation of a low-latency FPGA trigger architecture inspired by real-time hardware trigger systems used in high-speed data acquisition pipelines.

---

## Overview

This project implements a synchronous trigger block that compares incoming data samples against a programmable threshold and asserts a trigger output when the condition is met.

The design emphasizes deterministic latency and synchronous digital design principles.

---

## Architecture

- `trigger.v` – Threshold comparison logic
- `timestamp_counter.v` – Free-running counter
- `fifo.v` – Simple buffering module
- `tb/` – Functional verification testbenches

Trigger logic:

```verilog
trigger_out <= (data_in > threshold);
