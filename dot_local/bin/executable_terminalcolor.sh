#!/bin/bash

# List of aesthetic color combinations (foreground : background)
schemes=(
    # --- The Classics (Soft & Muted) ---
    "#ebdbb2:#282828"   # Gruvbox Dark (Cream on Dark Earth)
    "#d8dee9:#2e3440"   # Nord (Ice White on Polar Night)
    "#c0caf5:#1a1b26"   # Tokyo Night (Periwinkle on Deep Blue)
    "#bd93f9:#282a36"   # Dracula (Soft Purple on Dark Grey)
    "#d3c6aa:#2d353b"   # Everforest (Warm Grey on Greenish-Dark)
    "#abb2bf:#282c34"   # One Dark (Soft Grey on Atom Dark)
    "#cbccc6:#1f2430"   # Ayu Dark (Mirage)

    # --- Rose Pine / Vibe ---
    "#e0def4:#191724"   # Rose Pine Main (Soft White on Deep Iris)
    "#ebbcba:#1f1d2e"   # Rose Pine Rose (Muted Pink on Dark)
    "#f6c177:#191724"   # Rose Pine Gold (Soft Gold on Deep Iris)
    "#9ccfd8:#26233a"   # Rose Pine Foam (Soft Cyan on Muted Purple)

    # --- Kanagawa / Samurai ---
    "#dcd7ba:#1f1f28"   # Kanagawa (Fuji White on Sumi Ink)
    "#7e9cd8:#1f1f28"   # Kanagawa Blue (Crystal Blue on Sumi Ink)
    "#ffa066:#1f1f28"   # Kanagawa Orange (Surimi Orange on Sumi Ink)

    # --- Catppuccin Variations ---
    "#89b4fa:#1e1e2e"   # Catppuccin Blue on Mocha
    "#f5c2e7:#1e1e2e"   # Catppuccin Pink on Mocha
    "#a6e3a1:#1e1e2e"   # Catppuccin Green on Mocha
    "#f9e2af:#1e1e2e"   # Catppuccin Yellow on Mocha
    "#cba6f7:#11111b"   # Catppuccin Mauve on Crust (Darker)

    # --- Nature / Earthy Mixes ---
    "#b8bb26:#1d2021"   # Retro Moss (Muted Lime on Asphalt)
    "#8ec07c:#282828"   # Aqua mix (Sage Green on Dark Brown)
    "#dbbc7f:#2d353b"   # Sand on Swamp (Beige on Deep Green)

    # --- Space / Deep Sea ---
    "#80cbc4:#263238"   # Material Palenight (Teal on Slate)
    "#82aaff:#0f111a"   # Deep Space (Soft Blue on Void)
    "#ffcb6b:#263238"   # Firefly (Soft Orange on Slate)
    "#c792ea:#090b10"   # Nebula (Violet on Black Hole)

    # --- Pastels ---
    "#96cdfb:#16161e"   # Pastel Blue on Night
    "#fae3b0:#1a1826"   # Creamy Yellow on Dark Purple
    "#abe9b3:#1a1b26"   # Mint on Midnight
)

# Get the default GNOME Terminal profile ID
profile_id=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

# Infinite loop — change every 10 seconds
while true; do
    choice=${schemes[$RANDOM % ${#schemes[@]}]}
    IFS=':' read -r fg bg <<< "$choice"

    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile_id/" foreground-color "$fg"
    gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile_id/" background-color "$bg"

    sleep 10
done
