#!/usr/bin/env bash

# Define the theme path
THEME="$HOME/.config/rofi/themes/powermenu.rasi"

# Icons (Lock, Reboot, Shutdown, Restart i3)
options="󰌾\n󰜉\n󰐥\n󰑐"

# Launch rofi
selected="$(echo -e "$options" | rofi -dmenu -i -p "System" -theme "$THEME")"

# Execute commands based on the exact icon selected
case "$selected" in
    "󰌾") cinnamon-screensaver-command -l || i3lock ;;
    "󰜉") systemctl reboot ;;
    "󰐥") systemctl poweroff ;;
    "󰑐") i3-msg restart ;;
esac
