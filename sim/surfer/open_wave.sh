#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: $0 <tb_trigger|tb_timestamp|tb_fifo|tb_crc8|tb_daq_frontend>" >&2
    exit 1
fi

bench="$1"
wave="sim/waves/$bench.vcd"
command_file=""

if [ ! -f "$wave" ]; then
    echo "missing waveform: $wave" >&2
    echo "run 'make test' first" >&2
    exit 1
fi

if [ -f "sim/surfer/$bench.sucl" ]; then
    command_file="sim/surfer/$bench.sucl"
    exec surfer "$wave" --command-file "$command_file"
fi

exec surfer "$wave"
