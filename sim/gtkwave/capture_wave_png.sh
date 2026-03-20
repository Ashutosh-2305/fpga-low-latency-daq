#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 3 ]; then
    echo "usage: $0 <dump.vcd> <view.gtkw> <output.png>" >&2
    exit 1
fi

dumpfile="$1"
savefile="$2"
outfile="$3"
app="/Applications/gtkwave.app/Contents/MacOS/gtkwave"

if [ ! -f "$dumpfile" ]; then
    echo "missing dumpfile: $dumpfile" >&2
    exit 1
fi

if [ ! -f "$savefile" ]; then
    echo "missing savefile: $savefile" >&2
    exit 1
fi

"$app" --dump "$dumpfile" --save "$savefile" >/dev/null 2>&1 &
gtkwave_pid=$!

sleep 3

window_id="$(osascript <<'APPLESCRIPT'
tell application "System Events"
    tell process "gtkwave"
        set frontmost to true
        delay 1
        set winid to value of attribute "AXWindowNumber" of front window
    end tell
end tell
return winid
APPLESCRIPT
)"

screencapture -x -l "$window_id" "$outfile"

osascript <<'APPLESCRIPT' >/dev/null 2>&1 || true
tell application "System Events"
    tell process "gtkwave"
        keystroke "q" using command down
    end tell
end tell
APPLESCRIPT

wait "$gtkwave_pid" || true
