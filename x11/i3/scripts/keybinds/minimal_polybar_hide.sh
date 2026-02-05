#!/bin/bash
LOCKFILE="/tmp/polybar-peek.lock"
# Only hide if scoreboard mode is active
~/.config/polybar/scripts/should_minimal_polybar_keybind_work.sh || exit 0

# Stop only peek instances to avoid killing full bars
pkill -f "polybar"

# Clear lockfile so show can relaunch later
rm -f "$LOCKFILE"
