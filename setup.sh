#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Map CLI tool names to Homebrew package names (where they differ)
declare -A BREW_NAMES=(
    [rg]=ripgrep
    [http]=httpie
    [delta]=git-delta
)

echo "=== tool_nudges setup ==="
echo ""

# --- Symlinks ---
echo "Creating fish symlinks..."

CONF_D="$HOME/.config/fish/conf.d"
FUNCTIONS="$HOME/.config/fish/functions"
mkdir -p "$CONF_D" "$FUNCTIONS"

link_file() {
    local src="$1" dest="$2"
    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -e "$dest" ]; then
        echo "  WARNING: $dest already exists (not a symlink). Skipping."
        return
    fi
    ln -s "$src" "$dest"
    echo "  $dest -> $src"
}

link_file "$SCRIPT_DIR/new_tools_reminder.fish" "$CONF_D/new_tools_reminder.fish"
link_file "$SCRIPT_DIR/new_tools.fish" "$FUNCTIONS/new_tools.fish"

echo ""

# --- Tool installation ---
echo "The following tools are in the database:"
echo ""

# Parse tool names from YAML
TOOLS=()
while IFS= read -r line; do
    name=$(echo "$line" | sed -n 's/^  - name: //p')
    if [ -n "$name" ]; then
        TOOLS+=("$name")
    fi
done < "$SCRIPT_DIR/new_tools.yaml"

# Check which are installed and which are missing
MISSING=()
for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &>/dev/null; then
        echo "  [installed]  $tool"
    else
        echo "  [missing]    $tool"
        MISSING+=("$tool")
    fi
done

echo ""

if [ ${#MISSING[@]} -eq 0 ]; then
    echo "All tools are already installed!"
    echo ""
    echo "Done. Open a new fish shell to see it in action."
    exit 0
fi

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    BREW_PACKAGES=()
    for tool in "${MISSING[@]}"; do
        BREW_PACKAGES+=("${BREW_NAMES[$tool]:-$tool}")
    done
    echo "Homebrew not found. Install missing tools manually:"
    echo "  brew install ${BREW_PACKAGES[*]}"
    exit 0
fi

echo "Would you like to install the ${#MISSING[@]} missing tool(s)? [Y/n] "
read -r answer

BREW_PACKAGES=()
for tool in "${MISSING[@]}"; do
    BREW_PACKAGES+=("${BREW_NAMES[$tool]:-$tool}")
done

if [[ ! "$answer" =~ ^[Nn] ]]; then
    echo ""
    echo "--- Installing ${#BREW_PACKAGES[@]} tool(s): ${BREW_PACKAGES[*]} ---"
    brew install "${BREW_PACKAGES[@]}"
    echo ""
    echo "All tools installed!"
else
    echo ""
    echo "Skipped. You can install them later with:"
    echo "  brew install ${BREW_PACKAGES[*]}"
fi

echo ""
echo "Done. Open a new fish shell to see it in action."
