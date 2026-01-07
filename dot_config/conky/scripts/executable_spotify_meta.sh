#!/bin/bash
# Save as: ~/.config/conky/scripts/spotify_meta.sh

# 1. Get Metadata
ART_URL=$(playerctl -p spotify metadata mpris:artUrl 2>/dev/null)
ID=$(playerctl -p spotify metadata mpris:trackid 2>/dev/null)

# 2. Handle Album Art
CACHE_DIR="/tmp/conky_spotify"
mkdir -p "$CACHE_DIR"
COVER="$CACHE_DIR/cover.jpg"
TRACK_ID_FILE="$CACHE_DIR/track_id"

# Only download if the track changed
LAST_ID=$(cat "$TRACK_ID_FILE" 2>/dev/null)

if [ "$ID" != "$LAST_ID" ]; then
    echo "$ID" > "$TRACK_ID_FILE"
    if [ -n "$ART_URL" ]; then
        curl -s "$ART_URL" > "$COVER"
    else
        rm -f "$COVER"
    fi
fi
echo "$COVER"
