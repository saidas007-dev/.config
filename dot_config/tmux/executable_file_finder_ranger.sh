#!/usr/bin/env bash
set -euo pipefail

SEARCH_ROOT="${1:-$HOME}"

if [[ "$SEARCH_ROOT" == "all" ]]; then
    echo "⚠️ Searching full system..."
    sleep 1
    SEARCH_ROOT="/"
fi

# Use fd if available (OPTIMIZED)
if command -v fd >/dev/null 2>&1; then
    SEARCH_CMD="fd --type f --hidden --exclude .git --no-follow . \"$SEARCH_ROOT\""
else
    SEARCH_CMD="find \"$SEARCH_ROOT\" -xdev 2>/dev/null"
fi

# --- CACHE SEARCH RESULTS FOR SPEED ---
TMP_CACHE=$(mktemp)

# Prevent runaway CPU
nice -n 10 bash -c "$SEARCH_CMD" > "$TMP_CACHE"

# --- FZF WITH LIGHTWEIGHT PREVIEW ---
file=$(fzf < "$TMP_CACHE" \
    --height=100% \
    --border=rounded \
    --layout=reverse \
    --prompt='▶ Search → ' \
    --preview 'ls -ld {} 2>/dev/null | head -n 1' \
    --preview-window=right:50% \
    --no-sort \
    --bind "ctrl-r:reload:cat $TMP_CACHE"
)

[[ -z "${file:-}" ]] && exit 0

# --- OPEN RANGER ---
tmux new-window -n "Ranger" \
    "cd '$(dirname "$file")' && ranger --selectfile='$(realpath "$file")'"

