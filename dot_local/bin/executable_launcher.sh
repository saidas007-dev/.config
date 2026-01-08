#!/bin/bash

# --- Configuration ---

THEME="$HOME/.config/rofi/themes/i3menu.rasi"
# --- Power Menu Options ---
# Format: "Title" "Command" "Icon"
declare -A power_actions
power_actions=(
  [" Shutdown"]="systemctl poweroff"
  [" Reboot"]="systemctl reboot"
  [" Lock"]="i3lock --color 1e1e2e" # Basic dark lock. Use 'betterlockscreen -l' if installed.
  [" Suspend"]="systemctl suspend"
  [" Logout"]="i3-msg exit" # The correct way to exit i3wm
)

# Order of appearance
options=" Shutdown\n Reboot\n Suspend\n Lock\n Logout"

# --- Logic ---

# 1. If script is run with no arguments, Launch Rofi
# We define two modes: 'drun' (Apps) and 'Power' (This script running in mode 2)
if [ -z "$@" ]; then
  rofi -show drun \
    -modi "drun,Power:$0 --mode" \
    -theme "$THEME"
  exit 0
fi

# 2. If run in 'Power' mode (by Rofi)
if [ "$1" == "--mode" ]; then
  # If no selection ($2 is empty), print the list
  if [ -z "$2" ]; then
    echo -e "$options"
  else
    # Execute the command associated with the selected title
    action="${power_actions[$2]}"
    if [ ! -z "$action" ]; then
      # Detach and run.
      # 'nohup' ensures the command continues even if the terminal/rofi closes.
      nohup $action >/dev/null 2>&1 &
      exit 0
    fi
  fi
fi
