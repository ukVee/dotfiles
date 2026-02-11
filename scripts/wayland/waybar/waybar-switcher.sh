#!/usr/bin/env bash
WAYBAR_AC="$HOME/.config/waybar/config-ac"
WAYBAR_BATTERY="$HOME/.config/waybar/config-battery"

get_power_state() {
    if acpi -a | grep -q "on-line"; then
        echo "AC"
    else
        echo "Battery"
    fi
}

launch_waybar() {
    local state="$1"
    pkill waybar
    sleep 0.3
    if [[ "$state" == "AC" ]]; then
        waybar -c "$WAYBAR_AC" &
    else
        waybar -c "$WAYBAR_BATTERY" &
    fi
}

# Initial launch
CURRENT_STATE=$(get_power_state)
launch_waybar "$CURRENT_STATE"

# Monitor for changes
upower --monitor | while read -r line; do
    NEW_STATE=$(get_power_state)
    if [[ "$NEW_STATE" != "$CURRENT_STATE" ]]; then
        CURRENT_STATE="$NEW_STATE"
        launch_waybar "$CURRENT_STATE"
    fi
done