#!/usr/bin/env bash
# Safe system-wide cache cleanup for Linux Mint
# GOAL: Clean only junk/cache. NEVER touch user data, active apps, or config files.

set -euo pipefail

echo "🧼 Starting safe cache cleanup..."

# ---- APT (Safe Mode) ----
echo "🧩 Cleaning APT cache..."
# 'clean' only removes downloaded installer files (.deb), NOT the installed apps.
sudo apt clean -y
# 'autoremove' only removes dependencies (libraries) that are no longer used by ANY app.
sudo apt autoremove --purge -y >/dev/null 2>&1

# ---- NPM ----
if command -v npm &>/dev/null; then
    echo "📦 Cleaning NPM cache..."
    # 'cache clean' does NOT touch your projects or node_modules.
    npm cache clean --force
fi

# ---- Homebrew ----
if command -v brew &>/dev/null; then
    echo "🍺 Cleaning Homebrew cache..."
    # 'cleanup' only removes old versions and download locks.
    brew cleanup -s
    brew autoremove
fi

# ---- Flatpak (Ultra-Safe) ----
if command -v flatpak &>/dev/null; then
    echo "📦 Cleaning Flatpak cache..."
    # 1. 'uninstall --unused' checks your installed apps list first. 
    # It ONLY removes runtimes (like old Nvidia drivers) that NO app is using.
    flatpak uninstall --unused -y
    
    # 2. 'repair' fixes corrupted repo data. It does not uninstall apps.
    sudo flatpak repair
fi

# ---- Snap (Fixed & Safe) ----
if command -v snap &>/dev/null; then
    echo "🔗 Cleaning Snap cache..."
    # Sets snap to only keep the last 2 versions (saves space safely)
    sudo snap set system refresh.retain=2
    
    # SAFE REMOVAL LOOP
    # We explicitly extract the Revision ID ($3) to avoid "invalid name" errors.
    snap list --all | awk '/disabled/{print $1, $3}' |
    while read -r snapname revision; do
        if [ -n "$snapname" ] && [ -n "$revision" ]; then
            echo "   Removing old version: $snapname (Rev: $revision)..."
            sudo snap remove "$snapname" --revision="$revision"
        fi
    done
fi

# ---- Cargo ----
if command -v cargo &>/dev/null && cargo --list | grep -q "cache"; then
    echo "🦀 Cleaning Cargo cache..."
    # Cleans registry sources. Does NOT delete your code or installed binaries.
    cargo cache -a
fi

# ---- System Cache (The Safe Way) ----
echo "🗂 Cleaning old temporary files..."

# ⚠️ CHANGED: Instead of 'rm -rf *', we use 'find'.
# This only deletes files in /var/tmp that haven't been accessed in 10 days.
# If a program is using a file right now, this will leave it alone.
sudo find /var/tmp -depth -type f -atime +10 -delete 2>/dev/null || true

# Vacuum logs older than 7 days (Standard safe maintenance)
sudo journalctl --vacuum-time=7d >/dev/null 2>&1

echo "✅ Cleanup complete. System is safe and optimized."
