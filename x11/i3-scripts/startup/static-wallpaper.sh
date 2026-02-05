#!/usr/bin/env bash
# set_wallpaper.sh — choose wallpaper depending on number of monitors

source "$HOME/.config/hardware/monitors.sh"

MON_COUNT=$(xrandr --query | grep " connected" | wc -l)

WALL_DIR="/mnt/backup/photos/wallpapers"
WALL_SINGLE="$WALL_DIR/arch_void.png"

if ! $EXT_MON_CONNECTED; then
  # single monitor case
  feh --no-fehbg --bg-fill "$WALL_SINGLE"
elif [ "$MON_COUNT" -ge 2 ]; then
  # two or more monitors: take first two monitors
  # you could handle more monitors if you want
  feh --no-fehbg --bg-max "$WALL_SINGLE" "$WALL_SINGLE"
else
  # fallback: single
  feh --no-fehbg --bg-fill "$WALL_SINGLE"
fi

exit 0
