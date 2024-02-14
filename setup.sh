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

# Function to update PATH in the specified profile
update_path_in_profile() {
    PROFILE_PATH=$1
    if [ -f "$PROFILE_PATH" ]; then
        if ! grep -q "$DIR_PATH" "$PROFILE_PATH"; then
            echo "Adding $DIR_PATH to PATH in $PROFILE_PATH"
            echo "export PATH=\"\$PATH:$DIR_PATH\"" >> "$PROFILE_PATH"
        else
            echo "$DIR_PATH is already in PATH in $PROFILE_PATH."
        fi
    fi
}

# Bash profile paths (could be either depending on the system)
BASH_PROFILES=("$HOME/.bash_profile" "$HOME/.bashrc")

# Zsh profile path
ZSH_PROFILE="$HOME/.zshrc"

# Update PATH in Bash profiles
for PROFILE in "${BASH_PROFILES[@]}"; do
    update_path_in_profile "$PROFILE"
done

# Update PATH in Zsh profile
update_path_in_profile "$ZSH_PROFILE"

# Create a symbolic link named FumeDev pointing to start.sh
SYMLINK_NAME="FumeDev"
ln -sf "$START_SH_PATH" "$DIR_PATH/$SYMLINK_NAME"

echo "Symbolic link created for $SYMLINK_NAME. You can now use '$SYMLINK_NAME' to call the script."

echo "Please restart your terminal or source your profile(s) to update PATH."