# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository managed by [toml-bombadil](https://oknozor.github.io/toml-bombadil/), a Rust-based dotfiles manager that supports templating and profiles.

## Commands

```bash
# Link all dotfiles (shared + active profile)
bombadil link

# Link with a specific profile
bombadil link -p x11
bombadil link -p wayland

# Watch for changes and auto-relink
bombadil link -w
```

## Architecture

### Directory Structure
- `bombadil.toml` - Main configuration defining dotfile mappings and profiles
- `vars/colors.toml` - Color palette variables used for templating
- `shared/` - Configs linked regardless of profile (kitty, nvim, starship, btop, etc.)
- `x11/` - X11-specific configs (i3, polybar, picom, dunst, rofi)
- `wayland/` - Wayland-specific configs (currently empty, planned for hyprland)
- `hooks/` - Pre/post hooks for bombadil operations

### Templating System
Bombadil uses `__variable__` syntax for variable substitution. Variables defined in `vars/colors.toml` get injected into config files during linking.

Example in `shared/kitty/kitty.conf`:
```
background __background__
foreground __foreground__
color0 __color0__
```

### Profiles
- **x11**: Active profile for X11/i3 setup. Has posthooks that reload i3 and polybar after linking.
- **wayland**: Placeholder for future Hyprland setup.

Shared configs are always linked. Profile-specific configs are only linked when that profile is active.

### i3 Config Structure
The i3 config (`x11/i3/config`) uses modular includes:
- `color.conf` - Window border colors
- `startup.conf` - Autostart applications
- `window_rules.conf` - Per-window floating/workspace rules
- `keybinds/` - Keybind configs split by category (navigation, workspace, volume, etc.)
- `i3_modes/` - Mode definitions (resize, etc.)
- `scripts/` - Shell scripts for startup, keybinds, and workspace management
