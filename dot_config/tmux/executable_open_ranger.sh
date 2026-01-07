#!/usr/bin/env bash
set -euo pipefail

file="$1"
abs_path=$(realpath "$file")
dir_path=$(dirname "$abs_path")

# Open tmux popup and launch ranger
tmux display-popup -w 90% -h 85% -E "
cd '$dir_path' || exit
ranger --selectfile='$abs_path'
"
