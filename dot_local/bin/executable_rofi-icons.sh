#!/bin/bash

# --- Configuration ---
ROFI_THEME="$HOME/.config/rofi/theme.rasi"

# --- Logic ---

get_icons() {
    dirs=(
        "$HOME/.icons"
        "$HOME/.local/share/icons"
        "/usr/share/icons"
    )

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            find "$dir" -maxdepth 2 -name "index.theme" | while read -r theme_path; do
                theme_name=$(basename "$(dirname "$theme_path")")
                if [[ "$theme_name" != "hicolor" && "$theme_name" != "locolor" && "$theme_name" != "breeze_cursors" ]]; then
                    echo "$theme_name"
                fi
            done
        fi
    done | sort -u
}

# Run Rofi
ICONS_LIST=$(get_icons)

if [ -z "$ICONS_LIST" ]; then
    # Keeping this error notification just in case the list is empty
    notify-send -u critical "Error" "No icon themes found."
    exit 1
fi

SELECTED_ICON=$(echo "$ICONS_LIST" | rofi -dmenu -i -theme "$ROFI_THEME" -p "Icons")

# Apply Selection
if [ -n "$SELECTED_ICON" ]; then
    # Set the Icon Theme silently
    gsettings set org.cinnamon.desktop.interface icon-theme "$SELECTED_ICON"
fi
