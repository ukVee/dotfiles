#!/usr/bin/env bash

# --- Monitor detection (shared map) ---
source "$HOME/.config/hardware/monitors.sh"

# If single-monitor laptop mode → DO NOT AUTOSTART POLYBAR
if ! $EXT_MON_CONNECTED; then
  echo "Laptop mode detected — skipping full Polybar autostart."
  exit 0
fi

# --- Normal multi-monitor Polybar startup ---
pkill -x polybar

while pgrep -x polybar >/dev/null; do sleep 0.1; done

CONFIG="$HOME/.config/polybar/config.ini"

if type "xrandr" >/dev/null 2>&1; then
  for m in $(xrandr --query | grep " connected" | cut -d ' ' -f1); do
    if [ "$m" = "$EXTERNAL_DISPLAY" ]; then
      polybar -c "$CONFIG" extendedcherrybar &
      echo "ecb launched on $m."
    else
      polybar -c "$CONFIG" cherrybar &
      echo "cb launched on $m."
    fi
  done
else
  polybar -c "$CONFIG" cherrybar &
fi

$HOME/.config/polybar/scripts/masks/apply-edge-rhombus-mask.sh
