# Surfer Waveform Views

This repository uses Surfer for waveform inspection.

## Quick Start

Generate the verified VCDs:

```bash
make test
```

Open a waveform in Surfer with a preloaded view:

```bash
./sim/surfer/open_wave.sh tb_trigger
./sim/surfer/open_wave.sh tb_daq_frontend
```

Equivalent `make` targets:

```bash
make view TB=tb_trigger
make view TB=tb_daq_frontend
```

## Available VCD Files

- `sim/waves/tb_trigger.vcd`
- `sim/waves/tb_timestamp.vcd`
- `sim/waves/tb_fifo.vcd`
- `sim/waves/tb_crc8.vcd`
- `sim/waves/tb_daq_frontend.vcd`

## Preloaded Surfer Views

The repository includes Surfer command files for the two most presentation-ready views:

- `sim/surfer/tb_trigger.sucl`
- `sim/surfer/tb_daq_frontend.sucl`

These preload the recommended signals and run `zoom_fit` so the traces open in a review-ready layout.

## Recommended Signals By Testbench

- `tb_trigger`: `tb_trigger.clk`, `tb_trigger.rst`, `tb_trigger.data_in`, `tb_trigger.threshold`, `tb_trigger.trigger_out`
- `tb_timestamp`: `tb_timestamp.clk`, `tb_timestamp.rst`, `tb_timestamp.enable`, `tb_timestamp.timestamp`
- `tb_fifo`: `tb_fifo.clk`, `tb_fifo.rst`, `tb_fifo.wr_en`, `tb_fifo.rd_en`, `tb_fifo.din`, `tb_fifo.dout`, `tb_fifo.level`, `tb_fifo.full`, `tb_fifo.empty`
- `tb_crc8`: `tb_crc8.data_in`, `tb_crc8.corrupted_data`, `tb_crc8.crc_out`, `tb_crc8.crc_out_corrupt`
- `tb_daq_frontend`: `tb_daq_frontend.clk`, `tb_daq_frontend.rst`, `tb_daq_frontend.enable`, `tb_daq_frontend.data_in`, `tb_daq_frontend.threshold`, `tb_daq_frontend.trigger_out`, `tb_daq_frontend.timestamp_now`, `tb_daq_frontend.event_timestamp`, `tb_daq_frontend.event_data`, `tb_daq_frontend.event_valid`, `tb_daq_frontend.read_en`, `tb_daq_frontend.fifo_level`, `tb_daq_frontend.fifo_full`, `tb_daq_frontend.fifo_empty`, `tb_daq_frontend.fifo_dout`

## About State Files

Surfer supports `.surf.ron` state files and can load them with `--state-file`. In this repository, the preloaded views are defined with `.sucl` command files because they are deterministic, text-based, and easy to review in Git. If you adjust a view interactively in Surfer, you can save a `.surf.ron` file back into `sim/surfer/` and reopen it later with:

```bash
surfer sim/waves/tb_daq_frontend.vcd --state-file sim/surfer/your_saved_view.surf.ron
```
