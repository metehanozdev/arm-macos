#!/usr/bin/env bash

# The script's own path
SELF=$(realpath "$0")

REPO_URL="https://github.com/metehanozdev/arm-macos.git"
BASE_DIR="FumeDev" 


DIR_PATH="$HOME/Applications/$BASE_DIR"

if [ -d "$DIR_PATH" ]; then

    echo "Directory exists. Pulling latest changes..."
    cd "$DIR_PATH"
    git fetch --all
    git reset --hard origin/main

else
   
    echo "Directory does not exist. Cloning repository..."
    git clone "$REPO_URL" "$DIR_PATH"
fi


# Check if the DIR_PATH is defined
if [ -z "$DIR_PATH" ]; then
    echo "DIR_PATH is not set. Please set it before running the script."
    exit 1
fi

# Path to start.sh within the cloned repo
START_SH_PATH="$DIR_PATH/start.sh"

# Pip install the required packages
pip3 install -r "$DIR_PATH/requirements.txt"

# Ensure start.sh is executable
chmod +x "$START_SH_PATH"

SYMLINK_TARGET_DIR="$HOME/bin"
mkdir -p "$SYMLINK_TARGET_DIR"

# Add $HOME/bin to PATH if it's not already there
if ! echo "$PATH" | grep -q "$SYMLINK_TARGET_DIR"; then
    echo "export PATH=\"\$PATH:$SYMLINK_TARGET_DIR\"" >> "$HOME/.bash_profile"
    echo "export PATH=\"\$PATH:$SYMLINK_TARGET_DIR\"" >> "$HOME/.bashrc"
    echo "export PATH=\"\$PATH:$SYMLINK_TARGET_DIR\"" >> "$HOME/.zshrc"
    # Inform the user to restart the shell or source their profile
    echo "Added $SYMLINK_TARGET_DIR to PATH. Please restart your terminal or source your profile to update PATH."
fi

# Create a symbolic link for start.sh in $HOME/bin or another directory in PATH
SYMLINK_NAME="fumedev"
SYMLINK_PATH="$SYMLINK_TARGET_DIR/$SYMLINK_NAME"

ln -sf "$START_SH_PATH" "$SYMLINK_PATH"

echo "Symbolic link created for $SYMLINK_NAME at $SYMLINK_PATH. You can now use '$SYMLINK_NAME' to call the script."