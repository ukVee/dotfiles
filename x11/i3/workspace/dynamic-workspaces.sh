#!/bin/bash

# Shared monitor naming
source "$HOME/.config/hardware/monitors.sh"

ASSIGN_FILE="$HOME/.config/i3/workspace_assignments.conf"
NEW_CONTENT=""
MAX_WS=8

# --- 1. GENERATE DYNAMIC CONTENT ---
for ((i = 1; i <= MAX_WS; i++)); do
  if ((i % 2 != 0)); then
    # Odd: Internal -> External
    NEW_CONTENT+="workspace $i output $INTERNAL_DISPLAY $EXTERNAL_DISPLAY"$'\n'
  else
    # Even: External -> Internal
    NEW_CONTENT+="workspace $i output $EXTERNAL_DISPLAY $INTERNAL_DISPLAY"$'\n'
  fi
done

# Check if file needs updating (trim trailing newline for comparison)
if [ ! -f "$ASSIGN_FILE" ] || [ "${NEW_CONTENT%$'\n'}" != "$(cat "$ASSIGN_FILE")" ]; then
  echo -n "$NEW_CONTENT" >"$ASSIGN_FILE"
  echo "Updating workspace assignments and reloading i3..."
  i3-msg reload
  exit 0
fi

# --- 2. RUNTIME CORRECTION ---

for ((i = 1; i <= MAX_WS; i++)); do
  if ((i % 2 == 0)) && $EXT_MON_CONNECTED; then
    # Move evens to external if it exists
    i3-msg "workspace $i; move workspace to output $EXTERNAL_DISPLAY" >/dev/null 2>&1
  else
    # Move odds (or evens if no external) to internal
    i3-msg "workspace $i; move workspace to output $INTERNAL_DISPLAY" >/dev/null 2>&1
  fi
done

# Set focus based on connection state
if $EXT_MON_CONNECTED; then
  i3-msg "focus output $EXTERNAL_DISPLAY; workspace 2" >/dev/null
  i3-msg "focus output $INTERNAL_DISPLAY; workspace 1" >/dev/null
else
  i3-msg "workspace 1" >/dev/null
fi
