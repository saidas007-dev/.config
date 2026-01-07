#!/bin/bash

# --- CONFIGURATION ---
# DOUBLE CHECK: Is it "Wallpaper" or "Wallpapers"? Linux is case-sensitive!
<<<<<<< HEAD
WALLPAPER_DIR="/home/kanashii/Pictures/Wallpaper/Github/nord"
THEME_FILE="$HOME/.config/rofi/wallpaper.rasi"
=======
WALLPAPER_DIR="/home/kanashii/Pictures/Wallpaper/Colorschemes/gruvbox"
THEME_FILE="$HOME/.config/rofi/themes/wallpaper.rasi"
>>>>>>> 80b87be (7 Jan Wednesday , 21:16 i3 and Polybar (Updated))

# --- LOGIC ---

gen_list() {
    cd "$WALLPAPER_DIR" || { echo "Directory not found"; exit 1; }

    # Loop through files
    for file in *.{jpg,jpeg,png,webp,JPG,JPEG,PNG}; do
        if [ -f "$file" ]; then
            # We use printf here.
            # %s\0icon\x1f%s/%s\n means: Print Filename, then Null, then Icon Tag, then Full Path
            printf "%s\0icon\x1f%s/%s\n" "$file" "$WALLPAPER_DIR" "$file"
        fi
    done
}

# Run Rofi
SELECTED=$(gen_list | rofi -dmenu -i -show-icons \
    -theme "$THEME_FILE" \
    -p "Wallpaper")

# Apply Selection
if [ -n "$SELECTED" ]; then
    FULL_PATH="$WALLPAPER_DIR/$SELECTED"
    gsettings set org.cinnamon.desktop.background picture-uri "file://$FULL_PATH"
    gsettings set org.cinnamon.desktop.background picture-uri-dark "file://$FULL_PATH"
    wal -i "$FULL_PATH" -n -q
fi
