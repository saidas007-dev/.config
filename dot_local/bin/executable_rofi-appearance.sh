#!/bin/bash

# --- Configuration ---
# Point this to the file you created in Step 1
ROFI_THEME="$HOME/.config/rofi/themes/appearance.rasi"

# --- Helper Functions ---

list_themes() {
    (
        [ -d "$HOME/.themes" ] && ls -1 "$HOME/.themes"
        [ -d "/usr/share/themes" ] && ls -1 "/usr/share/themes"
    ) | sort -u
}

list_icons() {
    dirs=(
        "$HOME/.icons"
        "$HOME/.local/share/icons"
        "/usr/share/icons"
    )
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            find "$dir" -maxdepth 2 -name "index.theme" | while read -r theme_path; do
                theme_name=$(basename "$(dirname "$theme_path")")
                # Filter out default/fallback themes to keep list clean
                if [[ "$theme_name" != "hicolor" && "$theme_name" != "locolor" && "$theme_name" != "breeze_cursors" ]]; then
                    echo "$theme_name"
                fi
            done
        fi
    done | sort -u
}

# --- Logic: Handle Modes ---

# 1. THEME MODE
if [[ "$1" == "themes" ]]; then
    SELECTION="$2"
    if [ -z "$SELECTION" ]; then
        list_themes
    else
        gsettings set org.cinnamon.desktop.interface gtk-theme "$SELECTION"
        gsettings set org.cinnamon.desktop.wm.preferences theme "$SELECTION"
        notify-send "🎨 Style Applied" "Theme: $SELECTION"
    fi
    exit 0
fi

# 2. ICON MODE
if [[ "$1" == "icons" ]]; then
    SELECTION="$2"
    if [ -z "$SELECTION" ]; then
        list_icons
    else
        gsettings set org.cinnamon.desktop.interface icon-theme "$SELECTION"
        notify-send "💎 Style Applied" "Icons: $SELECTION"
    fi
    exit 0
fi

# --- Main Execution ---

# If the theme file doesn't exist, warn the user
if [ ! -f "$ROFI_THEME" ]; then
    notify-send -u critical "Error" "Rofi theme file not found at $ROFI_THEME"
    exit 1
fi

# Run Rofi with custom modes
# We name the modes "Themes" and "Icons" here. 
# The .rasi file maps these names to "🎨 Themes" and "💎 Icons"
rofi \
    -modi "Themes:$0 themes,Icons:$0 icons" \
    -show Themes \
    -theme "$ROFI_THEME" \
    -sidebar-mode
