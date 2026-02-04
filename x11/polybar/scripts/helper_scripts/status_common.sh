#!/usr/bin/env bash
# Shared network and battery helpers for polybar (full + peek)

network_status() {
  local iface ssid short_ssid signal
  local rx_now rx_prev rx_speed_mbps cache_dir cache_file now_ns prev_ns delta_rx delta_ns

  iface=$(nmcli -t -f device,type,state dev | grep ":wifi:connected" | cut -d: -f1)
  if [ -z "$iface" ]; then
    echo "DIS|--|0MB/s"
    return
  fi

  ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
  short_ssid=$(echo "$ssid" | awk '{for(i=1;i<=NF;i++) printf "%s", substr($i,1,1); print ""}')
  short_ssid=${short_ssid:0:5}

  # Prefer /proc/net/wireless for real-time quality, fallback to nmcli
  if grep -q "$iface" /proc/net/wireless 2>/dev/null; then
    signal=$(awk -v iface="$iface" 'NR>2 && $1 ~ iface {print int($3)}' /proc/net/wireless)
  else
    signal=$(nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d: -f2)
  fi
  [ -z "$signal" ] && signal=0

  cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/polybar"
  cache_file="${cache_dir}/${iface}_rx_state"
  mkdir -p "$cache_dir"

  rx_now=$(cat "/sys/class/net/${iface}/statistics/rx_bytes")
  now_ns=$(date +%s%N)

  if [ -r "$cache_file" ]; then
    read -r rx_prev prev_ns <"$cache_file"
  else
    rx_prev=$rx_now
    prev_ns=$now_ns
  fi

  echo "$rx_now $now_ns" >"$cache_file"

  delta_rx=$((rx_now - rx_prev))
  delta_ns=$((now_ns - prev_ns))
  [ "$delta_rx" -lt 0 ] && delta_rx=0
  [ "$delta_ns" -le 0 ] && delta_ns=1

  rx_speed_mbps=$(awk -v bytes="$delta_rx" -v nanos="$delta_ns" 'BEGIN {printf "%.2f", (bytes*1e9/nanos)/(1024*1024)}')

  echo "${short_ssid}|${signal}|${rx_speed_mbps}MB/s"
}

battery_status() {
  local acpi_out percent time status output
  acpi_out=$(acpi -b | head -1)
  percent=$(echo "$acpi_out" | grep -o '[0-9]\+%' | tr -d '%')
  time=$(echo "$acpi_out" | grep -o '[0-9]\+:[0-9]\+' | head -1)
  status=$(echo "$acpi_out" | awk -F'[ ,]+' '{print $3}')

  [ -z "$time" ] && time="--:--"

  case "$status" in
    Charging)    output="⌃${percent}%";;
    Discharging) output="⌄${percent}% $time";;
    Full|Unknown|NotCharging) output="FUL";;
    *) output="--";;
  esac

  if [[ "$percent" -le 15 && "$status" == "Discharging" ]]; then
    output="LOW ${percent}"
  fi

  echo "$output"
}
