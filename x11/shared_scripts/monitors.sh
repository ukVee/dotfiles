#!/usr/bin/env bash
# Centralized monitor naming for scripts.
# Exports:
#   INTERNAL_DISPLAY  -> laptop panel (eDP/LVDS; defaults to eDP-1)
#   EXTERNAL_DISPLAY  -> external output (defaults to DP-1)
#   EXT_MON_CONNECTED -> boolean-like flag (true/false)

# Detect internal panel (first connected eDP/LVDS)
INTERNAL_DISPLAY=$(xrandr --query | awk '/ connected/ && $1 ~ /^(eDP|LVDS|edp)/ {print $1; exit}')
# Detect external (first connected non-internal)
EXTERNAL_DISPLAY=$(xrandr --query | awk '/ connected/ && $1 !~ /^(eDP|LVDS|edp)/ {print $1; exit}')

# Fallbacks for stability
: "${INTERNAL_DISPLAY:=eDP-1}"
: "${EXTERNAL_DISPLAY:=DP-1}"

# Boolean flag for external presence
if xrandr --query | grep -q "^${EXTERNAL_DISPLAY} connected"; then
  EXT_MON_CONNECTED=true
else
  EXT_MON_CONNECTED=false
fi

export INTERNAL_DISPLAY EXTERNAL_DISPLAY EXT_MON_CONNECTED
