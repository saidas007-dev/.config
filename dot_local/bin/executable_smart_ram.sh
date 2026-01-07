#!/bin/bash
# Smart RAM Manager
# Safe to run repeatedly. Only restarts Cinnamon if necessary.

# --- CONFIGURATION ---
# The RAM limit (in MB) where we consider usage "Too High".
# You have 16GB total. If usage goes above 4000MB (4GB), we act.
MAX_RAM_MB=6000
# ---------------------

# 1. Get current "Used" RAM in MB (excluding cache)
CURRENT_USAGE=$(free -m | awk '/^Mem:/{print $3}')

echo "-----------------------------------"
echo "Checking System Health..."
echo "Current Usage: ${CURRENT_USAGE} MB"
echo "Threshold:     ${MAX_RAM_MB} MB"
echo "-----------------------------------"

# 2. Always run the safe, silent cleaning
# This clears the harmless file cache every time you run the script.
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null

# 3. Decision Time: Do we need to restart Cinnamon?
if [ "$CURRENT_USAGE" -gt "$MAX_RAM_MB" ]; then
  echo "⚠️  RAM is consistently high."
  echo "   Performing Cinnamon Refresh..."

  # Run cinnamon --replace silently in the background
  nohup cinnamon --replace >/dev/null 2>&1 &

  echo "✅ Refresh triggered. Memory should drop in 2-3 seconds."
else
  echo "✅ RAM is within healthy limits."
  echo "   Skipping Cinnamon restart to avoid screen flicker."
fi

echo "-----------------------------------"
