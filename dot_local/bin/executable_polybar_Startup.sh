#!/usr/bin/env bash

# 1. Terminate already running bar instances
# Since you have 'enable-ipc = true' in your config, this command is safe and faster.
polybar-msg cmd quit

# 2. Launch the bar named 'top' (matching [bar/top] in your config)
echo "---" | tee -a /tmp/polybar_top.log
polybar top 2>&1 | tee -a /tmp/polybar_top.log & disown

echo "Polybar launched..."
