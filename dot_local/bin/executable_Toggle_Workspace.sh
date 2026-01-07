#!/bin/bash

# -----------------------------
<<<<<<< HEAD
# Workspace Wallpaper Toggle Script for Linux Mint Cinnamon
# -----------------------------

# Path to your wallpaper folder
wallpaper_dir="/home/kanashii/Pictures/Wallpaper/Workspaces"

=======
# Fast Workspace Toggle (No Wallpaper)
# -----------------------------

>>>>>>> 80b87be (7 Jan Wednesday , 21:16 i3 and Polybar (Updated))
# Ensure wmctrl is installed
if ! command -v wmctrl &> /dev/null; then
    echo "wmctrl not found. Install it with: sudo apt install wmctrl"
    exit 1
fi

<<<<<<< HEAD
# Ensure dconf is installed
if ! command -v dconf &> /dev/null; then
    echo "dconf not found. Install it with: sudo apt install dconf-cli"
    exit 1
fi

=======
>>>>>>> 80b87be (7 Jan Wednesday , 21:16 i3 and Polybar (Updated))
# Get current workspace index
current=$(wmctrl -d | awk '/\*/{print $1}')

# Get total number of workspaces
total=$(wmctrl -d | wc -l)

# Calculate next workspace (wrap around)
next=$(( (current + 1) % total ))

<<<<<<< HEAD
# Switch to the next workspace
wmctrl -s "$next"

# Small pause to ensure workspace switches completely
sleep 0.3

# Determine wallpaper path (expects 1.jpg, 2.jpg, ...)
wallpaper="$wallpaper_dir/$((next + 1)).jpg"

# Apply wallpaper if it exists
if [ -f "$wallpaper" ]; then
    # Use dconf to set the wallpaper for Cinnamon
    dconf write /org/cinnamon/desktop/background/picture-uri "'file://$wallpaper'"
else
    echo "Wallpaper not found: $wallpaper"
fi
=======
# Switch to the next workspace immediately
wmctrl -s "$next"
>>>>>>> 80b87be (7 Jan Wednesday , 21:16 i3 and Polybar (Updated))
