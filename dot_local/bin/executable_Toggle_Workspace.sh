#!/bin/bash

# -----------------------------
# Fast Workspace Toggle (No Wallpaper)
# -----------------------------

# Ensure wmctrl is installed
if ! command -v wmctrl &> /dev/null; then
    echo "wmctrl not found. Install it with: sudo apt install wmctrl"
    exit 1
fi

# Get current workspace index
current=$(wmctrl -d | awk '/\*/{print $1}')

# Get total number of workspaces
total=$(wmctrl -d | wc -l)

# Calculate next workspace (wrap around)
next=$(( (current + 1) % total ))

# Switch to the next workspace immediately
wmctrl -s "$next"
