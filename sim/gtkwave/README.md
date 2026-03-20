# GTKWave Capture Flow

Run the regression first so the VCD files exist:

```bash
make test
```

Open a waveform with preselected signals:

```bash
/Applications/gtkwave.app/Contents/MacOS/gtkwave --dump sim/waves/tb_trigger.vcd --save sim/gtkwave/tb_trigger.gtkw
/Applications/gtkwave.app/Contents/MacOS/gtkwave --dump sim/waves/tb_timestamp.vcd --save sim/gtkwave/tb_timestamp.gtkw
/Applications/gtkwave.app/Contents/MacOS/gtkwave --dump sim/waves/tb_fifo.vcd --save sim/gtkwave/tb_fifo.gtkw
/Applications/gtkwave.app/Contents/MacOS/gtkwave --dump sim/waves/tb_crc8.vcd --save sim/gtkwave/tb_crc8.gtkw
/Applications/gtkwave.app/Contents/MacOS/gtkwave --dump sim/waves/tb_daq_frontend.vcd --save sim/gtkwave/tb_daq_frontend.gtkw
```

Capture a PNG of the front GTKWave window on macOS:

```bash
./sim/gtkwave/capture_wave_png.sh sim/waves/tb_trigger.vcd sim/gtkwave/tb_trigger.gtkw docs/tb_trigger.png
./sim/gtkwave/capture_wave_png.sh sim/waves/tb_timestamp.vcd sim/gtkwave/tb_timestamp.gtkw docs/tb_timestamp.png
./sim/gtkwave/capture_wave_png.sh sim/waves/tb_fifo.vcd sim/gtkwave/tb_fifo.gtkw docs/tb_fifo.png
./sim/gtkwave/capture_wave_png.sh sim/waves/tb_crc8.vcd sim/gtkwave/tb_crc8.gtkw docs/tb_crc8.png
./sim/gtkwave/capture_wave_png.sh sim/waves/tb_daq_frontend.vcd sim/gtkwave/tb_daq_frontend.gtkw docs/tb_daq_frontend.png
```

Notes:

- The capture script uses `System Events` and `screencapture`, so macOS may ask for Accessibility or Screen Recording permission the first time.
- If you want tighter framing, open the waveform once manually, adjust zoom and signal pane widths, then resave the `.gtkw` file from GTKWave before rerunning the capture script.
