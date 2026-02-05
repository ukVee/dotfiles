#!/bin/bash

# Ensure we are using the Nvidia card if available (for your Prime setup)
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia

if systemctl --user is-active --quiet picom.service; then
  systemctl --user stop picom.service
  # Force kill just in case it hangs on the Nvidia driver
  killall -q picom
else
  # Clear any dead atoms before starting
  killall -q picom
  systemctl --user start picom.service
fi
