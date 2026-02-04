#!/bin/bash

# Path to the AC online file (Standard for most laptops)
AC_PATH="/sys/class/power_supply/ADP1/online"

# Kill any existing scx_rusty instance
sudo pkill scx_rusty

# Read AC status: 1 = Plugged in, 0 = Battery
if [ "$(cat "$AC_PATH")" -eq "1" ]; then
  echo "AC Power detected. Launching scx_rusty with --perf 1024"
  sudo /usr/bin/scx_rusty --perf 512 >/dev/null 2>&1 &
else
  echo "Battery detected. Launching scx_rusty with --perf 0"
  sudo /usr/bin/scx_rusty --perf 0 >/dev/null 2>&1 &
fi
