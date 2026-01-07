#!/bin/bash

# --- CONFIGURATION ---
# IMPORTANT: Update this path to match your actual wallpaper folder!
WALLPAPER_DIR="$HOME/Pictures/Wallpaper/Colorschemes/gruvbox"
THEME_FILE="$HOME/.config/rofi/themes/wallpaper.rasi"

# --- LOGIC ---

gen_list() {
  if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Directory $WALLPAPER_DIR not found"
    exit 1
  fi

  cd "$WALLPAPER_DIR" || exit 1

  # Loop through files
  # nullglob prevents errors if no files match a specific extension
  shopt -s nullglob
  for file in *.{jpg,jpeg,png,webp,JPG,JPEG,PNG}; do
    if [ -f "$file" ]; then
      # Rofi syntax: Name\0icon\x1fPath
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

  # 1. Set Wallpaper (Standard for i3)
  feh --bg-fill "$FULL_PATH"

  # 2. Update Color Scheme (Pywal) - Optional, keep if you use pywal
  if command -v wal &>/dev/null; then
    wal -i "$FULL_PATH" -n -q
  fi
fi
