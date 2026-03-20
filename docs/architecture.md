# Architecture Notes

## Event Timing

The timestamp stored by `rtl/daq_frontend.v` is the counter value present on the same clock edge that detects the trigger condition. This gives a stable cycle identifier for each accepted event.

## Packet Format

Each FIFO entry uses this packed layout:

```text
[55:24] timestamp
[23:8]  data sample
[7:0]   crc8
```

## Verification Strategy

The repository uses self-checking testbenches instead of relying only on manual waveform inspection:

- Each testbench tracks mismatches with a local failure counter
- Any mismatch ends the simulation with `$fatal`
- VCD files are still emitted into `sim/waves/` for visual review

This keeps the project suitable both for demonstration and for repeatable regression runs.
