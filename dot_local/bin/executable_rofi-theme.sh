#!/bin/bash

# --- Configuration ---
ROFI_THEME="$HOME/.config/rofi/theme.rasi"  # Using your existing rofi theme style
# You can change the above line to: rofi -dmenu -i -p "Select Theme" if you prefer default look

# --- Logic ---

# 1. Get a list of unique theme names
# We look in ~/.themes and /usr/share/themes, list the folders, and remove duplicates
get_themes() {
    (
        [ -d "$HOME/.themes" ] && ls -1 "$HOME/.themes"
        [ -d "/usr/share/themes" ] && ls -1 "/usr/share/themes"
    ) | sort -u
}

# 2. Run Rofi to select a theme
SELECTED_THEME=$(get_themes | rofi -dmenu -i -theme "$ROFI_THEME" -p "Themes")

# 3. Apply the theme if one was selected
if [ -n "$SELECTED_THEME" ]; then
    echo "Applying theme: $SELECTED_THEME"
    
    # Change the "Controls" (GTK Theme)
    gsettings set org.cinnamon.desktop.interface gtk-theme "$SELECTED_THEME"
    
    # Change the "Window Borders" (Metacity/Muffin)
    # We try to set it to the same name. If the theme doesn't have borders, it might revert to default, 
    # but usually modern themes include both.
    gsettings set org.cinnamon.desktop.wm.preferences theme "$SELECTED_THEME"

    # Send a notification
    notify-send "Theme Changed" "Active theme: $SELECTED_THEME"
fi
