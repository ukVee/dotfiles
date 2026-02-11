#!/bin/sh
sleep 1

# Stop all portal services cleanly via systemd
systemctl --user stop xdg-desktop-portal-hyprland.service
systemctl --user stop xdg-desktop-portal-gtk.service
systemctl --user stop xdg-desktop-portal.service

# Kill any remaining portal processes (catches strays from other sessions)
killall -q xdg-desktop-portal-hyprland
killall -q xdg-desktop-portal-gtk
killall -q xdg-desktop-portal

sleep 1

# Restart portals via systemd (proper ordering handled automatically)
systemctl --user start xdg-desktop-portal-hyprland.service
systemctl --user start xdg-desktop-portal.service
