#!/usr/bin/env bash
# apply-mask.sh — applies rhombus mask to peek bar
source "$HOME/.config/hardware/monitors.sh"

BAR_NAME="polybar-peek"
while ! xwininfo -name $BAR_NAME >/dev/null; do sleep 0.05; done

MASK_FILE="${2:-$HOME/.config/polybar/shapeMask/70wtoplongrhombusmask.xbm}"

# get Polybar window ID
BAR_WIN=$(xwininfo -name "$BAR_NAME" | awk '/Window id:/{print $4}')

if [[ -z "$BAR_WIN" ]]; then
  echo "❌ Could not find window for $BAR_NAME"
  exit 1
fi

# apply mask
~/.local/bin/xshape-helper -id "$BAR_WIN" -mask "$MASK_FILE"
