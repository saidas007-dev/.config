#!/bin/bash

# --- Configuration ---
ROFI_THEME="$HOME/.config/rofi/themes/appearance.rasi"
GTK_CONFIG_DIR="$HOME/.config/gtk-3.0"
GTK_SETTINGS_FILE="$GTK_CONFIG_DIR/settings.ini"
GTKRC_FILE="$HOME/.gtkrc-2.0"

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
                if [[ "$theme_name" != "hicolor" && "$theme_name" != "locolor" && "$theme_name" != "breeze_cursors" ]]; then
                    echo "$theme_name"
                fi
            done
        fi
    done | sort -u
}

update_ini_file() {
    # Usage: update_ini_file "file_path" "key" "value"
    local file="$1"
    local key="$2"
    local value="$3"

    # Create file if missing
    if [ ! -f "$file" ]; then
        # If it's settings.ini, we need the [Settings] header
        if [[ "$file" == *settings.ini ]]; then
            echo "[Settings]" > "$file"
        else
            touch "$file"
        fi
    fi

    # Check if key exists
    if grep -q "^$key=" "$file"; then
        # Key exists, replace it
        sed -i "s|^$key=.*|$key=$value|" "$file"
    else
        # Key missing. If it's settings.ini, try to put it after [Settings]
        if [[ "$file" == *settings.ini ]]; then
            # If [Settings] exists, append after it. Otherwise just append to end.
            if grep -q "\[Settings\]" "$file"; then
                sed -i "/\[Settings\]/a $key=$value" "$file"
            else
                echo "$key=$value" >> "$file"
            fi
        else
            # For .gtkrc-2.0, just append
            echo "$key=$value" >> "$file"
        fi
    fi
}

apply_gtk_theme() {
    THEME="$1"

    # 1. Gsettings
    gsettings set org.gnome.desktop.interface gtk-theme "$THEME"

    # 2. GTK 3 (settings.ini)
    mkdir -p "$GTK_CONFIG_DIR"
    update_ini_file "$GTK_SETTINGS_FILE" "gtk-theme-name" "$THEME"

    # 3. GTK 2 (.gtkrc-2.0)
    # Note: GTK2 uses quotes around values, e.g., gtk-theme-name="Theme"
    update_ini_file "$GTKRC_FILE" "gtk-theme-name" "\"$THEME\""

    notify-send "🎨 Theme Set" "$THEME"
}

apply_icon_theme() {
    ICON="$1"

    # 1. Gsettings
    gsettings set org.gnome.desktop.interface icon-theme "$ICON"

    # 2. GTK 3 (settings.ini)
    mkdir -p "$GTK_CONFIG_DIR"
    update_ini_file "$GTK_SETTINGS_FILE" "gtk-icon-theme-name" "$ICON"

    # 3. GTK 2 (.gtkrc-2.0)
    update_ini_file "$GTKRC_FILE" "gtk-icon-theme-name" "\"$ICON\""

    notify-send "💎 Icons Set" "$ICON"
}

# --- Logic: Handle Modes ---

if [[ "$1" == "themes" ]]; then
    SELECTION="$2"
    if [ -z "$SELECTION" ]; then
        list_themes
    else
        apply_gtk_theme "$SELECTION"
    fi
    exit 0
fi

if [[ "$1" == "icons" ]]; then
    SELECTION="$2"
    if [ -z "$SELECTION" ]; then
        list_icons
    else
        apply_icon_theme "$SELECTION"
    fi
    exit 0
fi

# --- Main Execution ---

if [ ! -f "$ROFI_THEME" ]; then
    notify-send -u critical "Error" "Rofi theme file not found!"
    exit 1
fi

rofi \
    -modi "Themes:$0 themes,Icons:$0 icons" \
    -show Themes \
    -theme "$ROFI_THEME" \
    -no-show-icons \
    -sidebar-mode
