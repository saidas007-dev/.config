#!/bin/bash

# PATH TO YOUR SPOTIFY CONKY CONFIG
# Make sure this matches exactly where you saved the file from the previous step
CONKY_CONFIG="$HOME/.config/conky/conky_spotify.conf"

while true; do
  # Check if Spotify is running via playerctl (more reliable than process names)
  if playerctl -p spotify status &>/dev/null; then

    # Spotify is active. Is our Conky running?
    if ! pgrep -f "conky -c $CONKY_CONFIG" >/dev/null; then
      # No? Launch it.
      conky -c "$CONKY_CONFIG" &
    fi

  else
    # Spotify is NOT active. Kill the specific Conky instance.
    pkill -f "conky -c $CONKY_CONFIG"
  fi

  # Check again every 2 seconds
  sleep 2
done
