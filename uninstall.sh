#!/usr/bin/env bash
set -euo pipefail

echo "=== tool_nudges uninstall ==="
echo ""

CONF_D="$HOME/.config/fish/conf.d"
FUNCTIONS="$HOME/.config/fish/functions"

remove_link() {
    local dest="$1"
    if [ -L "$dest" ]; then
        rm "$dest"
        echo "  Removed $dest"
    elif [ -e "$dest" ]; then
        echo "  WARNING: $dest exists but is not a symlink. Skipping."
    else
        echo "  $dest not found. Skipping."
    fi
}

echo "Removing fish symlinks..."
remove_link "$CONF_D/new_tools_reminder.fish"
remove_link "$FUNCTIONS/new_tools.fish"

echo ""
echo "Done. Open a new fish shell for changes to take effect."
