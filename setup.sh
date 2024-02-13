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

# Destination directory
DEST="/usr/local/bin/FumeDev"

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Copy the script to the global path
cp "$START_SH_PATH" "$DEST"

# Make the script executable
chmod +x "$DEST"

echo "Script copied to $DEST"