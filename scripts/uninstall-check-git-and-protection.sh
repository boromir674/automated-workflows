#!/usr/bin/env sh

#### UNINSTALLATION SCRIPT ####

# Define installation directories
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/check-git-and-protection"

# List of scripts to uninstall
SCRIPTS="check-git-branches-exist.sh check-github-branch-protection-using-jq.sh check-github-branch-protection.sh check-setup-git-and-protection.sh"

# Remove symbolic links
echo "Removing symbolic links from $BIN_DIR..."
for script in $SCRIPTS; do
    if [ -L "$BIN_DIR/$script" ]; then
        rm "$BIN_DIR/$script"
        echo "Removed symbolic link: $BIN_DIR/$script"
    else
        echo "No symbolic link found for: $BIN_DIR/$script"
    fi
done

# Remove configuration directory
echo "Removing configuration directory: $CONFIG_DIR..."
if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    echo "Removed configuration directory: $CONFIG_DIR"
else
    echo "No configuration directory found at: $CONFIG_DIR"
fi

echo "Uninstallation complete."
