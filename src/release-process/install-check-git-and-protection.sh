#!/usr/bin/env sh

#### INSTALLATION SCRIPT ####

# Define installation directories
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/check-git-and-protection"

# Ensure the directories exist
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR"

# List of scripts to fetch and install
SCRIPTS="check-git-branches-exist.sh check-github-branch-protection-using-jq.sh check-github-branch-protection.sh check-setup-git-and-protection.sh sem-ver-bump.sh group-commits.sh terminal-based-release.sh"

# Base URL for fetching scripts
BASE_URL="https://raw.githubusercontent.com/boromir674/automated-workflows/develop/scripts"

# Fetch and install each script
for script in $SCRIPTS; do
    echo "Fetching $script..."
    curl -fsSL "$BASE_URL/$script" -o "$CONFIG_DIR/$script"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch $script from $BASE_URL"
        exit 1
    fi
    chmod +x "$CONFIG_DIR/$script"
    ln -sf "$CONFIG_DIR/$script" "$BIN_DIR/$script"
    echo "Installed symbolic link for $script to $BIN_DIR"
done

# Add $BIN_DIR to PATH if not already present
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo "Adding $BIN_DIR to PATH"
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.profile"
    echo "Run 'source ~/.bashrc' or 'source ~/.profile' to update your PATH."
fi

# Optional: Create a default configuration file
echo "Creating default configuration at '$CONFIG_DIR/config.env'"
echo 'export MAIN_BRANCH=${MAIN_BRANCH:-main}' > "$CONFIG_DIR/config.env"
echo 'export RELEASE_BRANCH=${RELEASE_BRANCH:-release}' >> "$CONFIG_DIR/config.env"
echo 'export DEV_BRANCH=${DEV_BRANCH:-dev}' >> "$CONFIG_DIR/config.env"
echo "Configuration file created at $CONFIG_DIR/config.env"
echo
echo "**** Installation complete! Scripts are now available in your PATH. ****"

echo "       1: check-git-branches-exist.sh"
echo "      2a: check-github-branch-protection-using-jq.sh"
echo "      2b: check-github-branch-protection.sh"
echo
echo "  1 + 2 (a or b): check-setup-git-and-protection.sh"
